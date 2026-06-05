from repository.utils import fetch_many, fetch_one, execute_update
import logging

log = logging.getLogger(__name__)

async def find_all_variables():
    query = "SELECT v.*, ARRAY_AGG(geo_variable.geo_level) AS geo_levels FROM geo_variable LEFT JOIN variable v ON geo_variable.variable_id = v.id group by v.id"
    return await fetch_many(query)

async def find_variables_by_geo_level(geo_level: str):
    query = "SELECT v.*, geo_level FROM geo_variable LEFT JOIN variable v ON geo_variable.variable_id = v.id WHERE geo_variable.geo_level = %s;"
    return await fetch_many(query, (geo_level,))

async def find_by_variable_and_geo_level(variable_id: int, geo_level: str):
    query = "SELECT id FROM geo_variable where variable_id = %s and geo_level = %s;"
    return await fetch_one(query, (variable_id, geo_level))

async def create(variable_id: int, geo_level: str):
    query = 'INSERT INTO geo_variable (variable_id, geo_level) VALUES (%s, %s) RETURNING id, variable_id, geo_level;'
    return await execute_update(query, (variable_id, geo_level))

