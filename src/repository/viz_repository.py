from fastapi_cache.decorator import cache
import logging
import json
from datetime import datetime
from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)

async def find_one(id: int):
    log.info(f"Fetching viz {id}...")
    query = """
        SELECT 
            v.*,
            COALESCE(
                array_agg(vs.source_id ORDER BY vs.source_id) 
                FILTER (WHERE vs.source_id IS NOT NULL), 
                '{}'
            ) AS source_ids
        FROM viz v
        LEFT JOIN viz_source vs ON vs.viz_id = v.id
        WHERE v.id = %s
        GROUP BY v.id, v.geo_level, v.file, v.create_date , v.topic_id;
    """
    return fetch_one(query, (id,))


async def update(id, body):
    now = datetime.now()
    log.info(
        f"Updating viz: {id}")
    query = """
        UPDATE viz
        SET file = %s, create_date = %s
        WHERE id = %s
    """
    return execute_update(query, (body, now, id))

async def create(topic_id, geo_level, file, content_id):
    now = datetime.now()
    log.info(
        f"Creating viz for topic_id: {topic_id}")
    query = """
        INSERT into viz (geo_level, create_date, topic_id, file, id)
        VALUES (%s, %s, %s, %s, %s)
        RETURNING id
    """
    return execute_update(query, (geo_level, now, topic_id, file, content_id))
