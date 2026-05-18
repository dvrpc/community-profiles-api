from fastapi import APIRouter, status, Depends
from typing import List
from schemas.variable import Variable, VariableRequest
from services.auth import require_admin
from services.revalidate import revalidate_all
import repository.variable_repository as variable_repo

router = APIRouter(
    prefix="/variable",
)


@router.get("", response_model=List[Variable])
async def get_variables():
    variables = await variable_repo.find_all_variables()
    return variables

@router.get("/{data_source}", response_model=List[Variable])
async def get_variables_by_data_source(data_source: str):
    variables = await variable_repo.find_variables_by_data_source(data_source)
    return variables

@router.post("")
async def create_variable(variable: VariableRequest, admin=Depends(require_admin)):
    res = await variable_repo.create(variable)
    return res


@router.put("/{id}")
async def update_variable(id: int, variable: VariableRequest, admin=Depends(require_admin)):
    res = await variable_repo.update(id, variable)
    revalidate_all()
    return res


@router.delete("/{id}")
async def delete_variable(id: int, admin=Depends(require_admin)):
    res = await variable_repo.delete(id)
    revalidate_all()
    return res
