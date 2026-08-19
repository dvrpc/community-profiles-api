from fastapi_cache.decorator import cache
import logging
from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)


async def create(dict):
    columns = ', '.join(dict.keys())
    placeholders = ', '.join(['%s'] * len(dict))
    values = tuple(dict.values())

    query = f"INSERT INTO viz_history ({columns}) VALUES ({placeholders}) RETURNING id"

    log.info(f"Inserting row into viz_history...")
    return await execute_update(query, values)


async def find_by_parent_id(viz_id):
    log.info(
        f"Fetching viz history for viz_id {viz_id}...")
    query = """
        SELECT *
        FROM viz_history
        WHERE viz_id = %s
        ORDER BY archived_at DESC
    """
    return await fetch_many(query, (viz_id,))


async def delete(id):
    log.info(f"Deleting viz_history id {id}")
    query = "DELETE FROM viz_history WHERE id = %s RETURNING id;"
    return await execute_update(query, (id,))
