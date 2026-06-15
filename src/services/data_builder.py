from typing import List

import psycopg

from data_builder import acs, gis, ckan, regional, engine

import repository.geo_variable_repository as geo_variable_repo
import repository.variable_repository as variable_repo
import repository.sql_repository as sql_repo
import repository.profile_repository as profile_repo
import repository.data_repository as data_repo
from schemas.variable import VariableRequest
import logging
from db.database import db
import asyncio
import logging

from schemas.data import Data


log = logging.getLogger(__name__)


async def upsert_data(data: List[Data], geo_level, data_source):
    log.info(f"{data_source} | {geo_level}: Upserting {len(data)} rows...")
    await data_repo.bulk_upsert(data)


async def _get_variable_map(key: str, data_source: str) -> dict[str, str]:
    variables = await variable_repo.find_variables_by_data_source(data_source)
    return {var[key]: var['id'] for var in variables}


async def build_new_sql_variable_data(variables, data_source: str):
    data = []
    variable_id_map = {}

    for v in variables:
        if v not in variable_id_map.keys():
            variable_name = v['variable_name']
            variableRequest = VariableRequest(
                data_source,
                name=variable_name,
                acs_variable=None,
                data_year=None,  # TODO?
                description=None,
                concept=v['sql_name'],
                aggregateable=False
            )
            res = await variable_repo.create(variableRequest)
            variable_id = res[0]
            variable_id_map[variable_name] = variable_id

        data.append({
            "geoid":           v['geoid'],
            "variable_id":     variable_id_map[v['variable_name']],
            "value":           v['value'],
            "margin_of_error": None
        })


async def build_all() -> None:
    await build_acs()
    await build_gis()
    await build_ckan()


async def build_acs(variable_map: dict[str, str] | None = None) -> None:
    if variable_map is None:
        raw_variable_map = await _get_variable_map('variable_id', 'acs')
        variable_map = acs.build_variable_map(raw_variable_map)

    county_acs = await asyncio.to_thread(acs.fetch_acs_data, variable_map, "county")
    await upsert_data(county_acs, "county", "acs")
    muni_acs = await asyncio.to_thread(acs.fetch_acs_data, variable_map, "municipality")
    await upsert_data(muni_acs, "municipality", "acs")


async def build_gis() -> None:
    county_gis_sql = await sql_repo.find_sql_by_geo_level_and_data_source("county", "gis")

    variable_map = await _get_variable_map('name', 'gis')
    county_gis_updated, county_gis_new = await asyncio.to_thread(gis.fetch_gis_data, county_gis_sql, variable_map)
    await upsert_data(county_gis_updated, "county", "gis")

    if (len(county_gis_new) > 0):
        bulk_new_data = await build_new_sql_variable_data(county_gis_new, 'gis')
        await upsert_data(bulk_new_data, 'county', 'gis')
        variable_map = await _get_variable_map('name', 'gis')

    muni_gis_sql = await sql_repo.find_sql_by_geo_level_and_data_source("municipality", "gis")
    muni_gis_updated, muni_gis_new = await asyncio.to_thread(gis.fetch_gis_data, muni_gis_sql, variable_map)

    await upsert_data(muni_gis_updated, "municipality", "gis")

    if (len(muni_gis_new) > 0):
        bulk_new_data = await build_new_sql_variable_data(muni_gis_new, 'gis')
        await upsert_data(bulk_new_data, "municipality", "gis")


async def build_ckan() -> None:
    variable_map = await _get_variable_map('name', 'ckan')
    county_ckan_sql = await sql_repo.find_sql_by_geo_level_and_data_source("county", "ckan")

    county_ckan_updated, county_ckan_new = await asyncio.to_thread(ckan.fetch_ckan_data, county_ckan_sql, variable_map)
    await upsert_data(county_ckan_updated, "county", "ckan")

    if (len(county_ckan_new) > 0):
        bulk_new_data = await build_new_sql_variable_data(county_ckan_new, 'ckan')
        await upsert_data(bulk_new_data, 'county', 'ckan')
        variable_map = await _get_variable_map('name', 'ckan')

    muni_ckan_sql = await sql_repo.find_sql_by_geo_level_and_data_source("municipality", "ckan")
    muni_ckan_updated, muni_ckan_new = await asyncio.to_thread(ckan.fetch_ckan_data, muni_ckan_sql, variable_map)

    await upsert_data(muni_ckan_updated, "municipality", "ckan")

    if (len(muni_ckan_new) > 0):
        bulk_new_data = await build_new_sql_variable_data(muni_ckan_new, 'ckan')
        await upsert_data(bulk_new_data, "municipality", "ckan")


async def build_regional() -> None:
    county_data = await regional.get_profile_data("SELECT * FROM county", "all county data")
    region_df = await regional.aggregate_data(county_data)
    # new_columns_schema = await get_new_columns_schema('region', region_df)
    # await _save_data(region_df, "region", new_columns_schema)
