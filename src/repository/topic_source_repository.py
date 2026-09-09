from repository.utils import fetch_many, execute_update
import logging

log = logging.getLogger(__name__)


async def create(topic_id, source_id):
    query = """
        INSERT INTO topic_source (topic_id, source_id)
        VALUES (%s, %s)
        RETURNING topic_id, source_id;
    """
    return await execute_update(query, (topic_id, source_id))


async def delete(topic_id, source_ids):
    query = """
        DELETE FROM topic_source
        WHERE topic_id = %s AND source_id = ANY(%s)
        RETURNING topic_id, source_id;
    """
    return await execute_update(query, (topic_id, source_ids))

async def find(topic_id):
    query = """
        SELECT source_id FROM topic_source WHERE topic_id = %s
    """
    return await fetch_many(query, (topic_id,))
