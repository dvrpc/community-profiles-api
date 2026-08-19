from fastapi import APIRouter, Depends

import repository.app_metadata_repository as app_settings_repo
from services.auth import require_admin

router = APIRouter(
    prefix="/app-metadata"
)


@router.get("")
async def get_app_metadata(admin=Depends(require_admin)):
    return await app_settings_repo.find_all()
