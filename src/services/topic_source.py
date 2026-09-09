import repository.topic_source_repository as topic_source_repo

async def sync_topic_source(topic_id, source_ids):
    current_source_ids = await topic_source_repo.find(topic_id)

    current_source_set = set([row['source_id'] for row in current_source_ids])
    new_source_set = set(source_ids)
    to_add = new_source_set - current_source_set
    to_delete = current_source_set - new_source_set
    
    if to_delete:
        await topic_source_repo.delete(topic_id, list(to_delete))
    
    if to_add:
        for source_id in to_add:
            await topic_source_repo.create(topic_id, source_id)
