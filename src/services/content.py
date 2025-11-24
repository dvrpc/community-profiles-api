import mistune
import copy
import logging


import repository.content_repository as content_repo
import repository.content_history_repository as content_history_repo
from services.revalidate import revalidate_frontend
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
    all_content = await content_repo.find_by_geo(geo_level)
    print(all_content)

    content_map = {}
    
    for content in all_content:
        populated_content = populate_template(content['file'], profile)
        
        category = content['category']
        subcategory = content['subcategory']
        
        if category not in content_map:
            content_map[category] = {}
            
        if subcategory not in content_map[category]:
            content_map[category][subcategory] = []
            
        print(content_map)
            
        content_map[category][subcategory].append({
            'id': content['id'],
            'name': content['topic'],
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
    category_response = await content_repo.find_category_tree()
    
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
        
        # if category not in tree:
        #     tree[category] = []

        # if('id' not in tree[category]):
        #     tree[category] = {
        #         "id": category_id,
        #         "label": category_label,
        #         "subcategories": []
        #     }
        

        subcat_entry = next(
            (sc for sc in tree[category]["subcategories"] if sc["id"] == subcat_id), None
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
