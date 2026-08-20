from typing import List

import psycopg

from data_builder import acs, gis, ckan, regional, engine

import repository.variable_repository as variable_repo
import repository.sql_repository as sql_repo
import services.profile as profile_service
import repository.data_repository as data_repo
from schemas.variable import VariableCreate
import logging
from db.database import db
import asyncio
import logging

from schemas.data import Data


log = logging.getLogger(__name__)


async def upsert_data(data: List[Data], geo_level, data_source):
    if len(data) == 0:
        log.info(f"{data_source} | {geo_level}: No data to upsert")
        return
    log.info(f"{data_source} | {geo_level}: Upserting {len(data)} rows...")
    if geo_level == "regional":
        await data_repo.bulk_regional_upsert(data)
    else:
        await data_repo.bulk_upsert(data)


async def _get_variable_map(key: str, data_source: str) -> dict[str, str]:
    variables = await variable_repo.find_variables_by_data_source(data_source)
    return {var[key]: var['id'] for var in variables}


async def build_new_sql_variable_data(variables, data_source: str):
    data = []
    variable_id_map = {}

    for v in variables:
        name = v['variable_name']
        if name not in variable_id_map.keys():
            variableRequest = VariableCreate(
                data_source=data_source,
                name=name,
                acs_variable=None,
                description=None,
                concept=v['sql_name'],
                aggregateable=False
            )
            res = await variable_repo.create(variableRequest)
            variable_id = res[0]
            variable_id_map[name] = variable_id

        data.append({
            "geoid":           v['geoid'],
            "variable_id":     variable_id_map[name],
            "value":           v['value'],
            "margin_of_error": None
        })
    return data


async def remove_stale_sql_vars(variable_map, updated):
    all_updated_vars = {v['variable_id']
                        for v in updated}

    for value in variable_map.values():
        if value not in all_updated_vars:
            await variable_repo.delete(value)


async def build_all(acs_year: int | None) -> None:
    await build_acs(acs_year=acs_year)
    await build_gis()
    await build_ckan()


async def build_acs(
    variable_map: dict[str, str] | None = None, acs_year: int | None = None
) -> None:
    if acs_year is None:
        raise ValueError("acs_year is required for an ACS build")

    if variable_map is None:
        raw_variable_map = await _get_variable_map('acs_variable', 'acs')
        variable_map = acs.build_variable_map(raw_variable_map)

    county_acs = await asyncio.to_thread(acs.fetch_acs_data, variable_map, "county", acs_year)
    await upsert_data(county_acs, "county", "acs")
    muni_acs = await asyncio.to_thread(acs.fetch_acs_data, variable_map, "municipality", acs_year)
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

    remove_stale_sql_vars(variable_map, muni_gis_updated + county_gis_updated)


async def build_ckan() -> None:
    variable_map = await _get_variable_map('name', 'ckan')
    county_ckan_sql = await sql_repo.find_sql_by_geo_level_and_data_source("county", "ckan")

    county_ckan_updated, county_ckan_new = await asyncio.to_thread(ckan.fetch_ckan_data, county_ckan_sql, variable_map)
    await upsert_data(county_ckan_updated, "county", "ckan")
    if (len(county_ckan_new) > 0):
        await upsert_data(bulk_new_data, 'county', 'ckan')
        variable_map = await _get_variable_map('name', 'ckan')

    muni_ckan_sql = await sql_repo.find_sql_by_geo_level_and_data_source("municipality", "ckan")
    muni_ckan_updated, muni_ckan_new = await asyncio.to_thread(ckan.fetch_ckan_data, muni_ckan_sql, variable_map)

    await upsert_data(muni_ckan_updated, "municipality", "ckan")

    if (len(muni_ckan_new) > 0):
        bulk_new_data = await build_new_sql_variable_data(muni_ckan_new, 'ckan')
        await upsert_data(bulk_new_data, "municipality", "ckan")

    await remove_stale_sql_vars(variable_map, county_ckan_updated + muni_ckan_updated)


async def build_regional() -> None:
    regional_data = await data_repo.get_aggregateable_regional_data()
    await upsert_data(regional_data, "regional", "all")
