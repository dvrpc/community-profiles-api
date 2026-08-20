from dataclasses import dataclass, field
from datetime import datetime
import asyncio
from fastapi import HTTPException

from services import acs, data_builder, variable as variable_service
from services.revalidate import revalidate_all
import repository.app_metadata_repository as app_settings_repo
from schemas.app_metadata import AppMetadataCreate, AppMetadataUpdate
import logging

log = logging.getLogger(__name__)


@dataclass
class BuildState:
    is_building: bool = False
    category: str | None = None
    started_at: datetime | None = None
    finished_at: datetime | None = None


state = BuildState()


async def _resolve_acs_year() -> int:
    latest_year = None
    try:
        latest_year = await asyncio.to_thread(acs.get_latest_acs_year)
    except Exception as e:
        log.warning("Failed to query latest ACS year from Census API: %s", e)

    if latest_year is None:
        setting = await app_settings_repo.find_by_key("acs_year")
        if setting is None:
            raise RuntimeError(
                "No ACS year available: Census API failed and no acs_year setting exists"
            )
        return setting["value"]

    setting = await app_settings_repo.find_by_key("acs_year")
    if setting is None:
        await app_settings_repo.create(
            "acs_year",
            AppMetadataCreate(
                value=latest_year,
                description="Latest ACS 5-year estimate year",
            ),
        )
        return latest_year

    stored_year = setting["value"]
    if latest_year > stored_year:
        await app_settings_repo.update(
            "acs_year",
            AppMetadataUpdate(
                value=latest_year,
                description="Latest ACS 5-year estimate year",
            ),
        )
        return latest_year

    return stored_year


async def _write_build_timestamp(key: str):
    now = datetime.now().isoformat()
    setting = await app_settings_repo.find_by_key(key)
    if setting:
        await app_settings_repo.update(
            key, AppMetadataUpdate(
                value=now, description=f"Last successful {key.replace('_last_updated', '').replace('_', ' ')} build timestamp")
        )
    else:
        await app_settings_repo.create(
            key, AppMetadataCreate(
                value=now, description=f"Last successful {key.replace('_last_updated', '').replace('_', ' ')} build timestamp")
        )


async def run_build(
    category: str,
    variables: dict[str, str] | None = None,
    acs_year: int | None = None,
):
    if state.is_building:
        raise HTTPException(
            status_code=409, detail="Build already in progress")

    state.is_building = True
    state.category = category
    state.started_at = datetime.now()

    try:
        if category in {"acs", "all"} and acs_year is None:
            acs_year = await _resolve_acs_year()

        if category == "acs":
            await data_builder.build_acs(variables or None, acs_year)
        elif category == "gis":
            await data_builder.build_gis()
        elif category == "ckan":
            await data_builder.build_ckan()
        elif category == "all":
            await data_builder.build_all(acs_year)

        await data_builder.build_regional()
        # await data_builder.recalibrate_variables()
        await variable_service.delete_stale_variables()
        revalidate_all()

        if category in {"acs", "all"}:
            await _write_build_timestamp("acs_last_updated")
        if category in {"gis", "all"}:
            await _write_build_timestamp("gis_last_updated")
        if category in {"ckan", "all"}:
            await _write_build_timestamp("ckan_last_updated")
    except Exception:
        raise
    finally:
        state.is_building = False
        state.finished_at = datetime.now()
