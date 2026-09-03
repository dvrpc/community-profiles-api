import json
import logging
# from repository.viz_repository import find_by_filters, update
# from repository.viz_history_repository import create, delete, find_by_filters
from schemas.viz import VizUpdate
import repository.viz_repository as viz_repo

log = logging.getLogger(__name__)


def populate_viz(viz, profile):
    values = viz['schema']['data']['values']
    target_field = viz['target_field']
    variables = []

    try:
        for index, val in enumerate(values):
            variables.append(values[index][target_field])
            values[index][target_field] = profile[val[target_field]]['value']
    except Exception as e:
        log.error(f"Exception occured populating viz: {e}")

    viz['schema']['data']['values'] = values
    return viz, variables

async def populate_visualizations(visualizations, profile):
    populated_visualizations = []
    for viz in visualizations:
        viz['file'] = json.loads(viz['file'])
        populated_viz, variables = await build_viz(viz['file'], profile)
        viz['file'] = populated_viz
        viz['variables'] = variables
        populated_visualizations.append(viz)

    return populated_visualizations

async def build_viz(viz, profile):
    """
    Populates visualizations with db variables. There can be more than one viz in a viz object
    """

    if (viz['type'] == 'chart'):
        return populate_viz(viz, profile)
    else:
        return viz, []
