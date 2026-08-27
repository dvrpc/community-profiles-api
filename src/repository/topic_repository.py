from repository.utils import execute_update, fetch_many, fetch_one


async def find_tree(geo_level):
    query = """
        SELECT
            t.id AS topic_id, t.url_id AS topic, t.url_id AS topic_url_id, t.label AS topic_label,
            t.sort_weight, tc.content_id,
            s.id AS subcategory_id, s.url_id AS subcategory, s.url_id AS subcategory_url_id,
            s.label AS subcategory_label, s.sort_weight AS subcategory_sort_weight,
            cat.url_id AS category, cat.url_id AS category_url_id, cat.label AS category_label, cat.id AS category_id
        FROM topic t
        JOIN subcategory s ON s.id = t.subcategory_id
        JOIN category cat ON cat.id = s.category_id
        LEFT JOIN topic_content tc ON tc.topic_id = t.id
        WHERE s.geo_level = %s
        ORDER BY cat.sort_weight DESC, s.sort_weight DESC, t.sort_weight DESC;
    """
    return await fetch_many(query, (geo_level,))


async def find_by_geo(geo_level):
    """Return topic content for a geography level through the new join tables."""
    query = """
        SELECT
            c.id, c.file,
            cat.id AS category_id, cat.url_id AS category, cat.label AS category_label,
            s.id AS subcategory_id, s.url_id AS subcategory, s.label AS subcategory_label,
            t.id AS topic_id, t.url_id AS topic, t.label AS topic_label,
            COALESCE(array_agg(DISTINCT src.citation) FILTER (WHERE src.citation IS NOT NULL), '{}') AS citations,
            COALESCE(array_agg(DISTINCT tp.product_id) FILTER (WHERE tp.product_id IS NOT NULL), '{}') AS products,
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

async def find_topic_properties(topic_id):
    query = """
select t.id, t.label, t.url_id, t.sort_weight, t.is_visible,
        COALESCE(array_agg(DISTINCT tp.product_id) FILTER (WHERE tp.product_id IS NOT NULL), '{}') AS product_ids,
        COALESCE(array_agg(DISTINCT ts.source_id) FILTER (WHERE ts.source_id IS NOT NULL), '{}') AS source_ids,
        COALESCE(jsonb_agg(DISTINCT to_jsonb(l.*)) FILTER (WHERE l.id IS NOT NULL), '[]') AS links
        from topic t
        LEFT JOIN topic_source ts ON ts.topic_id = t.id
        left join topic_product tp ON tp.topic_id = t.id
        left join link l on l.topic_id = t.id
        where t.id = %s
        group by t.id;
    """
    return await fetch_one(query, (topic_id,))
    

async def create(subcategory_id: int, url_id: str, label: str):
    query = """
        INSERT INTO topic (url_id, subcategory_id, label) VALUES (%s, %s, %s)
        RETURNING id;
    """
    return await execute_update(query, (url_id, subcategory_id, label))


async def update(id: int, values: dict):
    allowed_fields = {"url_id", "label", "sort_weight", "is_visible"}
    update_values = {
        field: value for field, value in values.items()
        if field in allowed_fields
    }
    if not update_values:
        return await find_one(id)

    assignments = ", ".join(f"{field} = %s" for field in update_values)
    query = f"""
        UPDATE topic
        SET {assignments}
        WHERE id = %s
        RETURNING id;
    """
    return await execute_update(query, tuple(update_values.values()) + (id,))


async def find_one(id: int):
    return await fetch_one("SELECT * FROM topic WHERE id = %s;", (id,))


async def delete(id: int):
    return await execute_update("DELETE FROM topic WHERE id = %s RETURNING id;", (id,))
