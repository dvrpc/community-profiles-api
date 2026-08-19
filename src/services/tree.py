from typing import Optional, Union
import repository.subcategory_repository as subcategory_repo
import repository.topic_repository as topic_repo

import services.revalidate as revalidation_service
import repository.content_repository as content_repo
import repository.topic_content_repository as topic_content_repo
import logging

log = logging.getLogger(__name__)

def create_label(name: str):
    return name.replace('-', ' ').title()

async def build_template_tree(geo_level):
    tree = {}

    response = await topic_repo.find_tree(geo_level)

    for row in response:
        category = row["category"]
        category_id = row["category_id"]
        subcat_id = row["subcategory_id"]
        subcat_name = row["subcategory"]
        subcat_label = row["subcategory_label"]
        sort_weight = row["subcategory_sort_weight"]

        if category not in tree:
            tree[category] = {
                "id": category_id,
                "url_id": row["category_url_id"],
                "label": row["category_label"],
                "subcategories": []
            }

        subcat_entry = next(
            (sc for sc in tree[category]["subcategories"]
             if sc["id"] == subcat_id), None
        )

        if not subcat_entry:
            subcat_entry = {
                "name": subcat_name,
                "url_id": row["subcategory_url_id"],
                "id": subcat_id,
                "label": subcat_label,
                "category_id": category_id,
                "sort_weight": sort_weight,
                "topics": []
            }
            tree[category]["subcategories"].append(subcat_entry)

        subcat_entry["topics"].append({
            "name": row["topic"],
            "url_id": row["topic_url_id"],
            "id": row["topic_id"],
            "label": row["topic_label"],
            "content_id": row["content_id"]
        })

    return tree

async def create_subcategory(category_id: int, geo_level: str, label: str, url_id: str):
    res = await subcategory_repo.create(category_id, geo_level, url_id, label)
    subcategory_id = res[0]
    log.info(f"Created subcategory: {subcategory_id}")
    revalidation_service.revalidate_all()
    return res


async def create_topic(subcategory_id: int, label: str, url_id: str):
    res = await topic_repo.create(subcategory_id, url_id, label)
    topic_id = res[0]
    log.info(f"Created topic: {topic_id}")

    content_res = await content_repo.create("")
    await topic_content_repo.create(topic_id, content_res[0])
    log.info(f"Created empty content {content_res[0]} for topic: {topic_id}")

    revalidation_service.revalidate_all()
    return res




async def update_topic(id: str, topic: dict):
    values = []

    if 'url_id' in topic:
        label = create_label(topic['url_id'])
        values.append(f"url_id = '{topic['url_id']}'")
        values.append(f"label = '{label}'")
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

    if 'url_id' in subcategory:
        label = create_label(subcategory['url_id'])
        values.append(f"url_id = '{subcategory['url_id']}'")
        values.append(f"label = '{label}'")
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
