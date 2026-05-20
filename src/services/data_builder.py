from data_builder import acs, gis, ckan, regional, engine
from repository.variable_repository import find_variables_by_data_source
import pandas as pd
import functools as ft
import logging

logging.basicConfig(level=logging.INFO)
log = logging.getLogger(__name__)


def _clean_update_df(df: pd.DataFrame, geo: str) -> pd.DataFrame:
    exclude = {'state', 'county', 'NAME', 'county subdivision', 'mun_name'}
    return df[[c for c in df.columns if c not in exclude]]


def _read_table(table: str) -> pd.DataFrame:
    engine_ = engine.get_write_engine()
    try:
        return pd.read_sql_query(f'SELECT * FROM {table}', engine_)
    finally:
        engine_.dispose()


def _merge_component(base_df: pd.DataFrame, component_df: pd.DataFrame, merge_key: str, geo: str) -> pd.DataFrame:
    component_df = _clean_update_df(component_df, geo)
    if merge_key not in component_df.columns:
        raise ValueError(f'Missing merge key {merge_key} in component data')

    update_columns = [c for c in component_df.columns if c != merge_key]
    base_df = base_df.drop(columns=[c for c in update_columns if c in base_df.columns], errors='ignore')
    return base_df.merge(component_df, on=merge_key, how='left')


def _update_table_component(table: str, component_df: pd.DataFrame, merge_key: str, geo: str):
    log.info(f'Updating {table} table with {geo} component data...')
    base_df = _read_table(table)
    updated_df = _merge_component(base_df, component_df, merge_key, geo)
    save_data(updated_df, table)


# Build / updates single acs variable for all geo levels
def update_acs_variables(variable_map: dict[str, str], acs_year: int = 2024):
    county_data = acs.get_county_data(variable_map, acs_year)
    muni_data = acs.get_muni_data(variable_map, acs_year)

    _update_table_component('county', county_data, 'fips', 'county')
    _update_table_component('municipality', muni_data, 'geoid', 'muni')

    build_all_regional_data()
    return {
        'status': 'success',
        'category': 'acs',
        'variables': list(variable_map.values()),
    }


async def build_all():
    variables = await find_variables_by_data_source('acs')
    variable_dict = {var['acs_variable']: var['name'] for var in variables if var.get('acs_variable')}
    variable_map = acs.build_variable_map(variable_dict)

    build_all_county_data(variable_map)
    build_all_muni_data(variable_map)
    build_all_regional_data()

    return {'status': 'success', 'category': 'all'}


async def build_acs(variables: dict[str, str], acs_year: int = 2024):
    variable_map = acs.build_variable_map(variables)
    return update_acs_variables(variable_map, acs_year)


async def build_gis():
    build_gis_data()
    build_all_regional_data()
    return {'status': 'success', 'category': 'gis'}


async def build_catalog():
    build_catalog_data()
    build_all_regional_data()
    return {'status': 'success', 'category': 'catalog'}


def save_data(df: pd.DataFrame, table):
    log.info(f'Writing dataframe to {table} table')
    engine_ = engine.get_write_engine()
    try:
        df.to_sql(table, engine_, if_exists='replace', index=False)
        log.info(f'Successfully wrote Dataframe to {table} table')
    except Exception as e:
        log.error(f'Error writing Dataframe to {table} table: {e}')
    finally:
        engine_.dispose()


def to_numeric(s):
    try:
        return pd.to_numeric(s, errors='raise')
    except ValueError:
        return s


def build_all_county_data(variable_map):
    acs_data = acs.get_county_data(variable_map)
    gis_data = gis.get_county_data()
    ckan_data = ckan.get_county_data()

    dfs = [acs_data, gis_data, ckan_data]
    df_merged = ft.reduce(lambda left, right: pd.merge(
        left, right, on='fips'), dfs)

    excluded_columns = ['fips', 'state', 'county', 'co_name', 'buffer_bbox']
    columns_to_update = [
        col for col in df_merged.columns if col not in excluded_columns]
    df_merged[columns_to_update] = df_merged[columns_to_update].apply(
        pd.to_numeric)

    df_merged = df_merged.rename(columns={'fips': 'geoid'})
    save_data(df_merged, 'county')


def build_all_muni_data(variable_map):
    acs_data = acs.get_muni_data(variable_map)
    gis_data = gis.get_muni_data()
    ckan_data = ckan.get_muni_data()

    dfs = [acs_data, gis_data, ckan_data]
    df_merged = ft.reduce(lambda left, right: pd.merge(
        left, right, on='geoid', how='left'), dfs)

    excluded_columns = ['geoid', 'state', 'county', 'mun_name', 'buffer_bbox']
    columns_to_update = [
        col for col in df_merged.columns if col not in excluded_columns]
    df_merged[columns_to_update] = df_merged[columns_to_update].apply(
        to_numeric)

    save_data(df_merged, 'municipality')


def build_gis_data():
    county_data = gis.get_county_data()
    muni_data = gis.get_muni_data()

    _update_table_component('county', county_data, 'fips', 'county')
    _update_table_component('municipality', muni_data, 'geoid', 'muni')


def build_catalog_data():
    county_data = ckan.get_county_data()
    muni_data = ckan.get_muni_data()

    _update_table_component('county', county_data, 'fips', 'county')
    _update_table_component('municipality', muni_data, 'geoid', 'muni')


def build_all_regional_data():
    county_data = regional.get_profile_data(
        "SELECT * FROM county", "all county data")

    regional_data = regional.aggregate_data(county_data)
    print(regional_data)
    save_data(regional_data, 'region')

    # Averages median/mean/pct fields and margin of error
    # county_data = regional.average_data(county_data)
    # save_data(county_data, 'region')
