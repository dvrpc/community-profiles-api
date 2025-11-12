from pydantic import BaseModel, Field, model_validator
from typing import Optional

class SourceRequest(BaseModel):
    name: str = Field(..., min_length=1, description="Name of the source")
    year_from: Optional[int] = Field(None, gt=1900, description="Starting year (optional, >1900)")
    year_to: int = Field(..., gt=1900, description="Ending year (>1900)")
    citation: str = Field(..., min_length=1, description="Full written citation")

    @model_validator(mode="after")
    def check_years(cls, values):
        if values.year_from is not None and values.year_to <= values.year_from:
            raise ValueError("year_to must be greater than year_from")
        return values

class Source(SourceRequest):
    id: int = Field(..., description="Primary key of the source")
