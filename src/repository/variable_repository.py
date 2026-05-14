from repository.utils import fetch_many, execute_update
from schemas.variable import VariableRequest
import logging

log = logging.getLogger(__name__)


async def find_all_variables():
    log.info(f"Fetching all variables")
    query = "SELECT name FROM variable;"
    return fetch_many(query)


async def create(variable: VariableRequest):
    query = """
        INSERT INTO variable (name, category, data_source, geo_level, acs_variable, gis_table, resource_ids, data_year, catalog_table, description, acs_concept)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
        RETURNING id, name, category, data_source, geo_level, acs_variable, gis_table, resource_ids, data_year, catalog_table, description, acs_concept;
    """
    return execute_update(query, (variable.name, 
                                  variable.category,
                                  variable.data_source, 
                                  variable.geo_level, 
                                  variable.acs_variable, 
                                  variable.gis_table, 
                                  variable.resource_ids,
                                  variable.data_year,
                                  variable.catalog_table,
                                  variable.description,
                                  variable.acs_concept
                                  ))


async def update(id, variable: VariableRequest):
    query = """
        UPDATE variable
        SET name = %s, category = %s, data_source = %s, geo_level = %s, acs_variable = %s, gis_table = %s, 
        resource_ids = %s, data_year = %s, catalog_table = %s, description = %s, acs_concept = %s
        WHERE id = %s
        RETURNING id, name, category, data_source, geo_level, acs_variable, gis_table, resource_ids, data_year, catalog_table, description, acs_concept;
    """
    return execute_update(query, (variable.name, 
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
                                  id))


async def delete(id):
    query = """
        DELETE FROM variable
        WHERE id = %s
        RETURNING id;
    """
    return execute_update(query, (id,))
