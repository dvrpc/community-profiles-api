from repository.utils import execute_update, fetch_many


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


async def create(subcategory_id: int, url_id: str, label: str):
    query = """
        INSERT INTO topic (url_id, subcategory_id, label) VALUES (%s, %s, %s)
        RETURNING id;
    """
    return await execute_update(query, (url_id, subcategory_id, label))


async def update(id: int, values: str):
    query = f"UPDATE topic SET {values} WHERE id = %s RETURNING id;"
    return await execute_update(query, (id,))


async def delete(id: int):
    return await execute_update("DELETE FROM topic WHERE id = %s RETURNING id;", (id,))
