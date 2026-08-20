from schemas.subcategory import SubcategoryCreate, SubcategoryUpdate
from schemas.topic import TopicCreate, TopicUpdate
import repository.subcategory_repository as subcategory_repo
import repository.topic_repository as topic_repo

import services.revalidate as revalidation_service
import repository.content_repository as content_repo
import repository.topic_content_repository as topic_content_repo
import logging

log = logging.getLogger(__name__)

def create_label(name: str):
    return name.replace('-', ' ').title()

async def create_subcategory(subcategory: SubcategoryCreate):
    res = await subcategory_repo.create(
        subcategory.category_id,
        subcategory.geo_level,
        subcategory.url_id,
        subcategory.label,
    )
    subcategory_id = res[0]
    log.info(f"Created subcategory: {subcategory_id}")
    revalidation_service.revalidate_all()
    return res


async def create_topic(topic: TopicCreate):
    res = await topic_repo.create(topic.subcategory_id, topic.url_id, topic.label)
    topic_id = res[0]
    log.info(f"Created topic: {topic_id}")

    content_res = await content_repo.create("")
    await topic_content_repo.create(topic_id, content_res[0])
    log.info(f"Created empty content {content_res[0]} for topic: {topic_id}")

    revalidation_service.revalidate_all()
    return res




async def update_topic(id: int, topic: TopicUpdate):
    topic_data = topic.model_dump(exclude_unset=True)
    values = []

    if 'url_id' in topic_data:
        label = create_label(topic_data['url_id'])
        values.append(f"url_id = '{topic_data['url_id']}'")
        values.append(f"label = '{label}'")
    if 'label' in topic_data:
        values.append(f"label = '{topic_data['label']}'")
    if 'sort_weight' in topic_data:
        values.append(f"sort_weight = {topic_data['sort_weight']}")

    value_str = ','.join(values)
    res = await topic_repo.update(id, value_str)
    revalidation_service.revalidate_all()
    return res

async def update_subcategory(id: int, subcategory: SubcategoryUpdate):
    subcategory_data = subcategory.model_dump(exclude_unset=True)
    values = []

    if 'url_id' in subcategory_data:
        label = create_label(subcategory_data['url_id'])
        values.append(f"url_id = '{subcategory_data['url_id']}'")
        values.append(f"label = '{label}'")
    if 'label' in subcategory_data:
        values.append(f"label = '{subcategory_data['label']}'")
    if 'sort_weight' in subcategory_data:
        values.append(f"sort_weight = {subcategory_data['sort_weight']}")

    value_str = ','.join(values)
    res = await subcategory_repo.update(id, value_str)
    revalidation_service.revalidate_all()
    return res

# async def update_subcategory(id: int, name: str):
#     label = create_label(name)

#     res = await subcategory_repo.update(id, name, label)
#     revalidation_service.revalidate_all()

#     return res
