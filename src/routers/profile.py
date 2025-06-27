from fastapi import APIRouter, Depends

# from services.foo import FooService
# from schemas.foo import FooItem, FooItemCreate

# from utils.service_result import handle_result

# from config.database import get_db

router = APIRouter(
    prefix="/profile",
)


@router.get("/tract/{geoid}")
async def get_tract(geoid: int):
    return f"tract {geoid}"


@router.get("/muni/{geoid}")
async def get_muni(geoid: int):
    return f"muni {geoid}"


@router.get("/county/{geoid}")
async def get_county(geoid: int):
    return f"muni {geoid}"
