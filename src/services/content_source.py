import repository.content_source_repository as content_source_repo

async def sync_content_source(content_id, source_ids):
    current_source_ids = await content_source_repo.find(content_id)

    current_source_set = set([row['source_id'] for row in current_source_ids])
    new_source_set = set(source_ids)
    to_add = new_source_set - current_source_set
    to_delete = current_source_set - new_source_set
    
    if to_delete:
        await content_source_repo.delete(content_id, list(to_delete))
    
    if to_add:
        for source_id in to_add:
            await content_source_repo.create(content_id, source_id)