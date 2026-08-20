from pydantic import BaseModel, Field, model_validator
from typing import Optional


class SourceBase(BaseModel):
    agency: str = Field(..., min_length=1, description="Name of the source")
    dataset: str = Field(..., min_length=1, description="Name of the source")
    year_from: Optional[int] = Field(
        None, gt=1900, description="Starting year (optional, >1900)")
    year_to: int = Field(..., gt=1900, description="Ending year (>1900)")
    citation: str = Field(..., min_length=1,
                          description="Full written citation")

    # @model_validator(mode="after")
    # def check_years(cls, values):
    #     if values.year_from is not None and values.year_to <= values.year_from:
    #         raise ValueError("year_to must be greater than year_from")
    #     return values


class SourceCreate(SourceBase):
    pass


class SourceUpdate(BaseModel):
    agency: Optional[str] = Field(None, min_length=1, description="Name of the source")
    dataset: Optional[str] = Field(None, min_length=1, description="Name of the source")
    year_from: Optional[int] = Field(None, gt=1900, description="Starting year (optional, >1900)")
    year_to: Optional[int] = Field(None, gt=1900, description="Ending year (>1900)")
    citation: Optional[str] = Field(None, min_length=1, description="Full written citation")


class Source(SourceBase):
    id: int = Field(..., description="Primary key of the source")


