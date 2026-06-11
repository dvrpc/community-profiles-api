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


async def _get_acs_variables() -> dict[str, str]:
    variables = await variable_repo.find_variables_by_data_source('acs')
    raw = {var['acs_variable']: var['id'] for var in variables}
    return acs.build_variable_map(raw)

async def build_all() -> None:
    await build_acs()
    await build_gis()
    await build_ckan()

async def build_acs(variable_map: dict[str, str] | None = None, rebuild_regional: bool = False) -> None:
    #TODO: passed variable_map through routes does not include margin of error yet
    if variable_map is None:
        variable_map = await _get_acs_variables()
    county_acs = await asyncio.to_thread(acs.fetch_acs_data, variable_map, "county")
    county_acs = county_acs.rename(columns={"fips": "geoid"})
    muni_acs = await asyncio.to_thread(acs.fetch_acs_data, variable_map, "muni")
    print(county_acs)


async def build_gis() -> None:
    county_gis_sql = await sql_repo.find_sql_by_geo_level_and_data_source("county", "gis")
    muni_gis_sql = await sql_repo.find_sql_by_geo_level_and_data_source("municipality", "gis")

    county_gis, county_gis_metadata = await asyncio.to_thread(gis.get_county_data, county_gis_sql)
    county_gis = county_gis.rename(columns={"fips": "geoid"})
    muni_gis, muni_gis_metadata = await asyncio.to_thread(gis.get_muni_data, muni_gis_sql)

    # await _update_columns("county", county_gis, county_gis_metadata)
    # await _update_columns("municipality", muni_gis, muni_gis_metadata)

    # gis_vars = muni_gis_metadata.keys() | county_gis_metadata.keys()
    # print(gis_vars)
    # await remove_obsolete_sql_variables(gis_vars, "gis")

async def build_ckan() -> None:

    county_ckan_sql = await sql_repo.find_sql_by_geo_level_and_data_source("county", "ckan")
    muni_ckan_sql = await sql_repo.find_sql_by_geo_level_and_data_source("municipality", "ckan")

    county_ckan, county_ckan_metadata = await asyncio.to_thread(ckan.get_county_data, county_ckan_sql)
    county_ckan = county_ckan.rename(columns={"fips": "geoid"})
    muni_ckan, muni_ckan_metadata = await asyncio.to_thread(ckan.get_muni_data, muni_ckan_sql)

    # await _update_columns("county", county_ckan, county_ckan_metadata)
    # await _update_columns("municipality", muni_ckan, muni_ckan_metadata)

    # ckan_vars = muni_ckan_metadata.keys() | county_ckan_metadata.keys()
    # await remove_obsolete_sql_variables(ckan_vars, "ckan")


async def build_regional() -> None:
    county_data = await regional.get_profile_data("SELECT * FROM county", "all county data")
    region_df = await regional.aggregate_data(county_data)
    # new_columns_schema = await get_new_columns_schema('region', region_df)
    # await _save_data(region_df, "region", new_columns_schema)