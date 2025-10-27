from fastapi import APIRouter, Body
from repository.profile_repository import fetch_content_template, fetch_county, fetch_municipality, fetch_region
from services.content import build_content, build_single_content, build_template_tree, update_content

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

@router.get('/template/tree/{geo_level}')
async def get_template_tree(geo_level: str):
    tree = await build_template_tree(geo_level)
    return tree

@router.post('/preview')
async def get_content_template(category: str, subcategory: str, topic: str, body: str = Body(..., media_type="text/plain")):
    profile = await fetch_region()

    template = await build_single_content(body, profile,category, subcategory, topic)
    return template

@router.put('')
async def create_content(category: str, subcategory: str, topic: str, geo_level, body: str = Body(..., media_type="text/plain")):
    res = await update_content(category, subcategory, topic, geo_level, body)
    return res