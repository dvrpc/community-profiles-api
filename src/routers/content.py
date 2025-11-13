from fastapi import APIRouter, Body, HTTPException, status, Depends
import repository.profile_repository as profile_repo
import repository.content_repository as content_repo
import repository.content_history_repository as content_history_repo
import services.content as content_service
from services.auth import require_admin

router = APIRouter(
    prefix="/content",
)


@router.get("/municipality/{geoid}")
async def get_populated_municipality_content(geoid: str):
    profile = await profile_repo.find_municipality(geoid)
    content = await content_service.build_content('municipality', profile)
    return content


@router.get("/county/{geoid}")
async def get_populated_county_content(geoid: str):
    profile = await profile_repo.find_county(geoid)
    content = await content_service.build_content('county', profile)
    return content


@router.get("/region")
async def get_populated_region_content():
    profile = await profile_repo.find_region()
    content = await content_service.build_content('region', profile)
    return content


@router.get('/{id}')
async def get_content(id: int):
    content = await content_repo.find_one(id)
    return content


@router.post('/preview/{geo_level}')
async def get_content_preview(geo_level: str, geoid: str = None, body: str = Body(..., media_type="text/plain")):
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

    template = await content_service.build_single_content(body, profile)
    return template


@router.put('/{id}')
async def update_content(id: int, body: str = Body(..., media_type="text/plain"), admin=Depends(require_admin)):
    res = await content_service.update_content(id, body)
    return res


@router.get('/{id}/history')
async def get_content_history(id: int):
    current = await content_repo.find_one(id)

    all_content = [current]
    history = await content_history_repo.find_by_parent_id(id)
    all_content += history

    return all_content


@router.get('/tree/{geo_level}')
async def get_template_tree(geo_level: str):
    tree = await content_service.build_template_tree(geo_level)
    return tree
