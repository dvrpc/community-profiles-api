import logging
# from repository.viz_repository import find_by_filters, update
# from repository.viz_history_repository import create, delete, find_by_filters

import repository.viz_repository as viz_repo
import repository.viz_history_repository as viz_history_repo

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


async def build_viz(viz, profile):
    """
    Populates visualizations with db variables. There can be more than one viz in a viz object
    """
    populated_viz = []
    if (len(viz) > 0):
        for v in viz:
            if (v['type'] and v['type'] == 'chart'):
                populated_viz.append(populate_viz(v, profile))
            else:
                populated_viz.append(v)

    return populated_viz


async def update_viz(id: int, body: str):
    current_viz = await viz_repo.find_one(id)
    if (current_viz):
        await viz_repo.update(id, body)

        history = await viz_history_repo.find_by_parent_id(id)

        if (len(history) > 20):
            await viz_history_repo.delete(history[-1]['id'])

        current_viz['parent_id'] = current_viz.pop('id')
        del current_viz['source_ids']
        await viz_history_repo.create(current_viz)
        return {"message": "viz updated succesfully"}
    else:
        # create
        pass
