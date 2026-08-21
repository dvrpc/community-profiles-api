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

    query = f"INSERT INTO content_history ({columns}) VALUES ({placeholders}) RETURNING id"

    log.info(f"Inserting row into content_history...")
    return await execute_update(query, values)


async def find_by_parent_id(content_id):
    log.info(
        f"Fetching content history for content_id {content_id}...")
    query = """
        SELECT id, content_id, file, last_edited_by, archived_at as updated_at
        FROM content_history
        WHERE content_id = %s
        ORDER BY archived_at DESC
    """
    return await fetch_many(query, (content_id,))


async def delete(id):
    log.info(f"Deleting content_history id {id}")
    query = "DELETE FROM content_history WHERE id = %s RETURNING id"
    return await execute_update(query, (id,))
