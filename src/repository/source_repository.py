from repository.utils import fetch_many, execute_update
from schemas.source import SourceRequest
import logging

log = logging.getLogger(__name__)


async def find_all_sources():
    log.info(f"Fetching all sources")
    query = "SELECT * FROM source;"
    return fetch_many(query)


async def create(source: SourceRequest):
    query = """
        INSERT INTO source (name, year_from, year_to, citation)
        VALUES (%s, %s, %s, %s)
        RETURNING id, name, year_from, year_to, citation;
    """
    return execute_update(query, (source.name, source.year_from, source.year_to, source.citation))


async def update(id, source: SourceRequest):
    query = """
        UPDATE source
        SET name = %s, year_from = %s, year_to = %s, citation = %s
        WHERE id = %s
        RETURNING id, name, year_from, year_to, citation;
    """
    return execute_update(query, (source.name, source.year_from, source.year_to, source.citation, id))


async def delete(id):
    query = """
        DELETE FROM source
        WHERE id = %s;
    """
    print(query)
    return execute_update(query, (id,))
