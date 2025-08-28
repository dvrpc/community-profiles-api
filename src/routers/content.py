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
def get_municipality(geoid: str):
    profile = fetch_municipality(geoid)
    content = build_content('municipality', profile)
    return content


@router.get("/county/{geoid}")
def get_county(geoid: str):
    profile = fetch_county(geoid)
    content = build_content('county', profile)
    return content
