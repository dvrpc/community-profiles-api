from fastapi_cache.decorator import cache
import logging
import json
from datetime import datetime
from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)


async def find_by_filters(geo_level, category, subcategory, topic, all_info=False):
    log.info(
        f"Fetching {geo_level}/{category}/{subcategory}/{topic} viz...")
    query = """
        SELECT *
        FROM viz
        WHERE geo_level = %s
          AND category = %s
          AND subcategory = %s
          AND name = %s
    """
    result = fetch_one(query, (geo_level, category, subcategory, topic))
    file = json.loads(result["file"]) if result else None

    if (all_info):
        result['file'] = file
        return result

    return file


async def find_template(geo_level, category, subcategory, topic):
    log.info(
        f"Fetching {geo_level}/{category}/{subcategory}/{topic} viz template...")
    query = """
        SELECT file
        FROM viz
        WHERE geo_level = %s
          AND category = %s
          AND subcategory = %s
          AND name = %s
    """
    result = fetch_one(query, (geo_level, category, subcategory, topic))
    return json.loads(result["file"]) if result else None


async def update(category, subcategory, topic, geo_level, body):
    now = datetime.now()
    log.info(
        f"Updating viz for {category}/{subcategory}/{topic}/{geo_level}")
    query = """
        UPDATE viz
        SET file = %s, create_date = %s
        WHERE category = %s AND subcategory = %s AND name = %s AND geo_level = %s
    """
    return execute_update(query, (body, now, category, subcategory, topic, geo_level))
