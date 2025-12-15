from pydantic import BaseModel, Field, model_validator
from typing import Optional


class ContentRequest(BaseModel):
    user: str = Field(..., min_length=1,
                      description="Name of user updating content")
    text: str = Field(..., min_length=1,
                      description="Updated content text")
