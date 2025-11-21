from repository.utils import fetch_many, execute_update
from schemas.source import SourceRequest
import logging

log = logging.getLogger(__name__)


async def create(viz_id, source_id):
    query = """
        INSERT INTO viz_source (viz_id, source_id)
        VALUES (%s, %s)
        RETURNING viz_id, source_id;
    """
    return execute_update(query, (viz_id, source_id))


async def delete(viz_id, source_id):
    query = """
        DELETE FROM viz_source
        WHERE viz_id = %s AND source_id = %s;
    """
    return execute_update(query, (viz_id, source_id))
