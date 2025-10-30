from fastapi_cache.decorator import cache
import logging
import json
from datetime import datetime
from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)


@cache(expire=60)
async def fetch_visualizations(geo_level, category, subcategory, topic, all_info=False):
    log.info(
        f"Fetching {geo_level}/{category}/{subcategory}/{topic} visualizations...")
    query = """
        SELECT *
        FROM visualizations
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


async def fetch_viz_template(geo_level, category, subcategory, topic):
    log.info(
        f"Fetching {geo_level}/{category}/{subcategory}/{topic} viz template...")
    query = """
        SELECT file
        FROM visualizations
        WHERE geo_level = %s
          AND category = %s
          AND subcategory = %s
          AND name = %s
    """
    result = fetch_one(query, (geo_level, category, subcategory, topic))
    print("--------------")
    print(json.loads(result['file']['type']))
    return json.loads(result["file"]) if result else None


async def update_single_visualization(category, subcategory, topic, geo_level, body):
    now = datetime.now()
    log.info(
        f"Updating viz for {category}/{subcategory}/{topic}/{geo_level}")
    query = """
        UPDATE visualizations
        SET file = %s, create_date = %s
        WHERE category = %s AND subcategory = %s AND name = %s AND geo_level = %s
    """
    print(query)
    return execute_update(query, (json.dumps(body), now, category, subcategory, topic, geo_level))


async def create_visualization_history(dict):
    columns = ', '.join(dict.keys())
    placeholders = ', '.join(['%s'] * len(dict))
    dict['file'] = json.dumps(dict['file'])
    values = tuple(dict.values())

    query = f"INSERT INTO visualizations_history ({columns}) VALUES ({placeholders})"
    log.info(f"Inserting row into visualization_history...")
    return execute_update(query, values)


async def fetch_visualization_history(category, subcategory, topic, geo_level):
    log.info(
        f"Fetching {category}/{subcategory}/{topic}/{geo_level} viz history...")
    query = """
        SELECT *
        FROM visualizations_history
        WHERE category = %s
          AND subcategory = %s
          AND name = %s
          AND geo_level = %s
        ORDER BY create_date DESC
    """
    result = fetch_many(query, (category, subcategory, topic, geo_level))
    for viz in result:
        viz['file'] = json.loads(viz["file"]) if viz else None
    return result


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
