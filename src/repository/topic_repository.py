from repository.utils import execute_update


async def create(subcategory_id, name, label):
    query = """
        INSERT INTO topic (name, subcategory_id, label) VALUES (%s, %s, %s)
        RETURNING (id)
    """
    return execute_update(query, (name, subcategory_id, label))

async def update(id, values):
    query = f"""
        UPDATE topic
        SET {values}
        WHERE id = {id}
        RETURNING (id)
    """
    return execute_update(query)




async def delete(id):
    query = "DELETE FROM topic WHERE id = %s RETURNING id;"
    return execute_update(query, (id,))