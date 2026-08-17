from repository.utils import fetch_many, fetch_one, execute_update
from schemas.app_metadata import AppMetadataRequest
from psycopg.types.json import Jsonb
import logging

log = logging.getLogger(__name__)


async def find_all():
    log.info("Fetching all app settings")
    query = "SELECT * FROM app_metadata;"
    return await fetch_many(query)


async def find_by_key(key: str):
    query = "SELECT * FROM app_metadata WHERE key = %s;"
    return await fetch_one(query, (key,))


async def create(key: str, setting: AppMetadataRequest):
    query = """
        INSERT INTO app_metadata (key, value, description)
        VALUES (%s, %s, %s)
        RETURNING key, value, description;
    """
    return await execute_update(
        query, (key, Jsonb(setting.value), setting.description)
    )


async def update(key: str, setting: AppMetadataRequest):
    query = """
        UPDATE app_metadata
        SET value = %s, description = %s
        WHERE key = %s
        RETURNING key, value, description;
    """
    return await execute_update(
        query, (Jsonb(setting.value), setting.description, key)
    )


async def delete(key: str):
    query = """
        DELETE FROM app_metadata
        WHERE key = %s
        RETURNING key;
    """
    return await execute_update(query, (key,))
