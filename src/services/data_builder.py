from data_builder import acs, gis, ckan, regional, engine

import repository.geo_variable_repository as geo_variable_repo
import repository.variable_repository as variable_repo
import repository.sql_repository as sql_repo
import repository.profile_repository as profile_repo
from schemas.variable import VariableRequest
import pandas as pd
import functools as ft
import logging
from db.database import db
import asyncio

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)

COUNTY_EXCLUDED = {"fips", "state", "county", "co_name", "buffer_bbox"}
MUNI_EXCLUDED = {"geoid", "state", "county", "mun_name", "buffer_bbox"}

def to_numeric(s):
    try:
        return pd.to_numeric(s, errors='raise')
    except ValueError:
        return s

def _pandas_dtype_to_sql(dtype) -> str:
    if pd.api.types.is_integer_dtype(dtype):
        return "BIGINT"
    elif pd.api.types.is_float_dtype(dtype):
        return "DOUBLE PRECISION"
    elif pd.api.types.is_bool_dtype(dtype):
        return "BOOLEAN"
    else:
        return "TEXT"

async def _save_data(df: pd.DataFrame, table: str) -> None:
    log.info("Writing dataframe to %s table", table)
    col_defs = ", ".join(f'"{c}" {_pandas_dtype_to_sql(df[c].dtype)}' for c in df.columns)
    cols = ", ".join(f'"{c}"' for c in df.columns)
    placeholders = ", ".join(["%s"] * len(df.columns))
    rows = [tuple(row) for row in df.itertuples(index=False, name=None)]

    try:
        async with db.conn.cursor() as cur:
            await cur.execute(f'DROP TABLE IF EXISTS "{table}"')
            await cur.execute(f'CREATE TABLE "{table}" ({col_defs})')
            await cur.executemany(f'INSERT INTO "{table}" ({cols}) VALUES ({placeholders})', rows)
            await db.conn.commit()
        log.info("Successfully wrote dataframe to %s table", table)
    except Exception as e:
        log.error("Error writing dataframe to %s table: %s", table, e)
        await db.conn.rollback()
        raise


async def _get_acs_variables() -> dict[str, str]:
    variables = await variable_repo.find_variables_by_data_source('acs')
    raw = {var['acs_variable']: var['name'] for var in variables}
    return acs.build_variable_map(raw)

async def _read_table(table: str) -> pd.DataFrame:
    try:
        async with db.conn.cursor() as cur:
            await cur.execute(f'SELECT * FROM "{table}"')
            rows = await cur.fetchall()
            columns = [col.name for col in cur.description]
            df = pd.DataFrame(rows, columns=columns)
            df = df.apply(to_numeric)
            return df
    except Exception as e:
        log.error(f'Error reading table {table}: {e}')
        await db.conn.rollback()
        return pd.DataFrame()

async def _rebuild_regional() -> None:
    county_data = await regional.get_profile_data("SELECT * FROM county", "all county data")
    region_df = await regional.aggregate_data(county_data)
    await _save_data(region_df, "region")


async def _create_missing_variable(variable_name: str, data_source: str, geo_level: str, concept: str = None) -> None:

    try:
        existing = await variable_repo.find_variable_by_name(variable_name)
        if existing:            
            geo_var = await geo_variable_repo.find_by_variable_and_geo_level(existing['id'], geo_level)
            if not geo_var:
                await geo_variable_repo.create(existing['id'], geo_level)
                log.info(f"Created missing geo_variable entry for {variable_name} at level {geo_level}")
            return
        
        new_variable = VariableRequest(
            name=variable_name,
            data_source=data_source,
            acs_variable=None,
            data_year=None,
            description=None,
            concept=concept,
            aggregateable=True
        )
        
        created_var = await variable_repo.create(new_variable)
        if created_var:
            var_id = created_var[0]['id']
            log.info(f"Created variable {variable_name} with id {var_id}")
            
            await geo_variable_repo.create(var_id, geo_level)
            log.info(f"Created geo_variable entry for {variable_name} at level {geo_level}")
    except Exception as e:
        log.error(f"Error creating variable {variable_name}: {e}")

    
