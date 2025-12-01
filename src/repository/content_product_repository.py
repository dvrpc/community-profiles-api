from repository.utils import fetch_many, execute_update
import logging

log = logging.getLogger(__name__)


async def create(content_id, product_id):
    query = """
        INSERT INTO content_product (content_id, product_id)
        VALUES (%s, %s)
        RETURNING content_id, product_id;
    """
    return execute_update(query, (content_id, product_id))


async def delete(content_id, product_ids):
    query = """
        DELETE FROM content_product
        WHERE content_id = %s AND product_id = ANY(%s);
    """
    return execute_update(query, (content_id, product_ids))

async def find(content_id):
    query = """
        SELECT product_id FROM content_product WHERE content_id = %s
    """
    return fetch_many(query, (content_id,))
