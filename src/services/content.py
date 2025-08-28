import markdown
from repository.content_repository import get_download_urls, get_file
from services.template import env


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
    return all_content
