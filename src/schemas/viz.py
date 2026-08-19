from pydantic import BaseModel, Field


class VizRequest(BaseModel):
    file: str = Field(..., min_length=1, description="Visualization JSON")


class Viz(VizRequest):
    id: int = Field(..., description="Primary key of the visualization")
