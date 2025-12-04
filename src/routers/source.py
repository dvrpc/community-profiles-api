from fastapi import APIRouter, status, Depends
from typing import List
from schemas.source import Source, SourceRequest
from services.auth import require_admin
from services.revalidate import revalidate_all
import repository.source_repository as source_repo

router = APIRouter(
    prefix="/source",
)


@router.get("", response_model=List[Source])
async def get_sources():
    sources = await source_repo.find_all_sources()
    return sources


@router.post("")
async def create_source(source: SourceRequest, admin=Depends(require_admin)):
    res = await source_repo.create(source)
    return res


@router.put("/{id}")
async def update_source(id: int, source: SourceRequest, admin=Depends(require_admin)):
    res = await source_repo.update(id, source)
    revalidate_all()
    return res


@router.delete("/{id}")
async def update_source(id: int, admin=Depends(require_admin)):
    res = await source_repo.delete(id)
    revalidate_all()
    return res
