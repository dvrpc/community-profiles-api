from fastapi import APIRouter
from repository.profile_repository import fetch_county, fetch_municipality
from services.viz import build_visualizations
from fastapi_cache.decorator import cache

router = APIRouter(
    prefix="/viz",
)


@router.get("/county")
async def get_county_visualizations(geoid: str, category: str):
    profile = await fetch_county(geoid)
    viz = await build_visualizations('county', profile, category)
    return viz


@router.get("/municipality")
async def get_municipality_visualizations(geoid: str, category: str):
    profile = await fetch_municipality(geoid)
    viz = await build_visualizations('municipality', profile, category)
    return viz
