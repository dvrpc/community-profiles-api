from repository.utils import fetch_many, execute_update
from schemas.source import SourceRequest
import logging

log = logging.getLogger(__name__)


async def create(content_id, source_id):
    query = """
        INSERT INTO content_source (content_id, source_id)
        VALUES (%s, %s)
        RETURNING content_id, source_id;
    """
    return execute_update(query, (content_id, source_id))


async def delete(content_id, source_id):
    query = """
        DELETE FROM content_source
        WHERE content_id = %s AND source_id = %s;
    """
    return execute_update(query, (content_id, source_id))
