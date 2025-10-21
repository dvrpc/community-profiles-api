from fastapi import APIRouter
from repository.profile_repository import fetch_content_template, fetch_county, fetch_municipality, fetch_region
from services.content import build_content, build_template_tree
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from fastapi.templating import Jinja2Templates

router = APIRouter(
    prefix="/content",
)

# @router.get("/tract/{geoid}")
# def get_tract(geoid: int):
#     profile = build_tract_profile(geoid)
#     return profile

templates = Jinja2Templates(directory="content")


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
