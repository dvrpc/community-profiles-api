from repository.utils import execute_update, fetch_many


async def create(topic_id: int, link_id: int):
    query = """
        INSERT INTO topic_link (topic_id, link_id)
        VALUES (%s, %s)
        RETURNING topic_id, link_id;
    """
    return await execute_update(query, (topic_id, link_id))


async def delete(topic_id: int, link_ids: list[int]):
    query = """
        DELETE FROM topic_link
        WHERE topic_id = %s AND link_id = ANY(%s)
        RETURNING topic_id, link_id;
    """
    return await execute_update(query, (topic_id, link_ids))


async def find(topic_id: int):
    query = """
        SELECT link_id FROM topic_link WHERE topic_id = %s
    """
    return await fetch_many(query, (topic_id,))