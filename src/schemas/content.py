from pydantic import BaseModel, Field, model_validator
from typing import Optional


class ContentBase(BaseModel):
    file: str = Field(..., min_length=1,
                      description="Updated content ")
    last_edited_by: str = Field(
        None, description="User who last edited the content")
    topic_id: Optional[int] = Field(
        None, description="Foreign key to topic table")
    category_id: Optional[int] = Field(
        None, description="Foreign key to category table")


class ContentCreate(ContentBase):
    pass


class ContentUpdate(ContentBase):
    pass
