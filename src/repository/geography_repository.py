from repository.utils import fetch_one
import logging


log = logging.getLogger(__name__)


async def find_by_geoid(geoid: int):
    query = "SELECT * FROM geography WHERE geoid = %s;"
    return await fetch_one(query, (geoid,))
