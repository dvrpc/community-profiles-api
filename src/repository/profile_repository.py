from fastapi_cache.decorator import cache
import logging

from repository.utils import fetch_many, fetch_one

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
async def find_region():
    log.info("Fetching regional profile")
    query = "SELECT * FROM region"
    return fetch_one(query)

async def find_variable_names(geo_level):
    query = """
        select column_name
        from information_schema.columns
        where table_name = %s
    """
    return fetch_many(query, (geo_level,))
    
