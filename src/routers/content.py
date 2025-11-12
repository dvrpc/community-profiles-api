from fastapi import APIRouter, Body, HTTPException, status, Depends
import repository.profile_repository as profile_repo
import repository.content_repository as content_repo
import repository.content_history_repository as content_history_repo
from services.content import build_content, build_single_content, update_content, build_template_tree
from services.auth import require_admin

router = APIRouter(
    prefix="/content",
)


@router.get("/municipality/{geoid}")
async def get_municipality(geoid: str):
    profile = await profile_repo.find_municipality(geoid)
    content = await build_content('municipality', profile)
    return content


@router.get("/county/{geoid}")
async def get_county(geoid: str):
    profile = await profile_repo.find_county(geoid)
    content = await build_content('county', profile)
    return content


@router.get("/region")
async def get_region():
    profile = await profile_repo.find_municipality()
    content = await build_content('region', profile)
    return content


@router.get('/template/{geo_level}')
async def get_content_template(geo_level: str, category: str, subcategory: str, topic: str):
    template = await content_repo.find_template(geo_level, category, subcategory, topic)
    return template


@router.post('/preview/{geo_level}')
async def get_content_preview(geo_level: str, geoid: str = None, body: str = Body(..., media_type="text/plain")):
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

    template = await build_single_content(body, profile)
    return template


@router.put('/{geo_level}')
async def create_content(geo_level: str, category: str, subcategory: str, topic: str, body: str = Body(..., media_type="text/plain"), admin=Depends(require_admin)):
    res = await update_content(category, subcategory, topic, geo_level, body)
    return res


@router.get('/history/{geo_level}')
async def get_content_history(geo_level: str, category: str, subcategory: str, topic: str):
    current = await content_repo.find_one(category, subcategory, topic, geo_level)

    all_content = [current]
    history = await content_history_repo.find_by_filters(category, subcategory, topic, geo_level)
    all_content += history

    return all_content


@router.get('/template/tree/{geo_level}')
async def get_template_tree(geo_level: str):
    tree = await build_template_tree(geo_level)
    return tree
