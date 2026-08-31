import logging

from repository.utils import execute_update, fetch_many, fetch_one
from schemas.viz import VizCreate, VizUpdate

log = logging.getLogger(__name__)


async def find_one(id: int):
    query = """
        SELECT
            v.*,
            COALESCE(array_agg(DISTINCT ts.source_id) FILTER (WHERE ts.source_id IS NOT NULL), '{}') AS source_ids,
            COALESCE(array_agg(DISTINCT src.citation) FILTER (WHERE src.citation IS NOT NULL), '{}') AS citations
        FROM viz v
        LEFT JOIN topic_source ts ON ts.topic_id = v.topic_id
        LEFT JOIN source src ON src.id = ts.source_id
        WHERE v.id = %s
        GROUP BY v.id
    """
    return await fetch_one(query, (id,))


async def find_by_topic_id(topic_id: int):
    query = """
        SELECT
            v.*,
            COALESCE(array_agg(DISTINCT ts.source_id) FILTER (WHERE ts.source_id IS NOT NULL), '{}') AS source_ids
        FROM viz v
        LEFT JOIN topic_source ts ON ts.topic_id = v.topic_id
        LEFT JOIN source src ON src.id = ts.source_id
        WHERE v.topic_id = %s
        GROUP BY v.id
        ORDER BY v.sort_weight
    """
    return await fetch_many(query, (topic_id,))


async def find_one_basic(id: int):
    return await fetch_one("SELECT * FROM viz WHERE id = %s;", (id,))


async def update(id: int, viz: VizUpdate):
    allowed_fields = {"file", "sort_weight", "last_edited_by"}
    update_values = {field: getattr(
        viz, field) for field in allowed_fields if getattr(viz, field, None) is not None}

    if not update_values:
        return await find_one(id)

    assignments = ", ".join(f"{field} = %s" for field in update_values)
    query = f"""
        UPDATE viz
        SET {assignments}, updated_at = now()
        WHERE id = %s
        RETURNING id;
    """
    params = tuple(update_values.values()) + (id,)
    return await execute_update(query, params)


async def create(viz: VizCreate):
    query = """
        INSERT INTO viz (file, topic_id, sort_weight, last_edited_by)
        VALUES (%s, %s, %s, %s)
        RETURNING id;
    """
    return await execute_update(
        query,
        (viz.file, viz.topic_id, viz.sort_weight, viz.last_edited_by),
    )
