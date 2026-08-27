from schemas.link import LinkCreate, LinkUpdate
from repository.utils import execute_update, fetch_many


async def find_all(topic_id: int | None = None):
    params = () if topic_id is None else (topic_id,)
    where = "" if topic_id is None else "WHERE topic_id = %s"
    query = """
        SELECT id, topic_id, link, type
        FROM link
        {where}
        ORDER BY id;
    """.format(where=where)
    return await fetch_many(query, params)


async def create(link: LinkCreate):
    query = """
        INSERT INTO link (topic_id, link, type)
        VALUES (%s, %s, %s)
        RETURNING id, topic_id, link, type;
    """
    return await execute_update(
        query, (link.topic_id, link.link, link.type.value))


async def update(id: int, link: LinkUpdate, topic_id: int | None = None):
    values = link.model_dump(exclude_unset=True)
    if "type" in values:
        values["type"] = values["type"].value

    assignments = ", ".join(f"{field} = %s" for field in values)
    params = tuple(values.values()) + (id,)
    topic_filter = "" if topic_id is None else " AND topic_id = %s"
    query = f"""
        UPDATE link
        SET {assignments}
        WHERE id = %s{topic_filter}
        RETURNING id, topic_id, link, type;
    """.format(topic_filter=topic_filter)
    return (await execute_update(query, params if topic_id is None
                                 else params + (topic_id,))
            if assignments else await find_by_id(id, topic_id))


async def find_by_id(id: int, topic_id: int | None = None):
    params = (id,) if topic_id is None else (id, topic_id)
    topic_filter = "" if topic_id is None else " AND topic_id = %s"
    rows = await fetch_many(
        f"SELECT id, topic_id, link, type FROM link WHERE id = %s{topic_filter};",
        params)
    return rows[0] if rows else None


async def delete(id: int, topic_id: int | None = None):
    params = (id,) if topic_id is None else (id, topic_id)
    topic_filter = "" if topic_id is None else " AND topic_id = %s"
    return await execute_update(
        f"DELETE FROM link WHERE id = %s{topic_filter} RETURNING id;", params)