from typing import Optional, Union
import repository.subcategory_repository as subcategory_repo
import repository.topic_repository as topic_repo

import services.revalidate as revalidation_service
import repository.content_repository as content_repo
import repository.viz_repository as viz_repo
import logging
import json

from schemas.topic import TopicRequest

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
        content_id = content_res[0]
        log.info(f"Created content: {content_id}")
        viz_res = await viz_repo.create(topic_id, geo_level, default_viz_file, content_id)
        log.info(f"Created viz: {viz_res[0]}")

    revalidation_service.revalidate_all()
    return res




async def update_topic(id: str, topic: dict):
    values = []

    if 'name' in topic:
        label = create_label(topic['name'])
        values.append(f"name = '{topic['name']}'")
        values.append(f"label = '{label}'")
    else:
        if 'label' in topic:
            values.append(f"label = '{topic['label']}'")
        if 'sort_weight' in topic:
            values.append(f"sort_weight = {topic['sort_weight']}")

    value_str = ','.join(values)
    res = await topic_repo.update(id, value_str)
    revalidation_service.revalidate_all()
    return res

async def update_subcategory(id: str, subcategory: dict):
    values = []

    if 'name' in subcategory:
        label = create_label(subcategory['name'])
        values.append(f"name = '{subcategory['name']}'")
        values.append(f"label = '{label}'")
    else:
        if 'label' in subcategory:
            values.append(f"label = '{subcategory['label']}'")
        if 'sort_weight' in subcategory:
            values.append(f"sort_weight = {subcategory['sort_weight']}")

    value_str = ','.join(values)
    res = await subcategory_repo.update(id, value_str)
    revalidation_service.revalidate_all()
    return res

# async def update_subcategory(id: int, name: str):
#     label = create_label(name)

#     res = await subcategory_repo.update(id, name, label)
#     revalidation_service.revalidate_all()

#     return res
