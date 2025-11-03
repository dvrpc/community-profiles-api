import logging
from repository.viz_repository import fetch_visualizations, update_single_visualization
from repository.viz_history_repository import create_visualization_history, delete_viz_history, fetch_visualization_history

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


async def build_visualizations(visualizations, profile):
    if (len(visualizations) > 0):
        for index, viz in enumerate(visualizations):
            if (viz['type'] and viz['type'] == 'chart'):
                visualizations[index] = populate_viz(viz, profile)

    return visualizations


async def update_visualization(category: str, subcategory: str, topic: str, geo_level, body: str):
    current_visualizations = await fetch_visualizations(geo_level, category, subcategory, topic, all_info=True)

    if (current_visualizations):
        await update_single_visualization(category, subcategory, topic, geo_level, body)
        
        history = await fetch_visualization_history(category, subcategory, topic, geo_level)

        if(len(history) > 20):
            await delete_viz_history(history[-1]['id'])
            
        await create_visualization_history(current_visualizations)
        return {"message": "Visualizations updated succesfully"}
    else:
        # create
        pass
