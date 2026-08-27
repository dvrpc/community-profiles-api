from typing import List

from fastapi import APIRouter, Depends, HTTPException, status

from schemas.link import Link, LinkCreate, LinkUpdate
from services.auth import require_admin
import repository.link_repository as link_repo


router = APIRouter(prefix="/link")


@router.get("", response_model=List[Link])
async def get_links():
    return await link_repo.find_all()


@router.post("", response_model=Link, status_code=status.HTTP_201_CREATED)
async def create_link(link: LinkCreate, admin=Depends(require_admin)):
    return await link_repo.create(link)


@router.patch("/{id}", response_model=Link)
async def update_link(id: int, link: LinkUpdate, admin=Depends(require_admin)):
    result = await link_repo.update(id, link)
    if not result:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Link not found")
    return result


@router.delete("/{id}")
async def delete_link(id: int, admin=Depends(require_admin)):
    result = await link_repo.delete(id)
    if not result:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail="Link not found")
    return result