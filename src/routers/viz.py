from fastapi import APIRouter, Body, HTTPException, status, Depends
# from repository.profile_repository import find_county, find_municipality, find_municipality
# from repository.viz_repository import find_template, find_by_filters
# from repository.viz_history_repository import find_by_filters
import repository.profile_repository as profile_repo
import repository.viz_repository as viz_repo
import repository.viz_history_repository as viz_history_repo
from services.viz import build_viz, update_viz
from services.auth import require_admin
import json


router = APIRouter(
    prefix="/viz",
)


@router.get("/county")
async def get_county_viz(geoid: str, category: str, subcategory: str, topic: str):
    profile = await profile_repo.find_county(geoid)
    viz = await viz_repo.find_by_filters('county', category, subcategory, topic)
    populated_viz = await build_viz(viz, profile)
    return populated_viz


@router.get("/municipality")
async def get_municipality_viz(geoid: str, category: str, subcategory: str, topic: str):
    profile = await profile_repo.find_municipality(geoid)
    viz = await viz_repo.find_by_filters('municipality', category, subcategory, topic)
    populated_viz = await build_viz(viz, profile)
    return populated_viz


@router.get("/region")
async def get_region_viz(category: str, subcategory: str, topic: str):
    profile = await profile_repo.find_municipality()
    viz = await viz_repo.find_by_filters('region', category, subcategory, topic)
    populated_viz = await build_viz(viz, profile)
    return populated_viz


@router.get('/template/{geo_level}')
async def get_viz_template(geo_level: str, category: str, subcategory: str, topic: str):
    template = await viz_repo.find_template(geo_level, category, subcategory, topic)
    return template


@router.post('/preview/{geo_level}')
async def get_viz_preview(geo_level: str, geoid: str = None, body: str = Body(..., media_type="text/plain")):
    if (geo_level == 'region'):
        profile = await profile_repo.find_municipality()
    else:
        if not geoid:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, detail="No geoid provided")

        if (geo_level == 'county'):
            profile = await profile_repo.find_county(geoid)
        else:
            profile = await profile_repo.find_municipality(geoid)

    parsed_body = json.loads(body)
    template = await build_viz(parsed_body, profile)

    return template


@router.put('/{geo_level}')
async def create_viz(geo_level: str, category: str, subcategory: str, topic: str, body: str = Body(..., media_type="text/plain"), admin=Depends(require_admin)):
    res = await update_viz(category, subcategory, topic, geo_level, body)

    return res


@router.get('/history/{geo_level}')
async def get_viz_history(geo_level: str, category: str, subcategory: str, topic: str):
    current = await viz_repo.find_by_filters(geo_level, category, subcategory, topic, all_info=True)

    all_viz = [current]
    history = await viz_history_repo.find_by_filters(category, subcategory, topic, geo_level)
    all_viz += history

    return all_viz
