import logging
from repository.profile_repository import fetch_visualizations

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
    visualizations = await fetch_visualizations(geo_level, category, subcategory, topic)

    if (len(visualizations) > 0):
        for index, viz in enumerate(visualizations):
            print(viz)
            if (viz['type'] and viz['type'] == 'chart'):
                visualizations[index] = populate_viz(viz, profile)

    return visualizations
