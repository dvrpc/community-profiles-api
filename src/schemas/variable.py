from pydantic import BaseModel, Field, model_validator
from typing import Optional

from datetime import datetime


class VariableBase(BaseModel):
    name: str = Field(..., description="")
    data_source: str = Field(..., description="")
    acs_variable: Optional[str] = Field(None, description="")
    description: Optional[str] = Field(None, description="")
    concept: str = Field(..., description="")
    aggregateable: bool = Field(..., description="")
    last_updated: Optional[datetime] = Field(
        default=None, description="Timestamp of the last update")


class VariableCreate(VariableBase):
    pass


class VariableUpdate(BaseModel):
    name: Optional[str] = Field(None, description="")
    data_source: Optional[str] = Field(None, description="")
    acs_variable: Optional[str] = Field(None, description="")
    description: Optional[str] = Field(None, description="")
    concept: Optional[str] = Field(None, description="")
    aggregateable: Optional[bool] = Field(None, description="")
    last_updated: Optional[datetime] = Field(None, description="Timestamp of the last update")


class Variable(VariableBase):
    id: int = Field(..., description="Primary key of the variable")


