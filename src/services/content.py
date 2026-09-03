import mistune
import logging


import repository.content_repository as content_repo
import repository.topic_repository as topic_repo
from services.topic_source import sync_topic_source
from services.topic_product import sync_content_product

from schemas.content import ContentUpdate

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
    content_tree = await content_repo.find_by_geo(geo_level)
    for content in content_tree:
        html_conversion = mistune.html(content['content'])
        populated_content = populate_template(html_conversion, profile)
        content['content'] = populated_content

        for subcategory in content['subcategories']:
            for topic in subcategory['topics']:
                html_conversion = mistune.html(topic['content'])
                populated_content = populate_template(html_conversion, profile)
                topic['content'] = populated_content
                topic['variables'] = get_template_variables(html_conversion)


    return content_tree


async def build_single_content(template: str, profile):
    html_conversion = mistune.html(template)
    populated_content = populate_template(html_conversion, profile)
    return populated_content
