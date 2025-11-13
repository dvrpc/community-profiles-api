from fastapi_cache.decorator import cache
import logging
import json
from datetime import datetime
from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)


async def create(dict):
    columns = ', '.join(dict.keys())
    placeholders = ', '.join(['%s'] * len(dict))
    values = tuple(dict.values())

    query = f"INSERT INTO content_history ({columns}) VALUES ({placeholders})"

    log.info(f"Inserting row into content_history...")
    return execute_update(query, values)


async def find_by_parent_id(parent_id):
    log.info(
        f"Fetching content history for parent_id {parent_id}...")
    query = """
        SELECT *
        FROM content_history
        WHERE parent_id = %s
        ORDER BY create_date DESC
    """
    return fetch_many(query, (parent_id,))


async def delete(id):
    log.info(f"Deleting content_history id {id}")
    query = "DELETE FROM content_history WHERE id = %s"
    return execute_update(query, (id,))
