from fastapi import APIRouter, Depends

import repository.subcategory_repository as subcategory_repo
import repository.topic_repository as topic_repo

import services.tree as tree_service
from services.auth import require_admin


router = APIRouter(
    prefix="/tree",
)



@router.put('/subcategory')
async def update_subcategory(id: int, name: str, admin=Depends(require_admin)):
    res = await tree_service.update_subcategory(id, name)
    return res

@router.put('/topic')
async def update_topic(id: str, name: str, admin=Depends(require_admin)):
    res = await tree_service.update_topic(id, name)
    return res

@router.post('/subcategory')
async def create_subcategory(category_id: int, name: str, admin=Depends(require_admin)):
    res = await tree_service.create_subcategory(category_id, name)
    return res

@router.post('/topic')
async def create_topic(subcategory_id, name, admin=Depends(require_admin)):
    res = await tree_service.create_topic(subcategory_id, name)
    return res

@router.delete('/topic/{id}')
async def delete_topic(id: int, admin=Depends(require_admin)):
    res = await topic_repo.delete(id)
    return res

@router.delete('/subcategory/{id}')
async def delete_subcategory(id: int, admin=Depends(require_admin)):
    res = await subcategory_repo.delete(id)
    return res