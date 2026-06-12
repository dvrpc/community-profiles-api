from pydantic import BaseModel, Field
from typing import Optional


class GeographyRequest(BaseModel):
    name: str = Field(..., description="Name of the geography")
    county_id: Optional[int] = Field(None, description="Foreign key to county")
    state: str = Field(..., description="State abbreviation or name")
    buffer_bbox: Optional[str] = Field(
        None, description="Bounding box coordinates in text format")


class Geography(GeographyRequest):
    geoid: str = Field(..., description="Primary key of the geography record")

    class Config:
        from_attributes = True
