from repository.utils import fetch_many, execute_update




async def update(id, name, label):
    query = """
        UPDATE subcategory
        SET name = %s, label = %s
        WHERE id = %s;
        RETURNING (id)
    """
    
    return execute_update(query, (name, label, id))



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