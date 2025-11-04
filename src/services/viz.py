import logging
from repository.viz_repository import fetch_viz, update_single_viz
from repository.viz_history_repository import create_viz_history, delete_viz_history, fetch_viz_history

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
    if (len(viz) > 0):
        for index, viz in enumerate(viz):
            if (viz['type'] and viz['type'] == 'chart'):
                viz[index] = populate_viz(viz, profile)

    return viz


async def update_viz(category: str, subcategory: str, topic: str, geo_level, body: str):
    current_viz = await fetch_viz(geo_level, category, subcategory, topic, all_info=True)

    if (current_viz):
        await update_single_viz(category, subcategory, topic, geo_level, body)
        
        history = await fetch_viz_history(category, subcategory, topic, geo_level)

        if(len(history) > 20):
            await delete_viz_history(history[-1]['id'])
            
        await create_viz_history(current_viz)
        return {"message": "viz updated succesfully"}
    else:
        # create
        pass
