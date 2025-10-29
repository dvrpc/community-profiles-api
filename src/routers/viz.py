from fastapi import APIRouter, Body
from repository.profile_repository import fetch_county, fetch_municipality, fetch_region
from repository.viz_repository import fetch_viz_template, fetch_visualizations, fetch_visualization_history
from services.viz import build_visualizations, update_visualization
import json

router = APIRouter(
    prefix="/viz",
)


@router.get("/county")
async def get_county_visualizations(geoid: str, category: str, subcategory: str, topic: str):
    profile = await fetch_county(geoid)
    visualizations = await fetch_visualizations('county', category, subcategory, topic)
    populated_visualizations = await build_visualizations(visualizations, profile)
    return populated_visualizations


@router.get("/municipality")
async def get_municipality_visualizations(geoid: str, category: str, subcategory: str, topic: str):
    profile = await fetch_municipality(geoid)
    visualizations = await fetch_visualizations('municipality', category, subcategory, topic)
    populated_visualizations = await build_visualizations(visualizations, profile)
    return populated_visualizations


@router.get("/region")
async def get_region_visualization(category: str, subcategory: str, topic: str):
    profile = await fetch_region()
    visualizations = await fetch_visualizations('region', category, subcategory, topic)
    populated_visualizations = await build_visualizations(visualizations, profile)
    return populated_visualizations


@router.get('/template/{geo_level}')
async def get_viz_template(geo_level: str, category: str, subcategory: str, topic: str):
    template = await fetch_viz_template(geo_level, category, subcategory, topic)
    return template


@router.get('/template/{geo_level}')
async def get_content_template(geo_level: str, category: str, subcategory: str, topic: str):
    template = await fetch_viz_template(geo_level, category, subcategory, topic)
    return template


@router.post('/preview/{geo_level}')
async def get_visualization_preview(geo_level: str, body: str = Body(..., media_type="text/plain")):
    if (geo_level == 'region'):
        profile = await fetch_region()
    elif (geo_level == 'county'):
        profile = await fetch_county("42101")
    else:
        profile = await fetch_municipality("4201704976")

    parsed_body = json.loads(body)
    template = await build_visualizations(parsed_body, profile)
    return template


@router.put('/{geo_level}')
async def create_visualizations(geo_level: str, category: str, subcategory: str, topic: str, body: str = Body(..., media_type="text/plain")):
    res = await update_visualization(category, subcategory, topic, geo_level, body)
    return res


@router.get('/history/{geo_level}')
async def get_visualization_history(geo_level: str, category: str, subcategory: str, topic: str):
    current = await fetch_visualizations(geo_level, category, subcategory, topic, all_info=True)

    all_visualizations = [current]
    history = await fetch_visualization_history(category, subcategory, topic, geo_level)
    all_visualizations += history

    return all_visualizations
