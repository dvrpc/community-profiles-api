from fastapi import APIRouter, Depends
from schemas.subcategory import SubcategoryCreate, SubcategoryUpdate
import repository.subcategory_repository as subcategory_repo
import services.subcategory as subcategory_service
from services.auth import require_admin


router = APIRouter()


@router.put('/subcategory/{id}')
async def update_subcategory(
    id: int,
    subcategory: SubcategoryUpdate,
    admin=Depends(require_admin),
):
    res = await subcategory_service.update_subcategory(id, subcategory)
    return res


@router.post('/subcategory')
async def create_subcategory(
    subcategory: SubcategoryCreate,
    admin=Depends(require_admin),
):
    res = await subcategory_service.create_subcategory(subcategory)
    return res


@router.delete('/subcategory/{id}')
async def delete_subcategory(id: int, admin=Depends(require_admin)):
    res = await subcategory_repo.delete(id)
    return res
