import mistune
import copy
import logging


import repository.content_repository as content_repo
import repository.content_history_repository as content_history_repo
from services.content_source import sync_content_source
from services.viz_source import sync_viz_source
from services.content_product import sync_content_product

from services.revalidate import revalidate_frontend, revalidate_all
from jinja.template import env

log = logging.getLogger(__name__)

sort_order = {
    'demographics-housing': 1,
    'economy': 2,
    'active-transportation': 3,
    'safety-health': 4,
    'freight': 5,
    'environment': 6,
    'transit': 7,
    'roadways': 8
}


content_category_map = {
    'demographics-housing': [],
    'economy': [],
    'active-transportation': [],
    'safety-health': [],
    'freight': [],
    'environment': [],
    'transit': [],
    'roadways': []
}


def populate_template(md, profile):
    html_conversion = mistune.html(md)
    template = env.from_string(html_conversion)
    rendered_html = template.render(profile)
    return rendered_html


async def build_content(geo_level, profile):
    category_content = await content_repo.find_category_content(geo_level)
    all_content = await content_repo.find_by_geo(geo_level)

    content_map = {}

    for content in category_content:
        populated_content = populate_template(content['file'], profile)

        content_map[content['category']] = {
            "content_id": content["id"],
            "category_id": content["category_id"],
            "content": populated_content,
            "subcategories": {}
        }

    for content in all_content:
        populated_content = populate_template(content['file'], profile)

        category = content['category']
        subcategory = content['subcategory']

        if subcategory not in content_map[category]['subcategories']:
            content_map[category]['subcategories'][subcategory] = []

        citations = content['citations']
        products = content['products']

        if citations[0] is None:
            citations = []

        if products[0] is None:
            products = []

        content_map[category]['subcategories'][subcategory].append({
            'id': content['id'],
            'name': content['topic'],
            'content': populated_content,
            'citations': citations,
            'related_products': products
        })

    return content_map


async def build_single_content(template: str, profile):
    populated_content = populate_template(template, profile)
    return populated_content


async def update_content(id: int, body: str):
    current_content = await content_repo.find_one(id)

    if (current_content):
        await content_repo.update(id, body)

        history = await content_history_repo.find_by_parent_id(id)

        if (len(history) > 20):
            await content_history_repo.delete(history[-1]['id'])

        current_content['parent_id'] = current_content.pop('id')
        for key in ['source_ids', 'product_ids', 'label']:
            del current_content[key]

        await content_history_repo.create(current_content)
        revalidate_frontend(current_content['geo_level'])
        return {"message": "Content updated succesfully"}
    else:
        # create
        pass


async def build_template_tree(geo_level):
    category_response = await content_repo.find_category_tree(geo_level)

    tree = {}

    for row in category_response:
        category = row["name"]

        tree[category] = {
            "id": row["category_id"],
            "label": row["label"],
            "content_id": row["content_id"],
            "subcategories": []
        }

    response = await content_repo.find_tree(geo_level)

    for row in response:
        category = row["category"]
        category_id = row["category_id"]
        subcat_id = row["subcategory_id"]
        subcat_name = row["subcategory"]
        subcat_label = row["subcategory_label"]

        subcat_entry = next(
            (sc for sc in tree[category]["subcategories"]
             if sc["id"] == subcat_id), None
        )

        if not subcat_entry:
            subcat_entry = {
                "name": subcat_name,
                "id": subcat_id,
                "label": subcat_label,
                "category_id": category_id,
                "topics": []
            }
            tree[category]["subcategories"].append(subcat_entry)

        subcat_entry["topics"].append({
            "name": row["topic"],
            "id": row["topic_id"],
            "label": row["topic_label"],
            "content_id": row["id"]
        })

    return tree


async def update_content_properties(id, properties):
    if 'content_sources' in properties:
        await sync_content_source(id, properties['content_sources'])
        del properties['content_sources']
    if 'viz_sources' in properties:
        await sync_viz_source(id, properties['viz_sources'])
        del properties['viz_sources']
    if 'related_products' in properties:
        await sync_content_product(id, properties['related_products'])
        del properties['related_products']

    request_values = ""

    if not properties:
        revalidate_all()
    for key, value in properties.items():
        if (isinstance(value, str)):
            pair = f"{key} = '{value}'"
        else:
            pair = f"{key} = {value}"

        if not request_values:
            request_values += pair
        else:
            request_values = request_values + ", " + pair

    updated_content = await content_repo.update_content_properties(id, request_values)
    revalidate_frontend(updated_content[1])
    return updated_content[0]
