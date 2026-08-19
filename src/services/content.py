import mistune
import logging


import repository.content_repository as content_repo
from services.content_source import sync_content_source
from services.content_product import sync_content_product
from schemas.content import ContentRequest

from services.revalidate import revalidate_all
from jinja.template import env
from jinja2 import meta

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

excluded_variables = {'geoid', 'state', 'county', 'mun_name'}


def get_template_variables(html_conversion):
    parsed = env.parse(html_conversion)
    variables = meta.find_undeclared_variables(parsed)
    return variables - excluded_variables


def populate_template(html_conversion, profile):
    template = env.from_string(html_conversion)
    rendered_html = template.render(profile)

    # try:
    #     rendered_html = template.render(profile)
    # except Exception as e:
    #     log.error("Failed to populate template:",  e)

    return rendered_html


async def build_content(geo_level, profile):
    category_content = await content_repo.find_category_content()
    all_content = await content_repo.find_by_geo(geo_level)

    content_map = {}

    for content in category_content:
        html_conversion = mistune.html(content['file'])
        populated_content = populate_template(html_conversion, profile)

        content_map[content['category']] = {
            "content_id": content["id"],
            "category_id": content["category_id"],
            "content": populated_content,
            "subcategories": []
        }

    for content in all_content:
        html_conversion = mistune.html(content['file'])
        populated_content = populate_template(html_conversion, profile)
        variables = get_template_variables(html_conversion)

        category = content['category']
        subcategory_id = content['subcategory_id']
        subcategory = content['subcategory']
        subcategory_label = content['subcategory_label']

        content_map.setdefault(category, {
            "category_id": content["category_id"],
            "content_id": None,
            "content": "",
            "subcategories": []
        })

        subcat_entry = next(
            (sc for sc in content_map[category]["subcategories"]
             if sc["id"] == subcategory_id), None
        )

        if not subcat_entry:
            subcat_entry = {
                'id': subcategory_id,
                'name': subcategory,
                'label': subcategory_label,
                'topics': []
            }
            content_map[category]["subcategories"].append(subcat_entry)

        topic_label = content['topic_label']
        citations = content['citations']
        products = content['products']

        subcat_entry['topics'].append({
            'id': content['id'],
            'name': content['topic'],
            'label': topic_label,
            'content': populated_content,
            'citations': citations,
            'related_products': products,
            'variables': variables
        })

    return content_map


async def build_single_content(template: str, profile):
    html_conversion = mistune.html(template)
    populated_content = populate_template(html_conversion, profile)
    return populated_content


async def update_content(id: int, body: ContentRequest):
    current_content = await content_repo.find_one_basic(id)

    if current_content:
        await content_repo.update(id, body.text)
        # The database trigger records history using content_id and archived_at.
        revalidate_all()
        return {"message": "Content updated succesfully"}
    return None
