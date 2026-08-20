import requests
import logging
import pandas as pd
import os
import functools as ft

from dotenv import load_dotenv

from schemas.sql import SQLBase

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


def _fetch_sql(sql_request: SQLBase, variable_map: dict[str, str]):
    new_data = []
    updated_data = []

    url = "https://catalog.dvrpc.org/api/3/action/datastore_search_sql?sql=" + \
        sql_request['body']
    try:
        r = requests.get(url)
        r.raise_for_status()
        data = r.json()['result']['records']

        for row in data:
            geoid = row.pop('geoid')
            for key, value in row.items():

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

    except requests.exceptions.HTTPError as e:
        log.error(f"Failed to fetch ckan datastore: {e}")
        raise

    return new_data, updated_data


def fetch_ckan_data(sql_queries: list[SQLBase], variable_map: dict[str, str]):
    data = []
    new_data = []
    for query in sql_queries:
        log.info(f"Fetching CKAN: {query['name']}")
        try:
            new, updated = _fetch_sql(query, variable_map)
            data.extend(updated)
            new_data.extend(new)
        except Exception as e:
            log.error(f"Failed to fetch '{query['name']}': {e}")
    return data, new_data
