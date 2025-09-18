import logging
from repository.github_repository import get_download_urls, get_file

log = logging.getLogger(__name__)


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


async def build_visualizations(geo_level, profile, category):
    viz_download_urls = await get_download_urls(geo_level, 'viz')

    url = next(f['url'] for f in viz_download_urls if category == f['name'])
    visualizations = get_file(url)

    if (len(visualizations) > 0):
        for index, viz in enumerate(visualizations):
            if (viz['type'] and viz['type'] == 'chart'):
                visualizations[index] = populate_viz(viz, profile)

    return visualizations
