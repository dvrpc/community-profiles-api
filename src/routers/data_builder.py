from fastapi import APIRouter, Body, Depends
from typing import Optional

from redis import asyncio
import asyncio
import services.data_builder as data_builder
from services.build_state import run_build, state
from services.auth import require_admin

router = APIRouter(
    prefix="/build"
)

@router.post("/acs")
async def build_acs(
    acs_year: int | None = Body(None),
    variables: dict[str, str] | None = Body(None),
    admin=Depends(require_admin),
):
    asyncio.create_task(run_build("acs", variables, acs_year))
    return {"category": "acs", "acs_year": acs_year}

@router.post("/gis")
async def build_gis(admin=Depends(require_admin)):
    asyncio.create_task(run_build("gis"))
    return {"category": "gis"}

@router.post("/ckan")
async def build_ckan(admin=Depends(require_admin)):
    asyncio.create_task(run_build("ckan"))
    return {"category": "ckan"}

@router.post("/all")
async def build_all(
    acs_year: int | None = Body(None),
    admin=Depends(require_admin),
):
    asyncio.create_task(run_build("all", acs_year=acs_year))
    return {"category": "all", "acs_year": acs_year}

@router.get("/status")
async def get_build_status():
    return state
