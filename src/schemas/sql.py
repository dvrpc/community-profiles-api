from pydantic import BaseModel, Field
from typing import Literal, Optional


class SQLBase(BaseModel):
    name: str = Field(..., description="Name of the SQL query")
    data_source: Literal['ckan', 'gis'] = Field(
        ..., description="Source type for this SQL body")
    geo_level: Literal['region', 'county', 'municipality'] = Field(
        ..., description="Geographical level this SQL body applies to")
    body: str = Field(..., min_length=1, description="SQL body for the data source")


class SQLCreate(SQLBase):
    pass


class SQLUpdate(BaseModel):
    name: Optional[str] = Field(None, description="Name of the SQL query")
    data_source: Optional[Literal['ckan', 'gis']] = Field(None, description="Source type for this SQL body")
    geo_level: Optional[Literal['region', 'county', 'municipality']] = Field(None, description="Geographical level this SQL body applies to")
    body: Optional[str] = Field(None, min_length=1, description="SQL body for the data source")


class SQL(SQLBase):
    id: int = Field(..., description="Primary key of the SQL query")


