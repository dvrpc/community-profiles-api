from pydantic import BaseModel, Field
from typing import Literal, Optional


class SQLRequest(BaseModel):
    name: str = Field(..., description="Name of the SQL query")
    data_source: Literal['ckan', 'gis'] = Field(
        ..., description="Source type for this SQL body")
    geo_level: Literal['region', 'county', 'municipality'] = Field(
        ..., description="Geographical level this SQL body applies to")
    body: str = Field(..., min_length=1, description="SQL body for the data source")


class SQL(SQLRequest):
    id: int = Field(..., description="Primary key of the SQL query")
