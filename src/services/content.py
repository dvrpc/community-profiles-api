import markdown
import json
import logging
from repository.content_repository import get_download_urls, get_file
from services.template import env

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
    html_conversion = markdown.markdown(md)
    template = env.from_string(html_conversion)
    rendered_html = template.render(profile)
    return rendered_html

def populate_viz(viz, profile):
    values = viz['schema']['data']['values']
    target_field = viz['target_field']
        
    try: 
        for index, val in enumerate(values):
            values[index][target_field] = profile[val[target_field]]
    except Exception as e:
        log.error(f"Exception occured populating viz: {e}")
        
    viz['schema']['data']['values'] = values
    return viz
        
        


def build_content(geo_level, profile):
    md_download_urls = get_download_urls(geo_level, "md")
    viz_download_urls = get_download_urls(geo_level, "viz")

    all_content = []
    for i in range(len(md_download_urls)):
        name = md_download_urls[i]['name']
        md = get_file(md_download_urls[i]['url'])
        visualizations = json.loads(get_file(viz_download_urls[i]['url']))
        content = populate_template(md, profile)
        

        if(len(visualizations) > 0):   
            for index, viz in enumerate(visualizations):
                if(viz['type'] and viz['type'] == 'chart'):
                    visualizations[index] = populate_viz(viz, profile)
            
        all_content.append({
            'category': name,
            'content': content,
            'visualizations': visualizations
        })

    sorted_content = sorted(
        all_content, key=lambda c: sort_order[c['category']])
    return sorted_content
