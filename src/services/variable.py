import repository.geo_variable_repository as geo_variable_repo

async def create_geo_variable(variable_id: int, aggregateable: bool):
    geo_levels = ["region", "county", "municipality"] if aggregateable else ["municipality", "region"]
    for geo_level in geo_levels:
        await geo_variable_repo.create(variable_id, geo_level)