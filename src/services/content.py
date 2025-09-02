import markdown
from repository.content_repository import get_download_urls, get_file
from services.template import env

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
    html_conversion = markdown.markdown(md)
    template = env.from_string(html_conversion)
    rendered_html = template.render(profile)
    return rendered_html


def build_content(geo_level, profile):
    download_urls = get_download_urls(geo_level)

    all_content = []
    for url in download_urls:
        md = get_file(url['url'])
        content = populate_template(md, profile)
        all_content.append({
            'category': url['name'],
            'content': content
        })

    sorted_content = sorted(
        all_content, key=lambda c: sort_order[c['category']])
    return sorted_content
