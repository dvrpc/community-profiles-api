from enum import Enum
from typing import Optional

from pydantic import BaseModel, Field


class LinkType(str, Enum):
    census = "census"
    catalog = "catalog"
    other = "other"


class LinkBase(BaseModel):
    link: str = Field(..., min_length=1, description="URL for the link")
    type: LinkType


class LinkCreate(LinkBase):
    topic_id: int = Field(..., description="Topic that owns the link")


class LinkUpdate(BaseModel):
    link: Optional[str] = Field(None, min_length=1, description="URL for the link")
    type: Optional[LinkType] = None


class Link(LinkBase):
    id: int
    topic_id: int