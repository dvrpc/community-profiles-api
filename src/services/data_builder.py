from data_builder import acs, gis, ckan, regional, engine
from repository.variable_repository import find_variables_by_data_source
import pandas as pd
import functools as ft
import logging
from db.database import db

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

def _save_data(df: pd.DataFrame, table: str) -> None:
    log.info("Writing dataframe to %s table", table)
    col_defs = ", ".join(f'"{c}" {_pandas_dtype_to_sql(df[c].dtype)}' for c in df.columns)
    cols = ", ".join(f'"{c}"' for c in df.columns)
    placeholders = ", ".join(["%s"] * len(df.columns))
    rows = [tuple(row) for row in df.itertuples(index=False, name=None)]

    try:
        with db.conn.cursor() as cur:
            cur.execute(f'DROP TABLE IF EXISTS "{table}"')
            cur.execute(f'CREATE TABLE "{table}" ({col_defs})')
            cur.executemany(f'INSERT INTO "{table}" ({cols}) VALUES ({placeholders})', rows)
            db.conn.commit()
        log.info("Successfully wrote dataframe to %s table", table)
    except Exception as e:
        log.error("Error writing dataframe to %s table: %s", table, e)
        db.conn.rollback()
        raise


async def _get_acs_variables() -> dict[str, str]:
    variables = await find_variables_by_data_source('acs')
    raw = {var['acs_variable']: var['name'] for var in variables}
    return acs.build_variable_map(raw)

def _read_table(table: str) -> pd.DataFrame:
    try:
        with db.conn.cursor() as cur:
            cur.execute(f'SELECT * FROM "{table}"')
            rows = cur.fetchall()
            columns = [col.name for col in cur.description]
            df = pd.DataFrame(rows, columns=columns)
            df = df.apply(to_numeric)
            return df
    except Exception as e:
        log.error(f'Error reading table {table}: {e}')
        db.conn.rollback()
        return pd.DataFrame()

def _rebuild_regional() -> None:
    county_data = regional.get_profile_data("SELECT * FROM county", "all county data")
    _save_data(regional.aggregate_data(county_data), "region")

    
def _update_columns(table: str, merge_key: str, fresh: pd.DataFrame) -> None:
    existing = _read_table(table)

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
    _save_data(updated, table)



async def build_all() -> None:
    await build_acs()
    build_gis()
    build_ckan()
    _rebuild_regional()


async def build_acs(variable_map: dict[str, str] | None = None) -> None:
    if variable_map is None:
        variable_map = await _get_acs_variables()

    county_acs = acs.fetch_acs_data(variable_map, geo="county").rename(columns={"fips": "geoid"})
    muni_acs   = acs.fetch_acs_data(variable_map, geo="muni")

    _update_columns("county",       "geoid", county_acs)
    _update_columns("municipality", "geoid", muni_acs)
    _rebuild_regional()


def build_gis() -> None:
    county_gis = gis.get_county_data().rename(columns={"fips": "geoid"})
    muni_gis   = gis.get_muni_data()

    _update_columns("county",       "geoid", county_gis)
    _update_columns("municipality", "geoid", muni_gis)
    _rebuild_regional()


def build_ckan() -> None:
    county_ckan = ckan.get_county_data().rename(columns={"fips": "geoid"})
    muni_ckan   = ckan.get_muni_data()

    _update_columns("county",       "geoid", county_ckan)
    _update_columns("municipality", "geoid", muni_ckan)
    _rebuild_regional()


