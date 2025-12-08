from repository.utils import fetch_many, execute_update, fetch_one


async def get(id):
    query = """
        SELECT * 
        FROM subcategory
        WHERE id = %s;
    """
    return fetch_one(query, (id,))

async def update(id, values):
    query = f"""
        UPDATE subcategory
        SET {values}
        WHERE id = {id}
        RETURNING (id)
    """
    return execute_update(query)




async def create(category_id, name, label):
    query = """
        INSERT INTO subcategory (name, category_id, label) VALUES (%s, %s, %s)
        RETURNING (id)
    """
    
    return execute_update(query, (name, category_id, label))
    # query = f"INSERT INTO content_history ({columns}) VALUES ({placeholders})"

async def delete(id):
    query = "DELETE FROM subcategory WHERE id = %s RETURNING id;"
    return execute_update(query, (id,))