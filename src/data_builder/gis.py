from schemas.sql import SQLRequest

from .engine import get_gis_engine
import logging
import os
import pandas as pd
import functools as ft
from sqlalchemy.exc import OperationalError, ProgrammingError
from sqlalchemy import text

dirname = os.path.dirname(__file__)
log = logging.getLogger(__name__)
engine = get_gis_engine()


def _fetch_sql(body: str):
    data = []
    with engine.begin() as connection:
        result = connection.execute(text(body))
        headers = result.keys()
        for row in result:
            row_dict = dict(zip(headers, row))
            geoid = row_dict.pop('geoid')
            for key, value in row_dict:
                data.append({
                    "geoid":            geoid,
                    "variable_id":     variable_map[base + 'E'],
                    "value":            row[e_idx] if e_idx is not None else None,
                    "margin_of_error":  row[m_idx] if m_idx is not None else None,
                })


def _build_dfs(sql_queries: list[SQLRequest]):
    dfs = []
    column_metadata = {}
    for sql_query in sql_queries:
        log.info(
            f"Executing: {sql_query['name']} | {sql_query['data_source']} | {sql_query['geo_level']}")
        df = _fetch_sql(sql_query['body'])
        dfs.append(df)

        # Capture metadata for each column in this query
        for col in df.columns:
            if col not in ['fips', 'geoid']:
                column_metadata[col] = {
                    'concept': sql_query['name'],
                    'data_source': sql_query['data_source'],
                    'geo_level': sql_query['geo_level']
                }
    return dfs, column_metadata


def get_county_data(sql_queries: list[SQLRequest]):
    dfs, column_metadata = _build_dfs(sql_queries)

    county_merged = ft.reduce(lambda left, right: pd.merge(
        left, right, on='fips'), dfs)
    log.info(f'Retrieved GIS data for {len(county_merged)} counties')
    return county_merged, column_metadata


def get_muni_data(sql_queries: list[SQLRequest]):
    dfs, column_metadata = _build_dfs(sql_queries)

    muni_merged = ft.reduce(lambda left, right: pd.merge(
        left, right, on='geoid'), dfs)
    log.info(f'Retrieved GIS data for {len(muni_merged)} municipalities')
    return muni_merged, column_metadata
