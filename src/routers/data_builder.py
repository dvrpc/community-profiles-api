from fastapi import APIRouter, Depends
from services.auth import require_admin
from services.revalidate import revalidate_all

router = APIRouter(
    prefix="/data_builder",
)




@router.post("/all")
async def build_all(admin=Depends(require_admin)):
    res = await source_repo.create(source)
    return res

@router.post("/{variable}")
async def build_var(admin=Depends(require_admin)):
    res = await source_repo.create(source)
    return res

@router.post("/category/{category}")
async def build_category(admin=Depends(require_admin)):
    res = await source_repo.create(source)
    return res


