from pydantic import BaseModel, Field, model_validator
from typing import Optional

from datetime import datetime




class VariableRequest(BaseModel):
    name: Optional[str] = Field(..., description="")
    data_source : Optional[str] = Field(..., description="")
    acs_variable: Optional[str] = Field(..., description="")
    data_year: Optional[int] = Field(..., description="")
    description: Optional[str] = Field(..., description="")
    concept: Optional[str] = Field(..., description="")
    aggregateable: Optional[bool] = Field(..., description="")
    geo_levels: Optional[list[str]] = Field(default_factory=list, description="List of geographic levels this variable applies to")
    last_updated: Optional[datetime] = Field(default=None, description="Timestamp of the last update")

class Variable(VariableRequest):
    id: int = Field(..., description="Primary key of the variable")
