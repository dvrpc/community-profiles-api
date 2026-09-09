from repository.utils import fetch_many, execute_update
import logging

log = logging.getLogger(__name__)


async def create(topic_id, product_id):
    query = """
        INSERT INTO topic_product (topic_id, product_id)
        VALUES (%s, %s)
        RETURNING topic_id, product_id;
    """
    return await execute_update(query, (topic_id, product_id))


async def delete(topic_id, product_ids):
    query = """
        DELETE FROM topic_product
        WHERE topic_id = %s AND product_id = ANY(%s)
        RETURNING topic_id, product_id;
    """
    return await execute_update(query, (topic_id, product_ids))

async def find(topic_id):
    query = """
        SELECT product_id FROM topic_product WHERE topic_id = %s
    """
    return await fetch_many(query, (topic_id,))
