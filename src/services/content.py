import mistune
import copy
import logging


import repository.content_repository as content_repo
import repository.content_history_repository as content_history_repo
from services.revalidate import revalidate_frontend
from jinja.template import env
from utils.consts import subcategory_map

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
    all_content = await content_repo.find_by_geo(geo_level)
    content_map = copy.deepcopy(subcategory_map)

    for content in all_content:
        populated_content = populate_template(content['file'], profile)
        content_map[content['category']][content['subcategory']].append({
            'id': content['id'],
            'name': content['name'],
            'content': populated_content
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
        await content_history_repo.create(current_content)
        revalidate_frontend(current_content['geo_level'])
        return {"message": "Content updated succesfully"}
    else:
        # create
        pass


async def build_template_tree(geo_level):
    response = await content_repo.find_tree(geo_level)
    nested_dict = {}

    for item in response:
        cat = item["category"]
        subcat = item["subcategory"]
        name = item["name"]
        id = item["id"]

        nested_dict.setdefault(cat, {}).setdefault(subcat, []).append({
            'id': id,
            'name': name,
        })

    return nested_dict
