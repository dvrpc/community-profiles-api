import repository.topic_link_repository as topic_link_repo

async def sync_topic_link(topic_id, link_ids):
    current_link_ids = await topic_link_repo.find(topic_id)

    current_link_set = {row['link_id'] for row in current_link_ids}
    new_link_set = set(link_ids)
    to_add = new_link_set - current_link_set
    to_delete = current_link_set - new_link_set
    
    if to_delete:
        await topic_link_repo.delete(topic_id, list(to_delete))
    
    if to_add:
        for link_id in to_add:
            await topic_link_repo.create(topic_id, link_id)
