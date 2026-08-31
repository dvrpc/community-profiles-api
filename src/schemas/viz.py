from datetime import datetime
from typing import Optional

from pydantic import BaseModel, Field


class VizBase(BaseModel):
    file: str = Field(..., min_length=1, description="Visualization JSON")
    sort_weight: int = Field(None, description="Sort weight")
    last_edited_by: str = Field(
        None, description="User who last edited the viz")


class VizCreate(VizBase):
    topic_id: int = Field(..., description="Foreign key to topic table")


class VizUpdate(BaseModel):
    file: Optional[str] = Field(None, min_length=1,
                                description="Visualization JSON")
    sort_weight: Optional[int] = Field(None, description="Sort weight")
    last_edited_by: Optional[str] = Field(
        None, description="User who last edited the viz")


class Viz(VizBase):
    id: int = Field(..., description="Primary key of the visualization")
    created_at: datetime = Field(None, description="Timestamp of creation")
    updated_at: datetime = Field(
        None, description="Timestamp of the last update")
