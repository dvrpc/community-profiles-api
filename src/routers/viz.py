from fastapi import APIRouter, Body, HTTPException, status, Depends
# from repository.profile_repository import find_county, find_municipality, find_municipality
# from repository.viz_repository import find_template, find_by_filters
# from repository.viz_history_repository import find_by_filters
import repository.profile_repository as profile_repo
import repository.viz_repository as viz_repo
import repository.viz_history_repository as viz_history_repo
import services.viz as viz_service
from services.auth import require_admin
import json


router = APIRouter(
    prefix="/viz",
)


@router.get("/{id}/county/{geoid}")
async def get_populated_county_viz(id: int, geoid: str):
    profile = await profile_repo.find_county(geoid)
    viz = await viz_repo.find_one(id)
    populated_viz = await viz_service.build_viz(viz, profile)
    return populated_viz


@router.get("/{id}/municipality/{geoid}")
async def get_populated_municipality_viz(id: int, geoid: str):
    profile = await profile_repo.find_municipality(geoid)
    viz = await viz_repo.find_one(id)
    populated_viz = await viz_service.build_viz(viz, profile)
    return populated_viz


@router.get("/{id}/region")
async def get_populated_region_viz(id: int):
    profile = await profile_repo.find_region()
    viz = await viz_repo.find_one(id)
    populated_viz = await viz_service.build_viz(viz, profile)
    return populated_viz


@router.get('/{id}')
async def get_viz(id: int):
    template = await viz_repo.find_one(int)
    return template


@router.post('/preview/{geo_level}')
async def get_viz_preview(geo_level: str, geoid: str = None, body: str = Body(..., media_type="text/plain")):
    if (geo_level == 'region'):
        profile = await profile_repo.find_region()
    else:
        if not geoid:
            raise HTTPException(
                status_code=status.HTTP_400_BAD_REQUEST, detail="No geoid provided")

        if (geo_level == 'county'):
            profile = await profile_repo.find_county(geoid)
        else:
            profile = await profile_repo.find_municipality(geoid)

    parsed_body = json.loads(body)
    template = await viz_service.build_viz(parsed_body, profile)

    return template


@router.put('/{id}')
async def update_viz(id: int, body: str = Body(..., media_type="text/plain"), admin=Depends(require_admin)):
    res = await viz_service.update_viz(id, body)

    return res


@router.get('/{id}/history')
async def get_viz_history(id: int):
    current = await viz_repo.find_one(id)

    all_viz = [current]
    history = await viz_history_repo.find_by_parent_id(id)
    all_viz += history

    return all_viz
