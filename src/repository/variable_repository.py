from repository.utils import fetch_many, fetch_one, execute_update
from schemas.variable import VariableCreate, VariableUpdate
import logging

log = logging.getLogger(__name__)


async def find_variable_by_name(name: str):
    query = "SELECT * FROM variable WHERE name = %s;"
    return await fetch_one(query, (name,))


async def find_all_variables():
    query = "SELECT * FROM variable;"
    return await fetch_many(query)


async def find_variables_by_data_source(data_source):
    query = "SELECT * FROM variable where data_source = %s;"
    return await fetch_many(query, (data_source, ))


async def find_non_aggregateable_variables():
    query = "SELECT * FROM variable where aggregateable = FALSE;"
    return await fetch_many(query)


async def get_stale_variables():
    query = """
        SELECT v.id
        FROM variable v
        WHERE NOT EXISTS (
            SELECT 1 
            FROM data d
            WHERE d.variable_id = v.id
        );
    """
    return await fetch_many(query)


async def create(variable: VariableCreate):
    query = """
        INSERT INTO variable (name, data_source, acs_variable, description, concept, aggregateable)
        VALUES (%s, %s, %s, %s, %s, %s)
        RETURNING id, name, data_source, acs_variable, description, concept, aggregateable;
    """
    return await execute_update(query, (variable.name,
                                        variable.data_source,
                                        variable.acs_variable,
                                        variable.description,
                                        variable.concept,
                                        variable.aggregateable
                                        ))


async def update(id, variable: VariableUpdate):
    query = """
        UPDATE variable
        SET name = %s, data_source = %s, acs_variable = %s, description = %s, concept = %s, aggregateable = %s
        WHERE id = %s
        RETURNING id, name, data_source, acs_variable, description, concept, aggregateable;
    """
    return await execute_update(query, (variable.name,
                                        variable.data_source,
                                        variable.acs_variable,
                                        variable.description,
                                        variable.concept,
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


async def set_variable_update_time_by_ids(variable_ids: list[int]):
    if not variable_ids:
        return 0
    query = """
        UPDATE variable
        SET last_updated = NOW()
        WHERE id = ANY(%s)
        RETURNING id;
    """
    return await execute_update(query, (variable_ids,))


async def delete(id):
    query = """
        DELETE FROM variable
        WHERE id = %s
        RETURNING id;
    """
    return await execute_update(query, (id,))
