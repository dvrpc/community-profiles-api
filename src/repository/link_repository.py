from schemas.link import LinkCreate, LinkUpdate
from repository.utils import execute_update, fetch_many


async def find_all():
    query = """
        SELECT id, link, type
        FROM link
        ORDER BY id;
    """
    return await fetch_many(query)


async def create(link: LinkCreate):
    query = """
        INSERT INTO link (link, type)
        VALUES (%s, %s)
        RETURNING id, link, type;
    """
    return await execute_update(
        query, (link.link, link.type.value))


async def update(id: int, link: LinkUpdate):
    values = link.model_dump(exclude_unset=True)
    if "type" in values:
        values["type"] = values["type"].value

    assignments = ", ".join(f"{field} = %s" for field in values)
    params = tuple(values.values()) + (id,)
    query = f"""
        UPDATE link
        SET {assignments}
        WHERE id = %s
        RETURNING id, link, type;
    """
    return await execute_update(query, params) if assignments else await find_by_id(id)


async def find_by_id(id: int):
    rows = await fetch_many(
        "SELECT id, link, type FROM link WHERE id = %s;", (id,))
    return rows[0] if rows else None


async def delete(id: int):
    return await execute_update(
        "DELETE FROM link WHERE id = %s RETURNING id;", (id,))