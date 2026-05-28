from fastapi import APIRouter
import services.acs as acs_service


router = APIRouter(
    prefix="/acs",
)


@router.get("/{data_year}/{acs_variable}")
async def get_acs_variable_metadata(data_year: str, acs_variable: str):
    return acs_service.fetch_acs_variable_metadata(acs_variable, data_year)

