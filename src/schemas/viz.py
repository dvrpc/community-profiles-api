from pydantic import BaseModel, Field, model_validator
from typing import Optional


class VizRequest(BaseModel):
    user: str = Field(..., min_length=1,
                      description="Name of user updating viz")
    text: str = Field(..., min_length=1,
                      description="Updated viz text")
