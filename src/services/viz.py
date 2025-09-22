import logging
from repository.github_repository import get_viz_download_url, get_file

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


async def build_visualizations(geo_level, profile, category, subcategory, topic):
    viz_download_url = await get_viz_download_url(geo_level, category, subcategory, topic)

    visualizations = get_file(viz_download_url)

    if (len(visualizations) > 0):
        for index, viz in enumerate(visualizations):
            if (viz['type'] and viz['type'] == 'chart'):
                visualizations[index] = populate_viz(viz, profile)

    return visualizations
