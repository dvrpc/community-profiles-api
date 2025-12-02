from repository.utils import fetch_many, execute_update
import logging

log = logging.getLogger(__name__)


async def create(content_id, source_id):
    query = """
        INSERT INTO content_source (content_id, source_id)
        VALUES (%s, %s)
        RETURNING content_id, source_id;
    """
    return execute_update(query, (content_id, source_id))


async def delete(content_id, source_ids):
    query = """
        DELETE FROM content_source
        WHERE content_id = %s AND source_id = ANY(%s)
        RETURNING content_id, source_id;
    """
    return execute_update(query, (content_id, source_ids))

async def find(content_id):
    query = """
        SELECT source_id FROM content_source WHERE content_id = %s
    """
    return fetch_many(query, (content_id,))
