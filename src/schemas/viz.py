from typing import Optional

from pydantic import BaseModel, Field


class VizBase(BaseModel):
    file: str = Field(..., min_length=1, description="Visualization JSON")
    last_edited_by: Optional[str] = Field(
        None, description="User who last edited the viz")


class VizCreate(VizBase):
    pass


class VizUpdate(VizBase):
    pass


class Viz(VizBase):
    id: int = Field(..., description="Primary key of the visualization")
