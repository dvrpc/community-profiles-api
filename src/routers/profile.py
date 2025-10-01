from fastapi import APIRouter
from repository.profile_repository import fetch_county, fetch_municipality, fetch_region
from fastapi_cache.decorator import cache

router = APIRouter(
    prefix="/profile",
)


@router.get("/municipality/{geoid}")
async def get_municipality(geoid: str):
    profile = await fetch_municipality(geoid)
    return profile


@router.get("/county/{geoid}")
async def get_county(geoid: str):
    profile = await fetch_county(geoid)
    return profile

@router.get("/region")
async def get_region():
    profile = await fetch_region()
    return profile
