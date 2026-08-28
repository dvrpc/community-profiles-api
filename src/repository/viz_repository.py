import logging

from repository.utils import execute_update, fetch_one

log = logging.getLogger(__name__)


async def find_one(id: int):
    query = """
        SELECT
            v.*, tv.topic_id, tv.sort_weight,
            COALESCE(array_agg(DISTINCT ts.source_id) FILTER (WHERE ts.source_id IS NOT NULL), '{}') AS source_ids,
            COALESCE(array_agg(DISTINCT src.citation) FILTER (WHERE src.citation IS NOT NULL), '{}') AS citations
        FROM viz v
        LEFT JOIN topic_viz tv ON tv.viz_id = v.id
        LEFT JOIN topic_source ts ON ts.topic_id = tv.topic_id
        LEFT JOIN source src ON src.id = ts.source_id
        WHERE v.id = %s
        GROUP BY v.id, tv.topic_id, tv.sort_weight;
    """
    return await fetch_one(query, (id,))


async def find_by_topic_id(topic_id: int):
    query = """
        select 
            v.*,
            COALESCE(array_agg(DISTINCT ts.source_id) FILTER (WHERE ts.source_id IS NOT NULL), '{}') AS source_ids
        from viz v
        left join topic_viz tv on tv.viz_id = v.id
        LEFT JOIN topic_source ts ON ts.topic_id = tv.topic_id
        LEFT JOIN source src ON src.id = ts.source_id
        where tv.topic_id = 1
        group by v.id
        order by tv.sort_weight

    """


async def find_one_basic(id: int):
    return await fetch_one("SELECT * FROM viz WHERE id = %s;", (id,))


async def update(id: int, file: str):
    return await execute_update(
        "UPDATE viz SET file = %s, updated_at = now() WHERE id = %s RETURNING id;",
        (file, id))


async def create(file: str):
    """Create a standalone visualization; its topic link is separate."""
    return await execute_update("INSERT INTO viz (file) VALUES (%s) RETURNING id;", (file,))