async def _update_columns(table: str, merge_key: str, fresh: pd.DataFrame, metadata: dict = None) -> None:
    existing = await _read_table(table)

    # Normalize merge keys to string
    existing[merge_key] = existing[merge_key].astype(str)
    fresh[merge_key] = fresh[merge_key].astype(str)

    stale = [c for c in fresh.columns if c != merge_key and c in existing.columns]

    updated = (
        existing
        .drop(columns=stale)
        .merge(fresh, on=merge_key, how="left")
    )

    excluded_columns = ['geoid', 'state', 'county', 'co_name', 'mun_name', 'buffer_bbox']
    columns_to_update = [
        col for col in updated.columns if col not in excluded_columns]
    updated[columns_to_update] = updated[columns_to_update].apply(to_numeric)

    updated_variables = [
        col for col in fresh.columns
        if col != merge_key and col not in excluded_columns
    ]
    await variable_repo.set_variable_update_time(updated_variables)
    
    if metadata is not None:
        for var_name in updated_variables:
            if var_name in metadata:
                meta = metadata[var_name]
                await _create_missing_variable(
                    var_name,
                    meta['data_source'],
                    table,
                    concept=meta.get('concept')
                )
    
    await _save_data(updated, table)



async def build_all() -> None:
    await build_acs()
    await build_gis()
    await build_ckan()
    await _rebuild_regional()


async def build_acs(variable_map: dict[str, str] | None = None) -> None:
    if variable_map is None:
        variable_map = await _get_acs_variables()
    county_acs = await asyncio.to_thread(acs.fetch_acs_data, variable_map, "county")
    county_acs = county_acs.rename(columns={"fips": "geoid"})
    muni_acs = await asyncio.to_thread(acs.fetch_acs_data, variable_map, "muni")

    await _update_columns("county", "geoid", county_acs)
    await _update_columns("municipality", "geoid", muni_acs)
    await _rebuild_regional()


async def build_gis() -> None:
    county_gis_sql = await sql_repo.find_sql_by_geo_level_and_data_source("county", "gis")
    muni_gis_sql = await sql_repo.find_sql_by_geo_level_and_data_source("municipality", "gis")

    county_gis, county_gis_metadata = await asyncio.to_thread(gis.get_county_data, county_gis_sql)
    county_gis = county_gis.rename(columns={"fips": "geoid"})
    muni_gis, muni_gis_metadata = await asyncio.to_thread(gis.get_muni_data, muni_gis_sql)
    
    await _update_columns("county", "geoid", county_gis, county_gis_metadata)
    await _update_columns("municipality", "geoid", muni_gis, muni_gis_metadata)
    await _rebuild_regional()


async def build_ckan() -> None:
    
    county_ckan_sql = await sql_repo.find_sql_by_geo_level_and_data_source("county", "ckan")
    muni_ckan_sql = await sql_repo.find_sql_by_geo_level_and_data_source("municipality", "ckan")
    
    county_ckan, county_ckan_metadata = await asyncio.to_thread(ckan.get_county_data, county_ckan_sql)
    county_ckan = county_ckan.rename(columns={"fips": "geoid"})
    muni_ckan, muni_ckan_metadata = await asyncio.to_thread(ckan.get_muni_data, muni_ckan_sql)

    await _update_columns("county", "geoid", county_ckan, county_ckan_metadata)
    await _update_columns("municipality", "geoid", muni_ckan, muni_ckan_metadata)
    await _rebuild_regional()
    await recalibrate_variables()
    
async def recalibrate_variables() -> None:
    """Drop columns in profile where variable is no longer assigned to that geo level."""
    county = await _read_table("county")
    muni = await _read_table("municipality")
    regional = await _read_table("region")
    # regional = await _read_table("region")
    county_variables = await geo_variable_repo.find_variables_by_geo_level("county")
    muni_variables = await geo_variable_repo.find_variables_by_geo_level("municipality")
    county_variables = [var['name'] for var in county_variables]
    muni_variables = [var['name'] for var in muni_variables]
    regional_variables = await geo_variable_repo.find_variables_by_geo_level("region")
    regional_variables = [var['name'] for var in regional_variables]

    for df, variables, table in [(county, county_variables, "county"), (muni, muni_variables, "municipality"), (regional, regional_variables, "region")]:
        profile_vars = [col for col in df.columns if col not in COUNTY_EXCLUDED.union(MUNI_EXCLUDED) and not col.endswith("_moe")]
        for p_var in profile_vars:
            if p_var not in variables:
                log.info(f"Variable {p_var} in {table} table not found in variable repository, deleting column")


