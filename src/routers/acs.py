from fastapi import APIRouter, HTTPException
import services.acs as acs_service


router = APIRouter(
    prefix="/acs",
)


@router.get("/latest-year")
async def get_latest_acs_year():
    try:
        return {"acs_year": acs_service.get_latest_acs_year()}
    except RuntimeError as error:
        raise HTTPException(status_code=503, detail=str(error)) from error


@router.get("/{data_year}/{acs_variable}")
async def get_acs_variable_metadata(data_year: str, acs_variable: str):
    return acs_service.fetch_acs_variable_metadata(acs_variable, data_year)
