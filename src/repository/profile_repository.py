from fastapi_cache.decorator import cache
import logging

from repository.utils import fetch_one

log = logging.getLogger(__name__)


@cache(expire=60)
async def find_county(geoid):
    log.info(f"Fetching county profile: {geoid}")
    query = "SELECT * FROM county WHERE geoid = %s"
    return fetch_one(query, (geoid,))


@cache(expire=60)
async def find_municipality(geoid):
    log.info(f"Fetching municipality profile: {geoid}")
    query = "SELECT * FROM municipality WHERE geoid = %s"
    return fetch_one(query, (geoid,))


@cache(expire=60)
async def find_municipality():
    log.info("Fetching regional profile")
    query = "SELECT * FROM region"
    return fetch_one(query)
