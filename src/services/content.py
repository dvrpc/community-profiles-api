import mistune
import copy
import logging

from repository.github_repository import get_md_download_urls, get_md_files
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
    md_download_urls = await get_md_download_urls(geo_level)
    files = await get_md_files(md_download_urls)

    content_map = copy.deepcopy(subcategory_map)
    for md in files:
        content = populate_template(md['file'], profile)
        content_map[md['category']][md['subcategory']].append({
            'name': md['name'],
            'content': content
        })

    return content_map
