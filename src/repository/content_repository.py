import logging

from repository.utils import execute_update, fetch_many, fetch_one

log = logging.getLogger(__name__)


async def find_by_geo(geo_level):
    """Return topic content for a geography level using content.topic_id."""
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
        JOIN content c ON c.topic_id = t.id
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
        JOIN content c ON c.category_id = cat.id
        ORDER BY cat.sort_weight DESC;
    """
    return await fetch_many(query)


async def find_one(id: int):
    return await fetch_one("SELECT * FROM content WHERE id = %s;", (id,))


async def find_topic_id(id: int):
    row = await fetch_one("SELECT topic_id FROM content WHERE id = %s;", (id,))
    return row["topic_id"] if row else None


async def find_by_category_id(category_id: int):
    query = """
        SELECT c.id, c.file
        FROM content c
        WHERE c.category_id = %s;
    """
    return await fetch_one(query, (category_id,))


async def find_by_topic_id(topic_id: int):
    query = """
        SELECT c.id, c.file
        FROM content c
        WHERE c.topic_id = %s;
    """
    return await fetch_one(query, (topic_id,))


async def update(id: int, text: str, last_edited_by: str = None):
    query = "UPDATE content SET file = %s, updated_at = now(), last_edited_by = %s WHERE id = %s RETURNING id;"
    return await execute_update(query, (text, last_edited_by, id))


async def create(file: str, topic_id: int | None = None, category_id: int | None = None):
    query = """
        INSERT INTO content (file, topic_id, category_id)
        VALUES (%s, %s, %s)
        RETURNING id;
    """
    return await execute_update(query, (file, topic_id, category_id))
