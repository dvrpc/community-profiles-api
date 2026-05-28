from .engine import get_gis_engine
import logging
import os
import pandas as pd
import functools as ft
from sqlalchemy.exc import OperationalError, ProgrammingError

dirname = os.path.dirname(__file__)
log = logging.getLogger(__name__)


def fetch_sql(file, geo):
    engine = get_gis_engine()
    file_path = os.path.join(dirname, f'sql/gis/{geo}/{file}.sql')

    try:
        df = pd.read_sql_query(open(file_path, "r").read(), engine)
        return df
    except (OperationalError, ProgrammingError) as err:
        log.error(f"Error executing: \n{file}.sql: \n{err}")


def get_county_data():
    log.info('Getting GIS county data...')
    spatial = fetch_sql("spatial", "county")
    pop_emp_forecasts = fetch_sql("pop_emp_forecasts", "county")
    land_use = fetch_sql("land_use", "county")

    dfs = [spatial, pop_emp_forecasts, land_use]
    county_merged = ft.reduce(lambda left, right: pd.merge(
        left, right, on='fips'), dfs)
    log.info(f'Retrieved ACS data for {len(county_merged)} counties')
    return county_merged


def get_muni_data():
    log.info('Getting GIS muni data...')
    spatial = fetch_sql("spatial", "muni")
    pop_emp_forecasts = fetch_sql("pop_emp_forecasts", "muni")
    land_use = fetch_sql("land_use", "muni")

    dfs = [spatial, pop_emp_forecasts, land_use]
    muni_merged = ft.reduce(lambda left, right: pd.merge(
        left, right, on='geoid'), dfs)
    log.info(f'Retrieved GIS data for {len(muni_merged)} municipalities')
    return muni_merged
