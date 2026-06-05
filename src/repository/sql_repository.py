from repository.utils import fetch_many, fetch_one, execute_update
import logging

log = logging.getLogger(__name__)


async def find_all_sql():
    query = 'SELECT id, name, data_source, geo_level, body FROM "sql" ORDER BY id'
    return await fetch_many(query)


async def find_sql(id: int):
    query = 'SELECT id, name, data_source, geo_level, body FROM "sql" WHERE id = %s'
    return await fetch_one(query, (id,))

async def find_sql_by_geo_level_and_data_source(geo_level: str, data_source: str):
    query = 'SELECT id, name, data_source, geo_level, body FROM "sql" WHERE geo_level = %s AND data_source = %s'
    return await fetch_many(query, (geo_level, data_source))

async def create_sql(sql_def):
    query = 'INSERT INTO "sql" (name, data_source, geo_level, body) VALUES (%s, %s, %s, %s) RETURNING id, name, data_source, geo_level, body;'
    return await execute_update(query, (sql_def.name, sql_def.data_source, sql_def.geo_level, sql_def.body))


async def update_sql(id: int, sql_def):
    query = 'UPDATE "sql" SET name = %s, data_source = %s, geo_level = %s, body = %s WHERE id = %s RETURNING id, name, data_source, geo_level, body;'
    return await execute_update(query, (sql_def.name, sql_def.data_source, sql_def.geo_level, sql_def.body, id))


async def delete_sql(id: int):
    query = 'DELETE FROM "sql" WHERE id = %s RETURNING id;'
    return await execute_update(query, (id,))
