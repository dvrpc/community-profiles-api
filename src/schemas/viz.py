from typing import Optional

from pydantic import BaseModel, Field


class VizBase(BaseModel):
    file: str = Field(..., min_length=1, description="Visualization JSON")


class VizCreate(VizBase):
    pass


class VizUpdate(BaseModel):
    file: Optional[str] = Field(None, min_length=1, description="Visualization JSON")


class Viz(VizBase):
    id: int = Field(..., description="Primary key of the visualization")


