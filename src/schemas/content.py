from pydantic import BaseModel, Field, model_validator
from typing import Optional


class ContentBase(BaseModel):
    file: str = Field(..., min_length=1,
                      description="Updated content ")
    last_edited_by: Optional[str] = Field(None, description="User who last edited the content")


class ContentCreate(ContentBase):
    pass


class ContentUpdate(ContentBase):
    pass

