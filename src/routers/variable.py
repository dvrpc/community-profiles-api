from fastapi import APIRouter, status, Depends
from typing import List

import asyncio
from schemas.variable import Variable, VariableRequest
from services.auth import require_admin
from services.revalidate import revalidate_all
import repository.variable_repository as variable_repo
import services.profile as profile_service
import services.variable as variable_service
from services.build_state import run_build


router = APIRouter(
    prefix="/variable",
)


@router.get("", response_model=List[Variable])
async def get_variables():
    variables = await variable_repo.find_all_variables()
    return variables


@router.get("/{geo_level}", response_model=List[Variable])
async def get_variables_by_geo_level(geo_level: str):
    return []


@router.get("/{data_source}", response_model=List[Variable])
async def get_variables_by_data_source(data_source: str):
    variables = await variable_repo.find_variables_by_data_source(data_source)
    return variables


@router.post("")
async def create_variable(variable: VariableRequest, admin=Depends(require_admin)):
    res = await variable_repo.create(variable)
    if variable.data_source == "acs":
        asyncio.create_task(
            run_build("acs", {variable.acs_variable: res[0]})
        )
    return res


@router.put("/{id}")
async def update_variable(id: int, variable: VariableRequest, admin=Depends(require_admin)):
    res = await variable_repo.update(id, variable)
    if variable.data_source == "acs":
        asyncio.create_task(
            run_build("acs", {variable.acs_variable: variable.name})
        )
    return res


@router.delete("/{id}")
async def delete_variable(id: int, admin=Depends(require_admin)):
    res = await variable_repo.delete(id)
    revalidate_all()
    return res[0]
