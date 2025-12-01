import repository.content_product_repository as content_product_repo

async def sync_content_product(content_id, product_ids):
    current_product_ids = await content_product_repo.find(content_id)

    current_product_set = set([row['product_id'] for row in current_product_ids])
    new_product_set = set(product_ids)
    to_add = new_product_set - current_product_set
    to_delete = current_product_set - new_product_set
    
    if to_delete:
        await content_product_repo.delete(content_id, list(to_delete))
    
    if to_add:
        for product_id in to_add:
            await content_product_repo.create(content_id, product_id)