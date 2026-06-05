from dataclasses import dataclass, field
from datetime import datetime
import asyncio
from fastapi import HTTPException

from services import data_builder
from services.revalidate import revalidate_all

@dataclass
class BuildState:
    is_building: bool = False
    category: str | None = None
    started_at: datetime | None = None
    finished_at: datetime | None = None

state = BuildState()

async def run_build(category: str, variables: dict[str, str] | None = None):
    if state.is_building:
        raise HTTPException(status_code=409, detail="Build already in progress")
    
    state.is_building = True
    state.category = category
    state.started_at = datetime.now()
    
    try:
        if category == "acs":
            await data_builder.build_acs(variables or None)
        elif category == "gis":
            await data_builder.build_gis()
        elif category == "ckan":
            await data_builder.build_ckan()
        elif category == "all":
            await data_builder.build_all()

        await data_builder.build_regional()
        await data_builder.recalibrate_variables()
        revalidate_all()
    except Exception:
        raise
    finally:
        state.is_building = False
        state.finished_at = datetime.now()