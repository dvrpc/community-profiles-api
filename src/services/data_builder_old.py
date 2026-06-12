import psycopg

from data_builder import acs, gis, ckan, regional, engine

import repository.geo_variable_repository as geo_variable_repo
import repository.variable_repository as variable_repo
import repository.sql_repository as sql_repo
import repository.profile_repository as profile_repo
from schemas.variable import VariableRequest
import pandas as pd
import functools as ft
import logging
import numpy as np
from db.database import db
import asyncio

log = logging.getLogger(__name__)

COUNTY_EXCLUDED = {"fips", "state", "county", "co_name", "buffer_bbox"}
MUNI_EXCLUDED = {"geoid", "state", "county", "mun_name", "buffer_bbox"}
EXCLUDED = COUNTY_EXCLUDED | MUNI_EXCLUDED
MERGE_KEY = "geoid"


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


async def _save_data(df: pd.DataFrame, table: str, new_columns_schema: dict[str, str] | None = None) -> None:
    log.info("Writing dataframe to %s table", table)
    cols = ", ".join(f'"{c}"' for c in df.columns)
    placeholders = ", ".join(["%s"] * len(df.columns))

    # convert NaN / NA / inf to postgres friendly none type
    def _sanitize_value(v):
        try:
            if pd.isna(v):
                return None
        except Exception:
            pass
        try:
            if isinstance(v, (float, np.floating)) and np.isinf(v):
                return None
        except Exception:
            pass
        return v
    rows = [tuple(_sanitize_value(x) for x in row)
            for row in df.itertuples(index=False, name=None)]

    try:
        async with db.pool.connection() as conn:
            async with conn.cursor() as cur:
                await cur.execute(f'TRUNCATE TABLE "{table}"')
                if new_columns_schema:
                    alter_clauses = ", ".join(
                        f'ADD COLUMN IF NOT EXISTS "{col}" {col_type}'
                        for col, col_type in new_columns_schema.items()
                    )
                    await cur.execute(
                        f'ALTER TABLE "{table}" {alter_clauses}'
                    )
                await cur.executemany(f'INSERT INTO "{table}" ({cols}) VALUES ({placeholders})', rows)
                await conn.commit()
        log.info("Successfully wrote dataframe to %s table", table)
    except Exception as e:
        log.error("Error writing dataframe to %s table: %s", table, e)
        raise


async def _get_acs_variables() -> dict[str, str]:
    variables = await variable_repo.find_variables_by_data_source('acs')
    raw = {var['acs_variable']: var['name'] for var in variables}
    return acs.build_variable_map(raw)


async def _read_table(table: str) -> pd.DataFrame:
    try:
        profile = await profile_repo.find_profile(table)
        df = pd.DataFrame(profile)
        df = df.apply(to_numeric)
    except Exception as e:
        log.error(f"Error reading {table} from database: {e}")
        df = pd.DataFrame()

    return df


async def _create_missing_variable(variable_name: str, data_source: str, geo_level: str, concept: str = None) -> None:

    try:
        existing = await variable_repo.find_variable_by_name(variable_name)
        if existing:
            geo_var = await geo_variable_repo.find_by_variable_and_geo_level(existing['id'], geo_level)
            if not geo_var:
                await geo_variable_repo.create(existing['id'], geo_level)
                log.info(
                    f"Created missing geo_variable entry for {variable_name} at level {geo_level}")
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
            var_id = created_var[0]
            log.info(f"Created variable {variable_name} with id {var_id}")

            await geo_variable_repo.create(var_id, geo_level)
            log.info(
                f"Created geo_variable entry for {variable_name} at level {geo_level}")
    except Exception as e:
        log.error(f"Error creating variable {variable_name}: {e}")


async def get_new_columns_schema(table, fresh):
    existing = await _read_table(table)
    new_columns = [c for c in fresh.columns if c !=
                   MERGE_KEY and c not in existing.columns]
    new_columns_df = fresh[new_columns].apply(to_numeric)
    new_column_schema = {col: _pandas_dtype_to_sql(
        dt) for col, dt in new_columns_df.dtypes.items()}
    return new_column_schema


