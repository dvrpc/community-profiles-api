from repository.utils import fetch_one, fetch_many, execute_update
import logging

log = logging.getLogger(__name__)


async def find_by_id(id: int):
    query = "SELECT * FROM data WHERE id = %s;"
    return await fetch_one(query, (id,))


async def find_by_variable_id(variable_id: int):
    query = "SELECT * FROM data WHERE variable_id = %s;"
    return await fetch_many(query, (variable_id,))


async def find_by_geoid(geoid: str):
    query = "SELECT * FROM data WHERE geoid = %s;"
    return await fetch_many(query, (geoid,))

async def find_region():
    query = "SELECT * FROM data WHERE geoid IS NULL;"


async def find_all():
    query = "SELECT * FROM data;"
    return await fetch_many(query)


async def create(variable_id: int, value: float, geoid: str | None = None, margin_of_error: float | None = None):
    query = """
        INSERT INTO data (variable_id, geoid, value, margin_of_error)
        VALUES (%s, %s, %s, %s)
        RETURNING id, variable_id, geoid, value, margin_of_error;
    """
    return await execute_update(query, (variable_id, geoid, value, margin_of_error))


async def update(id: int, variable_id: int, value: float,  geoid: str | None = None, margin_of_error: float | None = None):
    query = """
        UPDATE data
        SET variable_id = %s, geoid = %s, value = %s, margin_of_error = %s
        WHERE id = %s
        RETURNING id, variable_id, geoid, value, margin_of_error;
    """
    return await execute_update(query, (variable_id, geoid, value, margin_of_error, id))


async def delete(id: int):
    query = """
        DELETE FROM data
        WHERE id = %s
        RETURNING id;
    """
    return await execute_update(query, (id,))
