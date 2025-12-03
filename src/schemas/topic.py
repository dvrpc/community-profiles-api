from pydantic import BaseModel, Field, model_validator
from typing import Optional


class TopicRequest(BaseModel):
    name: Optional[str] = Field(..., min_length=1,
                                description="Name of the topic")
    label: Optional[str] = Field(..., min_length=1,
                                 description="Label of the topic")
    sort_weight: Optional[int] = Field(..., description="SortWeight")


class Topic(TopicRequest):
    id: int = Field(..., description="Primary key of the source")
