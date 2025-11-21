from fastapi import APIRouter, Depends
import repository.profile_repository as profile_repo
import repository.content_repository as content_repo
import repository.content_history_repository as content_history_repo
import repository.tree_repository as tree_repo
import services.tree as tree_service
import services.revalidate as revalidation_service
from services.auth import require_admin


router = APIRouter(
    prefix="/tree",
)



@router.put('/subcategory')
async def update_subcategory(id: int, name: str, admin=Depends(require_admin)):
    res = await tree_repo.update_subcategory(id, name)
    revalidation_service.revalidate_all()
    return res

@router.put('/topic')
async def update_topic(id: str, name: str, admin=Depends(require_admin)):
    res = await tree_repo.update_topic(id, name)
    revalidation_service.revalidate_all()
    return res

@router.post('/subcategory')
async def create_subcategory(category_id: int, name: str, admin=Depends(require_admin)):
    res = await tree_service.create_subcategory(category_id, name)
    return res

@router.post('/topic')
async def create_topic(subcategory_id, name, admin=Depends(require_admin)):
    res = await tree_service.create_topic(subcategory_id, name)
    return res