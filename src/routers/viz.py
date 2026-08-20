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


@router.get("/{id}/county/{geoid}")
async def get_populated_county_viz(id: int, geoid: str):
    profile = await profile_service.build_county_profile(geoid)
    viz = await viz_repo.find_one(id)
    citations = viz['citations']
    viz = json.loads(viz['file'])
    populated_viz = await viz_service.build_viz(viz, profile, citations)
    return populated_viz


@router.get("/{id}/municipality/{geoid}")
async def get_populated_municipality_viz(id: int, geoid: str):
    profile = await profile_service.build_municipality_profile(geoid)
    viz = await viz_repo.find_one(id)
    citations = viz['citations']
    viz = json.loads(viz['file'])
    populated_viz = await viz_service.build_viz(viz, profile, citations)
    return populated_viz


@router.get("/{id}/region")
async def get_populated_region_viz(id: int):
    profile = await profile_service.build_region_profile()
    viz = await viz_repo.find_one(id)
    citations = viz['citations']
    viz = json.loads(viz['file'])
    populated_viz = await viz_service.build_viz(viz, profile, citations)
    return populated_viz


@router.get('/{id}')
async def get_viz(id: int):
    template = await viz_repo.find_one(id)
    return template


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
    template = await viz_service.build_viz(parsed_body, profile, citations=[])

    return template


@router.put('/{id}')
async def update_viz(id: int, body: VizUpdate, admin=Depends(require_admin)):
    res = await viz_service.update_viz(id, body)
    return res

@router.post('')
async def create_viz(body: VizCreate, admin=Depends(require_admin)):
    res = await viz_repo.create(body.file)
    return res


@router.get('/{id}/history')
async def get_viz_history(id: int):
    current = await viz_repo.find_one(id)

    all_viz = [current]
    history = await viz_history_repo.find_by_parent_id(id)
    all_viz += history

    return all_viz
