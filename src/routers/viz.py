from fastapi import APIRouter, Body, HTTPException, status
from repository.profile_repository import fetch_county, fetch_municipality, fetch_region
from repository.viz_repository import fetch_viz_template, fetch_viz
from repository.viz_history_repository import fetch_viz_history
from services.viz import build_viz, update_viz
import json

router = APIRouter(
    prefix="/viz",
)


@router.get("/county")
async def get_county_viz(geoid: str, category: str, subcategory: str, topic: str):
    profile = await fetch_county(geoid)
    viz = await fetch_viz('county', category, subcategory, topic)
    populated_viz = await build_viz(viz, profile)
    return populated_viz


@router.get("/municipality")
async def get_municipality_viz(geoid: str, category: str, subcategory: str, topic: str):
    profile = await fetch_municipality(geoid)
    viz = await fetch_viz('municipality', category, subcategory, topic)
    populated_viz = await build_viz(viz, profile)
    return populated_viz


@router.get("/region")
async def get_region_viz(category: str, subcategory: str, topic: str):
    profile = await fetch_region()
    viz = await fetch_viz('region', category, subcategory, topic)
    populated_viz = await build_viz(viz, profile)
    return populated_viz


@router.get('/template/{geo_level}')
async def get_viz_template(geo_level: str, category: str, subcategory: str, topic: str):
    template = await fetch_viz_template(geo_level, category, subcategory, topic)
    return template


@router.post('/preview/{geo_level}')
async def get_viz_preview(geo_level: str, geoid: str = None, body: str = Body(..., media_type="text/plain")):
    if (geo_level == 'region'):
        profile = await fetch_region()
    else:
        if not geoid:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, detail="No geoid provided")

        if (geo_level == 'county'):
            profile = await fetch_county(geoid)
        else:
            profile = await fetch_municipality(geoid)

    parsed_body = json.loads(body)
    template = await build_viz(parsed_body, profile)
    return template


@router.put('/{geo_level}')
async def create_viz(geo_level: str, category: str, subcategory: str, topic: str, body: str = Body(..., media_type="text/plain")):
    res = await update_viz(category, subcategory, topic, geo_level, body)
    
    return res


@router.get('/history/{geo_level}')
async def get_viz_history(geo_level: str, category: str, subcategory: str, topic: str):
    current = await fetch_viz(geo_level, category, subcategory, topic, all_info=True)

    all_viz = [current]
    history = await fetch_viz_history(category, subcategory, topic, geo_level)
    all_viz += history

    return all_viz
