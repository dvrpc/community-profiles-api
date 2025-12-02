from repository.utils import fetch_many, execute_update
import logging

log = logging.getLogger(__name__)


async def create(viz_id, source_id):
    query = """
        INSERT INTO viz_source (viz_id, source_id)
        VALUES (%s, %s)
        RETURNING viz_id, source_id;
    """
    return execute_update(query, (viz_id, source_id))


async def delete(viz_id, source_ids):
    query = """
        DELETE FROM viz_source
        WHERE viz_id = %s AND source_id = ANY(%s)
        RETURNING viz_id, source_id;
    """
    return execute_update(query, (viz_id, source_ids))

async def find(viz_id):
    query = """
        SELECT source_id FROM viz_source WHERE viz_id = %s
    """
    return fetch_many(query, (viz_id,))
