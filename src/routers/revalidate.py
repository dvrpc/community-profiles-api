from fastapi import APIRouter

from services.revalidate import revalidate_frontend

router = APIRouter(
    prefix="/content",
)

@router.post('/revalidate/{geo_level}')
async def revalidate(geo_level: str):
    revalidate_frontend(geo_level)
