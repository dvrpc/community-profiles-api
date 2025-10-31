from datetime import datetime
from fastapi_cache.decorator import cache
import logging

from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)


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

async def fetch_template_tree(geo_level):
    query = "SELECT category, subcategory, name FROM content WHERE geo_level = %s"
    return fetch_many(query, (geo_level,))

