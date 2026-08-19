import logging
# from repository.viz_repository import find_by_filters, update
# from repository.viz_history_repository import create, delete, find_by_filters
from schemas.viz import VizRequest
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
    viz['variables'] = variables
    viz['citations'] = viz.get('citations', [])
    return viz


async def build_viz(viz, profile, citations):
    """
    Populates visualizations with db variables. There can be more than one viz in a viz object
    """
    populated_viz = []
    if (len(viz) > 0):
        for v in viz:
            if (v['type'] and v['type'] == 'chart'):
                v['citations'] = citations
                populated_viz.append(populate_viz(v, profile))
            else:
                populated_viz.append(v)

    return populated_viz


async def update_viz(id: int, body: VizRequest):
    current_viz = await viz_repo.find_one_basic(id)
    if (current_viz):
        await viz_repo.update(id, body.file)
        # The database trigger writes viz_history using viz_id and archived_at.
        return {"message": "viz updated succesfully"}
    else:
        # create
        pass
