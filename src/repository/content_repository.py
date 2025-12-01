from datetime import datetime
from fastapi_cache.decorator import cache
import logging

from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)


async def find_by_geo(geo_level):
    log.info(f"Fetching {geo_level} content...")
    query = """
        SELECT c.id, cat.name as category, s.name as subcategory, t.name as topic, c.file
        FROM content c
        JOIN topic t ON t.id = topic_id
        JOIN subcategory s on s.id = t.subcategory_id 
        JOIN category cat on cat.id = s.category_id 
        WHERE geo_level = %s
    """
    return fetch_many(query, (geo_level,))


async def find_category_content(geo_level):
    log.info(f"Fetching category content...")
    query = """
        SELECT c.id, cat.name as category, cat.id as category_id, c.file, cat.sort_weight as sort_weight
        FROM content c
        JOIN category cat on cat.id = c.category_id 
        WHERE geo_level = %s
        ORDER by sort_weight DESC
    """
    return fetch_many(query, (geo_level,))


async def find_one(id: int):
    log.info(f"Fetching content {id}...")
    query = """
        SELECT 
            c.*,
            COALESCE(
                array_agg(cs.source_id ORDER BY cs.source_id) 
                FILTER (WHERE cs.source_id IS NOT NULL), 
                '{}'
            ) AS source_ids,
                COALESCE(
                array_agg(cp.product_id ORDER BY cp.product_id) 
                FILTER (WHERE cp.product_id IS NOT NULL), 
                '{}'
            ) AS product_ids
        FROM content c
        LEFT JOIN content_source cs ON cs.content_id = c.id
        LEFT JOIN content_product cp ON cp.content_id = c.id
        WHERE c.id = %s
        GROUP BY c.id;
    """
    return fetch_one(query, (id,))


async def update(id, body):
    now = datetime.now()
    log.info(
        f"Updating content: {id}")
    query = """
        UPDATE content
        SET file = %s, create_date = %s
        WHERE id = %s
        RETURNING id
    """
    return execute_update(query, (body, now, id))

async def update_content_properties(id, values):
    log.info(
        f"Updating content: {id}")
    query = f"""
        UPDATE content
        SET {values}
        WHERE id = %s
        RETURNING id
    """
    return execute_update(query, (id,))

async def find_tree(geo_level):
    query = """
        SELECT 
            c.id AS id,
            t.name AS topic,
            t.label AS topic_label,
            t.id AS topic_id,
            s.id AS subcategory_id,
            s.name AS subcategory,
            s.label AS subcategory_label,
            cat.name as category,
            cat.label as category_label,
            cat.id as category_id
        FROM content c
        JOIN topic t ON t.id = c.topic_id
        join subcategory s on s.id = t.subcategory_id 
        join category cat on cat.id = s.category_id 
        where c.geo_level = %s
    """
    return fetch_many(query, (geo_level,))


async def find_category_tree(geo_level):
    query = """
        SELECT
            c.id as content_id,
            c.category_id as category_id,
            cat."name" as name,
            cat."label" as label,
            cat.sort_weight as sort_weight
        FROM content c
        join category cat on cat.id = c.category_id
        WHERE 
            c.category_id is not null AND c.geo_level = %s
        ORDER by sort_weight DESC
    """
    return fetch_many(query, (geo_level,))


async def create(topic_id, geo_level, file):
    now = datetime.now()
    log.info(
        f"Creating content for topic_id: {topic_id}")
    query = """
        INSERT into content (geo_level, create_date, topic_id, file)
        VALUES (%s, %s, %s, %s)
        RETURNING id
    """
    return execute_update(query, (geo_level, now, topic_id, file))
