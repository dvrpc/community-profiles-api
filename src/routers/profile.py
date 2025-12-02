from fastapi import APIRouter
from repository.profile_repository import find_county, find_municipality, find_region

router = APIRouter(
    prefix="/profile",
)


@router.get("/municipality/{geoid}")
async def get_municipality(geoid: str):
    profile = await find_municipality(geoid)
    return profile


@router.get("/county/{geoid}")
async def get_county(geoid: str):
    profile = await find_county(geoid)
    return profile


@router.get("/region")
async def get_region():
    profile = await find_region()
    return profile
