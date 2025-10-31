from fastapi_cache.decorator import cache
import logging
import json
from datetime import datetime
from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)

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

async def delete_viz_history(id):
    log.info(f"Deleting visualizations_history id {id}")
    query = "DELETE FROM visualizations_history WHERE id = %s"
    return execute_update(query, (id,))
    