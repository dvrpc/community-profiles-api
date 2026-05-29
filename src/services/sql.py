
from fastapi import HTTPException

from data_builder.engine import get_gis_engine
from schemas.sql import SQLRequest
from sqlalchemy import text, exc
import logging

log = logging.getLogger(__name__)

async def test_sql(sql_req : SQLRequest, detailed: bool):
    if sql_req.data_source == 'ckan':
        return await test_ckan_sql(sql_req.body)
    else:
        return await test_gis_sql(sql_req.body, detailed)

async def test_ckan_sql(body):
    pass

 
async def test_gis_sql(body: str, detailed: bool):
    engine = get_gis_engine()
    if not detailed:
        body = "EXPLAIN " + body
    sql = text(body)
    try:
        with engine.connect() as connection:
            result = connection.execute(sql)
            rows = [dict(row._mapping) for row in result]
    except exc.SQLAlchemyError as e:
        log.error(f"Execution failed: {e}")
        raise HTTPException(status_code=400, detail=f"SQL execution failed: {e}")
 
    log.info("SQL Test executed successfully")
    if detailed:
        log.info(f"Detailed results: {rows}")
        return rows
    return {"message": "SQL executed successfully"}
 

        
