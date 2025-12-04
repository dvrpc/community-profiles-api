from datetime import datetime
import logging

from repository.utils import fetch_one, fetch_many, execute_update

log = logging.getLogger(__name__)


async def find_by_geo(geo_level):
    log.info(f"Fetching {geo_level} content...")
    query = """
    SELECT 
        c.id,
        c.file,
        cat.name AS category, 
        s.name AS subcategory, 
        t.name AS topic, 
        ARRAY_AGG(DISTINCT sc.citation) AS citations,
        ARRAY_AGG(DISTINCT cp.product_id) AS products
    FROM content c
    JOIN topic t ON t.id = c.topic_id
    JOIN subcategory s ON s.id = t.subcategory_id 
    JOIN category cat ON cat.id = s.category_id
    LEFT JOIN content_source cs ON cs.content_id = c.id
    LEFT JOIN source sc ON sc.id = cs.source_id
    LEFT JOIN content_product cp ON cp.content_id = c.id
    WHERE c.geo_level = %s
    GROUP BY 
        c.id, 
        cat.name, 
        s.name, 
        t.name,
        t.sort_weight
    ORDER BY 
        t.sort_weight DESC;
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
            t.label,
            t.sort_weight,
            COALESCE(cs.source_ids, '{}') AS source_ids,
            COALESCE(cp.product_ids, '{}') AS product_ids
        FROM content c
        LEFT JOIN topic t ON t.id = c.topic_id
        LEFT JOIN (
            SELECT content_id, array_agg(source_id ORDER BY source_id) AS source_ids
            FROM content_source
            GROUP BY content_id
        ) cs ON cs.content_id = c.id
        LEFT JOIN (
            SELECT content_id, array_agg(product_id ORDER BY product_id) AS product_ids
            FROM content_product
            GROUP BY content_id
        ) cp ON cp.content_id = c.id
        WHERE c.id = %s;
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
        WHERE id = {id}
        RETURNING id, geo_level
    """
    return execute_update(query)


async def find_tree(geo_level):
    query = """
        SELECT 
            c.id AS id,
            t.id AS topic_id,
            t.name AS topic,
            t.label AS topic_label,
            t.sort_weight as sort_weight,
            s.id AS subcategory_id,
            s.name AS subcategory,
            s.label AS subcategory_label,
            cat.name as category,
            cat.label as category_label,
            cat.id as category_id
        FROM content c
        JOIN topic AS t ON t.id = c.topic_id
        join subcategory AS s on s.id = t.subcategory_id 
        join category AS cat on cat.id = s.category_id 
        where c.geo_level = %s
        ORDER by t.sort_weight DESC;
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
