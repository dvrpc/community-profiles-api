from fastapi import APIRouter, Body, Depends, Query
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
async def build_acs(variables: dict[str, str] = None, admin=Depends(require_admin)):
    asyncio.create_task(run_build("acs", variables))
    return {"category": "acs"}

@router.post("/gis")
async def build_gis(admin=Depends(require_admin)):
    asyncio.create_task(run_build("gis"))
    return {"category": "gis"}

@router.post("/ckan")
async def build_ckan(admin=Depends(require_admin)):
    asyncio.create_task(run_build("ckan"))
    return {"category": "ckan"}

@router.post("/all")
async def build_all(admin=Depends(require_admin)):
    asyncio.create_task(run_build("all"))
    return {"category": "all"}

@router.get("/status")
async def get_build_status():
    return state
