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


def _fetch_sql(sql_request: SQLRequest, variable_map: dict[str, str]):
    new_data = []
    updated_data = []
    try:
        with engine.begin() as connection:
            result = connection.execute(text(sql_request['body']))
            headers = result.keys()
            for row in result:
                row_dict = dict(zip(headers, row))
                geoid = row_dict.pop('geoid')
                for key, value in row_dict.items():
                    if key in variable_map:
                        updated_data.append({
                            "geoid":           geoid,
                            "variable_id":     variable_map[key],
                            "value":           value,
                            "margin_of_error": None
                        })
                    else:
                        new_data.append({
                            "geoid":           geoid,
                            "variable_name":     key,
                            "value":           value,
                            "sql_name": sql_request['name']
                        })

    except (OperationalError, ProgrammingError) as e:
        log.error(f"SQL execution error: {e}")

    return new_data, updated_data


def fetch_gis_data(sql_queries: list[SQLRequest], variable_map: dict[str, str]):
    data = []
    new_data = []
    for query in sql_queries:
        log.info(f"Fetching SQL: {query['name']}")
        try:
            new_data, updated_data = _fetch_sql(query, variable_map)
            data.extend(updated_data)
            new_data.extend(new_data)
        except Exception as e:
            log.error(f"Failed to fetch '{query['name']}': {e}")
    return data, new_data
