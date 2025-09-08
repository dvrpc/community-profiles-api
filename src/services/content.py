import markdown
import json
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
    md_download_urls = get_download_urls(geo_level, "md")
    viz_download_urls = get_download_urls(geo_level, "viz")

    all_content = []
    for i in range(len(md_download_urls)):
        name = md_download_urls[i]['name']
        md = get_file(md_download_urls[i]['url'])
        viz = json.loads(get_file(viz_download_urls[i]['url']))
        content = populate_template(md, profile)
        all_content.append({
            'category': name,
            'content': content,
            'visualizations': viz
        })

    print(all_content)
    sorted_content = sorted(
        all_content, key=lambda c: sort_order[c['category']])
    return sorted_content
