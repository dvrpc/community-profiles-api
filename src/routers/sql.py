from fastapi import APIRouter, Depends
from typing import List

from schemas.sql import SQL, SQLRequest
from services.auth import require_admin
import services.sql as sql_service
import repository.sql_repository as sql_repo

router = APIRouter(
    prefix="/sql",
)


@router.get("", response_model=List[SQL])
async def get_sql():
    return await sql_repo.find_all_sql()


@router.get("/{id}", response_model=SQL)
async def get_sql_by_id(id: int):
    return await sql_repo.find_sql(id)

@router.post("/test")
async def test_sql(detailed: bool, sql: SQLRequest):
    return await sql_service.test_sql(sql, detailed)

@router.post("")
async def create_sql(sql: SQLRequest, admin=Depends(require_admin)):
    return await sql_repo.create_sql(sql)


@router.put("/{id}")
async def update_sql(id: int, sql: SQLRequest, admin=Depends(require_admin)):
    return await sql_repo.update_sql(id, sql)


@router.delete("/{id}")
async def delete_sql(id: int, admin=Depends(require_admin)):
    return await sql_repo.delete_sql(id)
