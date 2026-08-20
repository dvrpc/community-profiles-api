from fastapi import APIRouter, Depends
from schemas.subcategory import SubcategoryCreate, SubcategoryUpdate
from schemas.topic import TopicCreate, TopicUpdate
import repository.subcategory_repository as subcategory_repo
import repository.topic_repository as topic_repo
import repository.category_repository as category_repo
import services.tree as tree_service
from services.auth import require_admin


router = APIRouter(
    prefix="/tree",
)

@router.get('/category')
async def get_categories():
    res = await category_repo.find_all()
    return res

@router.get('/{geo_level}')
async def get_tree(geo_level: str):
    tree = await category_repo.tree(geo_level)
    return tree

@router.put('/subcategory/{id}')
async def update_subcategory(
    id: int,
    subcategory: SubcategoryUpdate,
    admin=Depends(require_admin),
):
    res = await tree_service.update_subcategory(id, subcategory)
    return res


@router.put('/topic/{id}')
async def update_topic(id: int, topic: TopicUpdate, admin=Depends(require_admin)):
    res = await tree_service.update_topic(id, topic)
    return res


@router.post('/subcategory')
async def create_subcategory(
    subcategory: SubcategoryCreate,
    admin=Depends(require_admin),
):
    res = await tree_service.create_subcategory(subcategory)
    return res


@router.post('/topic')
async def create_topic(topic: TopicCreate, admin=Depends(require_admin)):
    res = await tree_service.create_topic(topic)
    return res


@router.delete('/topic/{id}')
async def delete_topic(id: int, admin=Depends(require_admin)):
    res = await topic_repo.delete(id)
    return res


@router.delete('/subcategory/{id}')
async def delete_subcategory(id: int, admin=Depends(require_admin)):
    res = await subcategory_repo.delete(id)
    return res
