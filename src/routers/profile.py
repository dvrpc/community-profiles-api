from fastapi import APIRouter
from repository.profile_repository import fetch_county, fetch_municipality

router = APIRouter(
    prefix="/profile",
)

# @router.get("/tract/{geoid}")
# def get_tract(geoid: int):
#     profile = build_tract_profile(geoid)
#     return profile


@router.get("/municipality/{geoid}")
def get_municipality(geoid: int):
    profile = fetch_municipality(geoid)
    return profile


@router.get("/county/{geoid}")
def get_county(geoid: int):
    profile = fetch_county(geoid)
    return profile
