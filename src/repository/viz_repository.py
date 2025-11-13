from fastapi_cache.decorator import cache
import logging
import json
from datetime import datetime
from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)


async def find_by_geo(geo_level):
    log.info(f"Fetching {geo_level} viz...")
    query = """
        SELECT category, subcategory, name, file
        FROM viz
        WHERE geo_level = %s
    """
    return fetch_many(query, (geo_level,))


async def find_one(id: int):
    log.info(f"Fetching viz {id}...")
    query = """
        SELECT *, 
        FROM viz
        WHERE id = %s
    """
    return fetch_one(query, (id,))


async def update(id, body):
    now = datetime.now()
    log.info(
        f"Updating viz: {id}")
    query = """
        UPDATE contvizent
        SET file = %s, create_date = %s
        WHERE id = %s
    """
    return execute_update(query, (body, now, id))
