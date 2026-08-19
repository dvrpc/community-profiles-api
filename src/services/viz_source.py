import repository.viz_source_repository as viz_source_repo

async def sync_viz_source(topic_id, source_ids):
    """Backward-compatible helper for the schema's topic-level sources."""
    current_source_ids = await viz_source_repo.find(topic_id)
    
    current_source_set = set([row['source_id'] for row in current_source_ids])
    new_source_set = set(source_ids)
    to_add = new_source_set - current_source_set
    to_delete = current_source_set - new_source_set
    
    if to_delete:
        await viz_source_repo.delete(topic_id, list(to_delete))
    
    if to_add:
        for source_id in to_add:
            await viz_source_repo.create(topic_id, source_id)
