from repository.utils import fetch_many, execute_update
from schemas.variable import VariableRequest
import logging

log = logging.getLogger(__name__)


async def find_all_variables():
    log.info(f"Fetching all variables")
    query = "SELECT * FROM variable;"
    return await fetch_many(query)

async def find_variables_by_data_source(data_source):
    log.info(f"Fetching all variables")
    query = "SELECT * FROM variable where data_source = %s;"
    return await fetch_many(query, (data_source, ))

async def find_non_aggregateable_variables():
    log.info(f"Fetching non-aggregateable variables")
    query = "SELECT * FROM variable where aggregateable = FALSE;"
    return await fetch_many(query)

async def create(variable: VariableRequest):
    query = """
        INSERT INTO variable (name, category, data_source, geo_level, acs_variable, gis_table, resource_ids, data_year, catalog_table, description, acs_concept, aggregateable)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING id, name, category, data_source, geo_level, acs_variable, gis_table, resource_ids, data_year, catalog_table, description, acs_concept, aggregateable;
    """
    return await execute_update(query, (variable.name, 
                                  variable.category,
                                  variable.data_source, 
                                  variable.geo_level, 
                                  variable.acs_variable, 
                                  variable.gis_table, 
                                  variable.resource_ids,
                                  variable.data_year,
                                  variable.catalog_table,
                                  variable.description,
                                  variable.acs_concept,
                                  variable.aggregateable
                                  ))


async def update(id, variable: VariableRequest):
    query = """
        UPDATE variable
        SET name = %s, category = %s, data_source = %s, geo_level = %s, acs_variable = %s, gis_table = %s, 
        resource_ids = %s, data_year = %s, catalog_table = %s, description = %s, acs_concept = %s, aggregateable = %s
        WHERE id = %s
        RETURNING id, name, category, data_source, geo_level, acs_variable, gis_table, resource_ids, data_year, catalog_table, description, acs_concept, aggregateable;
    """
    return await execute_update(query, (variable.name, 
                                  variable.category,
                                  variable.data_source, 
                                  variable.geo_level, 
                                  variable.acs_variable, 
                                  variable.gis_table, 
                                  variable.resource_ids,
                                  variable.data_year,
                                  variable.catalog_table,
                                  variable.description,
                                  variable.acs_concept, 
                                  variable.aggregateable,
                                  id))


async def set_variable_update_time(names: list[str]):
    if not names:
        return 0
    query = """
        UPDATE variable
        SET last_updated = NOW()
        WHERE name = ANY(%s)
        RETURNING name;
    """
    return await execute_update(query, (names,))


async def delete(id):
    query = """
        DELETE FROM variable
        WHERE id = %s
        RETURNING name;
    """
    return await execute_update(query, (id,))
