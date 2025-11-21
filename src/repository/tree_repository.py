from repository.utils import fetch_many, execute_update




async def update_subcategory(id, name):
    query = """
        UPDATE subcategory
        SET name = %s
        WHERE id = %s;
    """
    
    return execute_update(query, (name, id))

async def update_topic(id, name):
    query = """
        UPDATE topic
        SET name = %s
        WHERE id = %s;
    """
    
    return execute_update(query, (name, id))


async def create_subcategory(category_id, name, label):
    query = """
        INSERT INTO subcategory (name, category_id, label) VALUES (%s, %s, %s)
        RETURNING (id)
    """
    
    return execute_update(query, (name, category_id, label))
    # query = f"INSERT INTO content_history ({columns}) VALUES ({placeholders})"

async def create_topic(subcategory_id, name, label):
    query = """
        INSERT INTO topic (name, subcategory_id, label) VALUES (%s, %s, %s)
        RETURNING (id)
    """
    return execute_update(query, (name, subcategory_id, label))