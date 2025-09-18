import mistune
import logging

from repository.github_repository import get_download_urls, get_md_files
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


def populate_template(md, profile):
    html_conversion = mistune.html(md)
    template = env.from_string(html_conversion)
    rendered_html = template.render(profile)
    return rendered_html


async def build_content(geo_level, profile):
    md_download_urls = await get_download_urls(geo_level, 'md')

    all_content = []
    files = await get_md_files(md_download_urls)

    for md in files:
        content = populate_template(md['file'], profile)
        all_content.append({
            'category': md['name'],
            'content': content,
        })

    sorted_content = sorted(
        all_content, key=lambda c: sort_order[c['category']])
    return sorted_content
