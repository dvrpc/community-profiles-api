from fastapi import APIRouter, Body
from repository.profile_repository import fetch_county, fetch_municipality, fetch_region
from repository.content_repository import fetch_content_history, fetch_single_content, fetch_content_template
from services.content import build_content, build_single_content, update_content, build_template_tree

router = APIRouter(
    prefix="/content",
)


@router.get("/municipality/{geoid}")
async def get_municipality(geoid: str):
    profile = await fetch_municipality(geoid)
    content = await build_content('municipality', profile)
    return content


@router.get("/county/{geoid}")
async def get_county(geoid: str):
    profile = await fetch_county(geoid)
    content = await build_content('county', profile)
    return content


@router.get("/region")
async def get_region():
    profile = await fetch_region()
    content = await build_content('region', profile)
    return content


@router.get('/template/{geo_level}')
async def get_content_template(geo_level: str, category: str, subcategory: str, topic: str):
    template = await fetch_content_template(geo_level, category, subcategory, topic)
    return template


@router.post('/preview/{geo_level}')
async def get_content_preview(geo_level: str, body: str = Body(..., media_type="text/plain")):
    if (geo_level == 'region'):
        profile = await fetch_region()
    elif (geo_level == 'county'):
        profile = await fetch_county("42101")
    else:
        profile = await fetch_municipality("4201704976")

    template = await build_single_content(body, profile)
    return template


@router.put('/{geo_level}')
async def create_content(geo_level: str, category: str, subcategory: str, topic: str, body: str = Body(..., media_type="text/plain")):
    res = await update_content(category, subcategory, topic, geo_level, body)
    return res


@router.get('/history/{geo_level}')
async def get_content_history(geo_level: str, category: str, subcategory: str, topic: str):
    current = await fetch_single_content(category, subcategory, topic, geo_level)

    all_content = [current]
    history = await fetch_content_history(category, subcategory, topic, geo_level)
    all_content += history

    return all_content


@router.get('/template/tree/{geo_level}')
async def get_template_tree(geo_level: str):
    tree = await build_template_tree(geo_level)
    return tree
