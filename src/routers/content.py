from fastapi import APIRouter
from repository.profile_repository import fetch_county, fetch_municipality
from services.content import build_content
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
