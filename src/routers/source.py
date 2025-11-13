from fastapi import APIRouter, status
from typing import List
from schemas.source import Source, SourceRequest
import repository.source_repository as source_repo

router = APIRouter(
    prefix="/source",
)


@router.get("", response_model=List[Source])
async def get_sources():
    sources = await source_repo.find_all_sources()
    return sources


@router.post("", status_code=status.HTTP_201_CREATED)
async def create_source(source: SourceRequest):
    res = await source_repo.create(source)
    return res


@router.put("/{id}")
async def update_source(id: int, source: SourceRequest):
    res = await source_repo.update(id, source)
    return res


@router.delete("/{id}")
async def update_source(id: int):
    res = await source_repo.delete(id)
    return res
