import logging

from repository.utils import execute_update, fetch_many, fetch_one

log = logging.getLogger(__name__)


async def find_by_geo(geo_level):
    """Return topic content for a geography level using content.topic_id."""
    query = """
        SELECT
            c.id,
            c.label,
            c.url_id,
            ct.file as content,
            c.sort_weight,
            COALESCE(
                json_agg(
                    json_build_object(
                        'id', s.id,
                        'category_id', s.category_id,
                        'label', s.label,
                        'url_id', s.url_id,
                        'sort_weight', s.sort_weight,
                        'topics', s.topics
                    )
                    ORDER BY s.sort_weight DESC
                ) FILTER (WHERE s.id IS NOT NULL),
                '[]'
            ) AS subcategories
        FROM category c
        LEFT JOIN content ct ON ct.category_id = c.id
        LEFT JOIN LATERAL (
            SELECT
                sub.id,
                sub.category_id,
                sub.label,
                sub.url_id,
                sub.sort_weight,
                COALESCE(
                    (
                        SELECT json_agg(
                            json_build_object(
                                'id', t.id,
                                'label', t.label,
                                'url_id', t.url_id,
                                'content', c2.file,
                                'citations', src_agg.citations,
                                'products', tp_agg.products,
                                'links', l_agg.links,
                                'sort_weight', t.sort_weight,
                                'is_visible', t.is_visible
                            )
                            ORDER BY t.sort_weight DESC
                        )
                        FROM topic t
                        LEFT JOIN content c2 ON c2.topic_id = t.id
                        LEFT JOIN LATERAL (
                            SELECT COALESCE(array_agg(DISTINCT src.citation) FILTER (WHERE src.citation IS NOT NULL), '{}') AS citations
                            FROM topic_source ts
                            JOIN source src ON src.id = ts.source_id
                            WHERE ts.topic_id = t.id
                        ) src_agg ON true
                        LEFT JOIN LATERAL (
                            SELECT COALESCE(array_agg(DISTINCT tp.product_id) FILTER (WHERE tp.product_id IS NOT NULL), '{}') AS products
                            FROM topic_product tp
                            WHERE tp.topic_id = t.id
                        ) tp_agg ON true
                        LEFT JOIN LATERAL (
                            SELECT COALESCE(jsonb_agg(DISTINCT to_jsonb(l.*)) FILTER (WHERE l.id IS NOT NULL), '[]') AS links
                            FROM link l
                            WHERE l.topic_id = t.id
                        ) l_agg ON true
                        WHERE t.subcategory_id = sub.id
                    ),
                    '[]'
                ) AS topics
            FROM subcategory sub
            WHERE sub.category_id = c.id
            AND sub.geo_level = %s
        ) s ON true
        GROUP BY c.id, c.label, c.url_id, c.sort_weight, ct.id
        ORDER BY c.sort_weight DESC;
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
