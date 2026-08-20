from pydantic import BaseModel, Field
from typing import Optional


class DataBase(BaseModel):
    variable_id: int = Field(..., description="Foreign key to variable table")
    geoid: str = Field(..., description="Foreign key to geography table")
    value: Optional[float] = Field(None, description="The data value")
    margin_of_error: Optional[float] = Field(
        None, description="Margin of error for the value")


class DataCreate(DataBase):
    pass


class DataUpdate(BaseModel):
    variable_id: Optional[int] = Field(None, description="Foreign key to variable table")
    geoid: Optional[str] = Field(None, description="Foreign key to geography table")
    value: Optional[float] = Field(None, description="The data value")
    margin_of_error: Optional[float] = Field(None, description="Margin of error for the value")


class Data(DataBase):
    id: int = Field(..., description="Primary key of the variable data record")

    class Config:
        from_attributes = True


