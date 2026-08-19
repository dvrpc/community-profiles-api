from typing import Optional, Union
from fastapi import APIRouter, Depends
from schemas.topic import TopicRequest
import repository.subcategory_repository as subcategory_repo
import repository.topic_repository as topic_repo

import services.tree as tree_service
from services.auth import require_admin


router = APIRouter(
    prefix="/tree",
)


@router.put('/subcategory/{id}')
async def update_subcategory(id, subcategory: dict, admin=Depends(require_admin)):
    res = await tree_service.update_subcategory(id, subcategory)
    return res


@router.put('/topic/{id}')
async def update_topic(id: int, topic: dict, admin=Depends(require_admin)):
    res = await tree_service.update_topic(id, topic)
    return res


@router.post('/subcategory')
async def create_subcategory(category_id: int, geo_level: str, label: str, url_id: str, admin=Depends(require_admin)):
    res = await tree_service.create_subcategory(category_id, geo_level, label, url_id)
    return res


@router.post('/topic')
async def create_topic(subcategory_id: int, label: str, url_id: str, admin=Depends(require_admin)):
    res = await tree_service.create_topic(subcategory_id, label, url_id)
    return res


@router.delete('/topic/{id}')
async def delete_topic(id: int, admin=Depends(require_admin)):
    res = await topic_repo.delete(id)
    return res


@router.delete('/subcategory/{id}')
async def delete_subcategory(id: int, admin=Depends(require_admin)):
    res = await subcategory_repo.delete(id)
    return res

@router.get('/{geo_level}')
async def get_template_tree(geo_level: str):
    tree = await tree_service.build_template_tree(geo_level)
    return tree
