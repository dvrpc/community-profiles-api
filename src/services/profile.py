import repository.profile_repository as profile_repository
import repository.data_repository as data_repository


async def build_municipality_profile(geoid: str):
    municipality_data = await data_repository.find_by_geoid()
    print(municipality_data)

async def build_county_profile(geoid: str):
    county_data = await data_repository.find_by_geoid(geoid)


async def build_region_profile():
    region_data = await data_repository.find_region()
