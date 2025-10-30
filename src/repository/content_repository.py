from datetime import datetime
from fastapi_cache.decorator import cache
import logging

from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)


@cache(expire=60)
async def fetch_content(geo_level):
    log.info(f"Fetching {geo_level} content...")
    query = """
        SELECT category, subcategory, name, file
        FROM content
        WHERE geo_level = %s
    """
    return fetch_many(query, (geo_level,))


async def fetch_content_template(geo_level, category, subcategory, topic):
    log.info(
        f"Fetching {geo_level}/{category}/{subcategory}/{topic} content template...")
    query = """
        SELECT file
        FROM content
        WHERE geo_level = %s
          AND category = %s
          AND subcategory = %s
          AND name = %s
    """
    result = fetch_one(query, (geo_level, category, subcategory, topic))
    return result["file"] if result else None


async def fetch_single_content(category, subcategory, topic, geo_level):
    log.info(f"Fetching {category}/{subcategory}/{topic} content...")
    query = """
        SELECT *
        FROM content
        WHERE category = %s
          AND subcategory = %s
          AND name = %s
          AND geo_level = %s
    """
    return fetch_one(query, (category, subcategory, topic, geo_level))


async def update_single_content(category, subcategory, topic, geo_level, body):
    now = datetime.now()
    log.info(
        f"Updating content for {category}/{subcategory}/{topic}/{geo_level}")
    query = """
        UPDATE content
        SET file = %s, create_date = %s
        WHERE category = %s AND subcategory = %s AND name = %s AND geo_level = %s
    """
    return execute_update(query, (body, now, category, subcategory, topic, geo_level))


async def create_content_history(dict):
    columns = ', '.join(dict.keys())
    placeholders = ', '.join(['%s'] * len(dict))
    values = tuple(dict.values())

    query = f"INSERT INTO content_history ({columns}) VALUES ({placeholders})"

    log.info(f"Inserting row into content_history...")
    return execute_update(query, values)


async def fetch_content_history(category, subcategory, topic, geo_level):
    log.info(
        f"Fetching {category}/{subcategory}/{topic}/{geo_level} content history...")
    query = """
        SELECT *
        FROM content_history
        WHERE category = %s
          AND subcategory = %s
          AND name = %s
          AND geo_level = %s
        ORDER BY create_date DESC
    """
    return fetch_many(query, (category, subcategory, topic, geo_level))


async def fetch_template_tree(geo_level):
    query = "SELECT category, subcategory, name FROM content WHERE geo_level = %s"
    return fetch_many(query, (geo_level,))
