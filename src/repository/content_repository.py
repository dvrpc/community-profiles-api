import logging

from repository.utils import execute_update, fetch_many, fetch_one

log = logging.getLogger(__name__)


async def find_by_geo(geo_level):
    """Return topic content for a geography level through the new join tables."""
    query = """
        SELECT
            c.id, c.file,
            cat.id AS category_id, cat.url_id AS category, cat.label AS category_label,
            s.id AS subcategory_id, s.url_id AS subcategory, s.label AS subcategory_label,
            t.id AS topic_id, t.url_id AS topic, t.label AS topic_label,
            COALESCE(array_agg(DISTINCT src.citation) FILTER (WHERE src.citation IS NOT NULL), '{}') AS citations,
            COALESCE(array_agg(DISTINCT tp.product_id) FILTER (WHERE tp.product_id IS NOT NULL), '{}') AS products
        FROM topic t
        JOIN subcategory s ON s.id = t.subcategory_id
        JOIN category cat ON cat.id = s.category_id
        JOIN topic_content tc ON tc.topic_id = t.id
        JOIN content c ON c.id = tc.content_id
        LEFT JOIN topic_source ts ON ts.topic_id = t.id
        LEFT JOIN source src ON src.id = ts.source_id
        LEFT JOIN topic_product tp ON tp.topic_id = t.id
        WHERE s.geo_level = %s
        GROUP BY c.id, cat.id, s.id, t.id
        ORDER BY cat.sort_weight DESC, s.sort_weight DESC, t.sort_weight DESC;
    """
    return await fetch_many(query, (geo_level,))


async def find_category_content():
    query = """
        SELECT c.id, cat.url_id AS category, cat.id AS category_id, c.file, cat.sort_weight
        FROM category cat
        JOIN category_content cc ON cc.category_id = cat.id
        JOIN content c ON c.id = cc.content_id
        ORDER BY cat.sort_weight DESC;
    """
    return await fetch_many(query)


async def find_one(id: int):
    query = """
        SELECT
            c.*, tc.topic_id, t.label AS topic_label, t.url_id AS topic_url_id, t.sort_weight,
            COALESCE(array_agg(DISTINCT ts.source_id) FILTER (WHERE ts.source_id IS NOT NULL), '{}') AS source_ids,
            COALESCE(array_agg(DISTINCT tp.product_id) FILTER (WHERE tp.product_id IS NOT NULL), '{}') AS product_ids
        FROM content c
        LEFT JOIN topic_content tc ON tc.content_id = c.id
        LEFT JOIN topic t ON t.id = tc.topic_id
        LEFT JOIN topic_source ts ON ts.topic_id = t.id
        LEFT JOIN topic_product tp ON tp.topic_id = t.id
        WHERE c.id = %s
        GROUP BY c.id, tc.topic_id, t.id;
    """
    return await fetch_one(query, (id,))


async def find_one_basic(id: int):
    return await fetch_one("SELECT * FROM content WHERE id = %s;", (id,))


async def find_topic_id(id: int):
    row = await fetch_one("SELECT topic_id FROM topic_content WHERE content_id = %s;", (id,))
    return row["topic_id"] if row else None

async def find_by_category_id(category_id: int):
    query = """
        SELECT c.id, c.file
        FROM category_content cc
        JOIN content c ON c.id = cc.content_id
        WHERE cc.category_id = %s;
    """
    return await fetch_one(query, (category_id,))

async def find_by_topic_id(topic_id: int):
    query = """
        SELECT c.id, c.file
        FROM topic_content tc
        JOIN content c ON c.id = tc.content_id
        WHERE tc.topic_id = %s;
    """
    return await fetch_one(query, (topic_id,))

async def update(id: int, text: str, last_edited_by: str = None):
    query = "UPDATE content SET file = %s, updated_at = now(), last_edited_by = %s WHERE id = %s RETURNING id;"
    return await execute_update(query, (text, last_edited_by, id))


async def create(file: str):
    return await execute_update("INSERT INTO content (file) VALUES (%s) RETURNING id;", (file,))
