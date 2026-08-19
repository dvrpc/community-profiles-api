from repository.utils import execute_update


async def create(topic_id: int, content_id: int):
    query = """
        INSERT INTO topic_content (topic_id, content_id)
        VALUES (%s, %s)
        RETURNING topic_id, content_id;
    """
    return await execute_update(query, (topic_id, content_id))
