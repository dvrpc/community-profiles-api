from pydantic import BaseModel, Field, model_validator
from typing import Optional





class VariableRequest(BaseModel):
    name: Optional[str] = Field(..., description="")
    category: Optional[str] = Field(..., description="")
    data_source : Optional[str] = Field(..., description=""),
    geo_level: Optional[str] = Field(..., description=""),
    acs_variable: Optional[str] = Field(..., description=""),
    gis_table: Optional[str] = Field(..., description=""),
    resource_ids: Optional[str] = Field(..., description=""),
    data_year: Optional[int] = Field(..., description=""),
    catalog_table: Optional[str] = Field(..., description=""),
    description: Optional[str] = Field(..., description=""),
    acs_concept: Optional[str] = Field(..., description="")
    aggregateable: Optional[bool] = Field(..., description="")

class Variable(VariableRequest):
    id: int = Field(..., description="Primary key of the variable")
