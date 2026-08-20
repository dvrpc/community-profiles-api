from typing import Optional

from pydantic import BaseModel, Field


class TopicBase(BaseModel):
    subcategory_id: int = Field(..., description="Foreign key to the subcategory")
    url_id: str = Field(..., min_length=1, description="URL-safe topic identifier")
    label: str = Field(..., min_length=1, description="Display label for the topic")
    is_visible: bool = Field(False, description="Whether the topic is hidden from the UI")


class TopicCreate(TopicBase):
    pass


class TopicUpdate(BaseModel):
    url_id: Optional[str] = Field(None, min_length=1, description="URL-safe topic identifier")
    label: Optional[str] = Field(None, min_length=1, description="Display label for the topic")
    sort_weight: Optional[int] = Field(None, description="Sort weight")
    is_visible: Optional[bool] = Field(None, description="Whether the topic is hidden from the UI")


class Topic(TopicBase):
    id: int = Field(..., description="Primary key of the source")


