from fastapi import APIRouter
from services.profile import build_tract_profile, build_muni_profile, build_county_profile


router = APIRouter(
    prefix="/profile",
)

@router.get("/tract/{geoid}")
def get_tract(geoid: int):
    profile = build_tract_profile(geoid)
    return profile


@router.get("/muni/{geoid}")
def get_muni(geoid: int):
    profile = build_muni_profile(geoid)
    return profile


@router.get("/county/{geoid}")
def get_county(geoid: int):
    profile = build_county_profile(geoid)
    return profile
