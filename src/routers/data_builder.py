from fastapi import APIRouter, Depends
from services.auth import require_admin
from services.revalidate import revalidate_all
import services.data_builder as data_builder

router = APIRouter(
    prefix="/data_builder",
)

#todo: require admin

@router.post("/acs")
async def build_acs(
    variables: dict[str, str]
):
    return await data_builder.build_acs(variables)

@router.post("/gis")
async def build_gis():
    return await data_builder.build_gis()

@router.post("/catalog")
async def build_catalog():
    return await data_builder.build_catalog()

@router.post("/all")
async def build_all():
    return await data_builder.build_all()