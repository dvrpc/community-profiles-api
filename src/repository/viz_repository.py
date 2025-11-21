from fastapi_cache.decorator import cache
import logging
import json
from datetime import datetime
from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)

async def find_one(id: int):
    log.info(f"Fetching viz {id}...")
    query = """
        SELECT *
        FROM viz
        WHERE id = %s
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

async def create(topic_id, geo_level, file):
    now = datetime.now()
    log.info(
        f"Creating viz for topic_id: {topic_id}")
    query = """
        INSERT into viz (geo_level, create_date, topic_id, file)
        VALUES (%s, %s, %s, %s)
        RETURNING id
    """
    return execute_update(query, (geo_level, now, topic_id, file))
