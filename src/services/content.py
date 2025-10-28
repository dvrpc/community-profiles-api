import mistune
import copy
import logging
import json

from repository.profile_repository import fetch_content, fetch_template_tree, fetch_single_content, create_content_history, update_single_content
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
    all_content = await fetch_content(geo_level)
    content_map = copy.deepcopy(subcategory_map)
    
    for content in all_content:
        populated_content = populate_template(content['file'], profile)
        content_map[content['category']][content['subcategory']].append({
            'name': content['name'],
            'content': populated_content
        })


    return content_map

async def build_template_tree(geo_level):
    response = await fetch_template_tree(geo_level)
    nested_dict = {}

    for item in response:
        cat = item["category"]
        subcat = item["subcategory"]
        name = item["name"]
        
        nested_dict.setdefault(cat, {}).setdefault(subcat, []).append(name)

    return nested_dict

async def build_single_content(template: str, profile):
    populated_content = populate_template(template, profile)
    return populated_content

async def update_content(category: str, subcategory: str, topic: str, geo_level, body: str):
    current_content = await fetch_single_content(category, subcategory, topic, geo_level)
    
    if(current_content):
      await update_single_content(category, subcategory, topic, geo_level, body)
      await create_content_history(current_content)
      return {"message": "Content updated succesfully"}
    else:
        # create
        pass
