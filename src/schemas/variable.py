from pydantic import BaseModel, Field, model_validator
from typing import Optional





class VariableRequest(BaseModel):
    name: str = Field(..., description="")
    category: str = Field(..., description="")
    data_source : str = Field(..., description=""),
    geo_level: str = Field(..., description=""),
    acs_variable: str = Field(..., description=""),
    gis_table: str = Field(..., description=""),
    resource_ids: str = Field(..., description=""),
    data_year: str = Field(..., description=""),
    catalog_table: str = Field(..., description=""),
    description: str = Field(..., description=""),
    acs_concept: str = Field(..., description="")

class Variable(VariableRequest):
    id: int = Field(..., description="Primary key of the variable")
