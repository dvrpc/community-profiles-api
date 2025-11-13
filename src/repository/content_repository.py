from datetime import datetime
from fastapi_cache.decorator import cache
import logging

from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)


async def find_by_geo(geo_level):
    log.info(f"Fetching {geo_level} content...")
    query = """
        SELECT category, subcategory, name, file
        FROM content
        WHERE geo_level = %s
    """
    return fetch_many(query, (geo_level,))


async def find_one(id: int):
    log.info(f"Fetching content {id}...")
    query = """
        SELECT *
        FROM content
        WHERE id = %s
    """
    return fetch_one(query, (id,))


async def update(id, body):
    now = datetime.now()
    log.info(
        f"Updating content: {id}")
    query = """
        UPDATE content
        SET file = %s, create_date = %s
        WHERE id = %s
    """
    return execute_update(query, (body, now, id))


async def find_tree(geo_level):
    query = "SELECT category, subcategory, name, id FROM content WHERE geo_level = %s"
    return fetch_many(query, (geo_level,))