async def _update_columns(table: str, fresh: pd.DataFrame, metadata: dict = None) -> None:
    existing = await _read_table(table)

    existing[MERGE_KEY] = existing[MERGE_KEY].astype(str)
    fresh[MERGE_KEY] = fresh[MERGE_KEY].astype(str)

    stale = [c for c in fresh.columns if c !=
             MERGE_KEY and c in existing.columns]

    new_column_schema = await get_new_columns_schema(table, fresh)

    updated = (
        existing
        .drop(columns=stale)
        .merge(fresh, on=MERGE_KEY, how="left")
    )

    excluded_columns = ['geoid', 'state', 'county',
                        'co_name', 'mun_name', 'buffer_bbox']
    columns_to_update = [
        col for col in updated.columns if col not in excluded_columns]
    updated[columns_to_update] = updated[columns_to_update].apply(to_numeric)

    updated_variables = [
        col for col in fresh.columns
        if col != MERGE_KEY and col not in excluded_columns
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

    await _save_data(updated, table, new_column_schema)


async def build_all() -> None:
    await build_acs()
    await build_gis()
    await build_ckan()


async def build_acs(variable_map: dict[str, str] | None = None, rebuild_regional: bool = False) -> None:
    if variable_map is None:
        variable_map = await _get_acs_variables()
    county_acs = await asyncio.to_thread(acs.fetch_acs_data, variable_map, "county")
    county_acs = county_acs.rename(columns={"fips": "geoid"})
    muni_acs = await asyncio.to_thread(acs.fetch_acs_data, variable_map, "muni")

    await _update_columns("county", county_acs)
    await _update_columns("municipality", muni_acs)


async def build_gis() -> None:
    county_gis_sql = await sql_repo.find_sql_by_geo_level_and_data_source("county", "gis")
    muni_gis_sql = await sql_repo.find_sql_by_geo_level_and_data_source("municipality", "gis")

    county_gis, county_gis_metadata = await asyncio.to_thread(gis.get_county_data, county_gis_sql)
    county_gis = county_gis.rename(columns={"fips": "geoid"})
    muni_gis, muni_gis_metadata = await asyncio.to_thread(gis.get_muni_data, muni_gis_sql)

    await _update_columns("county", county_gis, county_gis_metadata)
    await _update_columns("municipality", muni_gis, muni_gis_metadata)

    gis_vars = muni_gis_metadata.keys() | county_gis_metadata.keys()
    await remove_obsolete_sql_variables(gis_vars, "gis")


async def build_ckan() -> None:

    county_ckan_sql = await sql_repo.find_sql_by_geo_level_and_data_source("county", "ckan")
    muni_ckan_sql = await sql_repo.find_sql_by_geo_level_and_data_source("municipality", "ckan")

    county_ckan, county_ckan_metadata = await asyncio.to_thread(ckan.get_county_data, county_ckan_sql)
    county_ckan = county_ckan.rename(columns={"fips": "geoid"})
    muni_ckan, muni_ckan_metadata = await asyncio.to_thread(ckan.get_muni_data, muni_ckan_sql)

    await _update_columns("county", county_ckan, county_ckan_metadata)
    await _update_columns("municipality", muni_ckan, muni_ckan_metadata)

    ckan_vars = muni_ckan_metadata.keys() | county_ckan_metadata.keys()
    await remove_obsolete_sql_variables(ckan_vars, "ckan")


async def build_regional() -> None:
    county_data = await regional.get_profile_data("SELECT * FROM county", "all county data")
    region_df = await regional.aggregate_data(county_data)
    new_columns_schema = await get_new_columns_schema('region', region_df)
    await _save_data(region_df, "region", new_columns_schema)


async def remove_obsolete_sql_variables(vars: list[str], data_source: str) -> None:
    source_vars = await variable_repo.find_variables_by_data_source(data_source)
    for var in source_vars:
        if var['name'] not in vars:
            log.info(
                f"Variable {var['name']} no longer in {data_source} source, deleting from variable and geo_variable tables")
            # cascade deletes from geo_variable
            await variable_repo.delete(var['id'])


async def recalibrate_variables() -> None:
    """Drop columns in profile where variable is no longer assigned to that geo level."""
    for geo_level in ["county", "municipality", "region"]:
        variables = await geo_variable_repo.find_variables_by_geo_level(geo_level)
        all_variables = set()
        for var in variables:
            all_variables.add(var['name'])
            all_variables.add(var['name'] + '_moe')

        df = await _read_table(geo_level)
        profile_vars = [
            col for col in df.columns
            if col not in EXCLUDED
        ]

        for p_var in profile_vars:
            if p_var not in all_variables:
                log.info(
                    f"Variable {p_var} in {geo_level} table not found in variable repository, deleting column")
                await profile_repo.delete_variable_by_table(p_var, geo_level)
