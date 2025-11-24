from repository.utils import execute_update


async def create(subcategory_id, name, label):
    query = """
        INSERT INTO topic (name, subcategory_id, label) VALUES (%s, %s, %s)
        RETURNING (id)
    """
    return execute_update(query, (name, subcategory_id, ))

async def update(id, name, label):
    query = """
        UPDATE topic
        SET name = %s, label = %s
        WHERE id = %s;
        RETURNING (id)
    """
    
    return execute_update(query, (name, label, id))


async def delete(id):
    query = "DELETE FROM topic WHERE id = %s"
    return execute_update(query, (id,))