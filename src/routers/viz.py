from fastapi import APIRouter, Body, HTTPException, status, Depends
import services.profile as profile_service
import repository.viz_repository as viz_repo
import repository.viz_history_repository as viz_history_repo
import services.viz as viz_service
from services.auth import require_admin
from schemas.viz import VizCreate, VizUpdate
import json


router = APIRouter(
    prefix="/viz",
)


@router.get("/{topic_id}/county/{geoid}")
async def get_populated_county_viz(topic_id: int, geoid: str):
    profile = await profile_service.build_county_profile(geoid)
    visualizations = await viz_repo.find_by_topic_id(topic_id)
    return await viz_service.populate_visualizations(visualizations, profile)



@router.get("/{topic_id}/municipality/{geoid}")
async def get_populated_municipality_viz(topic_id: int, geoid: str):
    profile = await profile_service.build_municipality_profile(geoid)
    visualizations = await viz_repo.find_by_topic_id(topic_id)

    return await viz_service.populate_visualizations(visualizations, profile)


@router.get("/{topic_id}/region")
async def get_populated_region_viz(topic_id: int):
    profile = await profile_service.build_region_profile()
    visualizations = await viz_repo.find_by_topic_id(topic_id)
    return await viz_service.populate_visualizations(visualizations, profile)



@router.get('/{topic_id}')
async def get_by_topic_id(topic_id: int):
    viz = await viz_repo.find_by_topic_id(topic_id)
    return viz


@router.post('/preview/{geo_level}')
async def get_viz_preview(geo_level: str, geoid: str = None, body: str = Body(..., media_type="text/plain"), admin=Depends(require_admin)):
    if (geo_level == 'region'):
        profile = await profile_service.build_region_profile()
    else:
        if not geoid:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, detail="No geoid provided")

        if (geo_level == 'county'):
            profile = await profile_service.build_county_profile(geoid)
        else:
            profile = await profile_service.build_municipality_profile(geoid)

    parsed_body = json.loads(body)
    template, _ = await viz_service.build_viz(parsed_body, profile)

    return template


@router.put('/{id}')
async def update_viz(id: int, viz: VizUpdate, admin=Depends(require_admin)):
    res = await viz_repo.update(id, viz)
    return res


@router.post('')
async def create_viz(viz: VizCreate, admin=Depends(require_admin)):
    res = await viz_repo.create(viz)
    return res


@router.get('/{id}/history')
async def get_viz_history(id: int):
    current = await viz_repo.find_one(id)

    all_viz = [current]
    history = await viz_history_repo.find_by_parent_id(id)
    all_viz += history

    return all_viz
