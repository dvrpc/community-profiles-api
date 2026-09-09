from repository.utils import execute_update, fetch_one


async def get(id: int):
    return await fetch_one("SELECT * FROM subcategory WHERE id = %s;", (id,))


async def find_one(subcategory_id: int):
    query = """
        SELECT * from subcategory
        WHERE id = %s
    """
    return await fetch_one(query, (subcategory_id,))


async def update(id: int, values: str):
    return await execute_update(f"UPDATE subcategory SET {values} WHERE id = %s RETURNING id;", (id,))


async def create(category_id: int, geo_level: str, url_id: str, label: str):
    query = """
        INSERT INTO subcategory (category_id, geo_level, url_id, label)
        VALUES (%s, %s, %s, %s) RETURNING id;
    """
    return await execute_update(query, (category_id, geo_level, url_id, label))


async def delete(id: int):
    return await execute_update("DELETE FROM subcategory WHERE id = %s RETURNING id;", (id,))
