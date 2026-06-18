from fastapi import APIRouter
from services.profile import build_municipality_profile, build_county_profile, build_region_profile

router = APIRouter(
    prefix="/profile",
)


@router.get("/municipality/{geoid}")
async def get_municipality(geoid: str):
    profile = await build_municipality_profile(geoid)
    return profile


@router.get("/county/{geoid}")
async def get_county(geoid: str):
    profile = await build_county_profile(geoid)
    return profile


@router.get("/region")
async def get_region():
    profile = await build_region_profile()
    return profile
