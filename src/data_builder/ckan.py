import requests
import logging
import pandas as pd
import os
import functools as ft

from dotenv import load_dotenv

from schemas.sql import SQLRequest

log = logging.getLogger(__name__)
load_dotenv()

dirname = os.path.dirname(__file__)


def _fetch_datastore(sql):
    url = "https://catalog.dvrpc.org/api/3/action/datastore_search_sql?sql=" + sql
    try:
        r = requests.get(url)
        r.raise_for_status()
        data = r.json()['result']['records']
        return pd.DataFrame(data)

    except requests.exceptions.HTTPError as e:
        log.error(f"Failed to fetch ckan datastore: {e}")
        raise
    
def _build_dfs(sql_queries: list[SQLRequest]):
    dfs = []
    for sql_query in sql_queries:
        log.info(f"Executing: {sql_query['name']} | {sql_query['data_source']} | {sql_query['geo_level']}")
        df = _fetch_datastore(sql_query['body'])
        dfs.append(df)
    return dfs

def get_county_data(sql_queries: list[SQLRequest]):
    log.info('Getting CKAN county data...')
    dfs = _build_dfs(sql_queries)

    county_merged = ft.reduce(lambda left, right: pd.merge(
        left, right, on='fips'), dfs)
    log.info(f'Retrieved CKAN data for {len(county_merged)} counties')
    return county_merged


def get_muni_data(sql_queries: list[SQLRequest]):
    log.info('Getting CKAN municipality data...')
    dfs = _build_dfs(sql_queries)

    muni_merged = ft.reduce(lambda left, right: pd.merge(
        left, right, on='geoid'), dfs)
    log.info(
        f'Retrieved CKAN data for {len(muni_merged)} municipalities')

    return muni_merged
