import repository.subcategory_repository as subcategory_repo
import repository.topic_repository as topic_repo

import services.revalidate as revalidation_service
import repository.content_repository as content_repo
import repository.viz_repository as viz_repo
import logging
import json

log = logging.getLogger(__name__)

default_content_file = "{% from 'display_variable.jinja' import display_variable %}"
default_viz_file = json.dumps([])

def create_label(name: str):
    name.replace('-', ' ')
    return name.title()

async def create_subcategory(category_id: int, name: str):
    label = create_label(name)
    res = await subcategory_repo.create(category_id, name, label)
    subcategory_id = res[0]
    log.info(f"Created subcategory: {subcategory_id}")
    await create_topic(subcategory_id, 'new-topic')
    revalidation_service.revalidate_all()
    return res

async def create_topic(subcategory_id, name):
    label = create_label(name)
    res = await topic_repo.create(subcategory_id, name, label)
    topic_id = res[0]
    log.info(f"Created topic: {topic_id}")
  
    for geo_level in ['region', 'county', 'municipality']:
        content_res = await content_repo.create(topic_id, geo_level, default_content_file)
        log.info(f"Created content: {content_res[0]}")
        viz_res = await viz_repo.create(topic_id, geo_level, default_viz_file)
        log.info(f"Created viz: {viz_res[0]}")

        
    revalidation_service.revalidate_all()
    return res

async def update_subcategory(id: int, name: str):
    label = create_label(name)

    res = await subcategory_repo.update(id, name, label)
    revalidation_service.revalidate_all()

    return res

async def update_topic(id: str, name: str):
    label = create_label(name)
    res = await topic_repo.update(id, name, label)
    revalidation_service.revalidate_all()
    return res
