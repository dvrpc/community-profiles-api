from enum import Enum
from typing import Optional

from pydantic import BaseModel, Field, model_validator
from schemas.link import LinkType


class TopicBase(BaseModel):
    subcategory_id: int = Field(...,
                                description="Foreign key to the subcategory")
    url_id: str = Field(..., min_length=1,
                        description="URL-safe topic identifier")
    label: str = Field(..., min_length=1,
                       description="Display label for the topic")
    is_visible: bool = Field(
        False, description="Whether the topic is hidden from the UI")


class TopicCreate(TopicBase):
    pass


class TopicUpdate(BaseModel):
    url_id: Optional[str] = Field(
        None, min_length=1, description="URL-safe topic identifier")
    label: Optional[str] = Field(
        None, min_length=1, description="Display label for the topic")
    sort_weight: Optional[int] = Field(None, description="Sort weight")
    is_visible: Optional[bool] = Field(
        None, description="Whether the topic is hidden from the UI")


class LinkMutation(str, Enum):
    none = "none"
    update = "update"
    create = "create"
    delete = "delete"


class TopicLinkUpdate(BaseModel):
    id: Optional[int] = Field(None, description="Existing link ID")
    link: str = Field(..., min_length=1, description="URL for the link")
    type: LinkType
    mutation: LinkMutation

    @model_validator(mode="after")
    def validate_id_for_mutation(self):
        if self.mutation in (LinkMutation.update, LinkMutation.delete,
                             LinkMutation.none) and self.id is None:
            raise ValueError(f"id is required for {self.mutation.value} mutation")
        if self.mutation == LinkMutation.create and self.id is not None:
            raise ValueError("id must be omitted for create mutation")
        return self


class TopicPropertiesUpdate(TopicUpdate):
    links: Optional[list[TopicLinkUpdate]] = Field(
        None, description="Links and requested mutations for this topic")
    source_ids: Optional[list[int]] = Field(
        None, description="List of content source IDs")
    product_ids: Optional[list[str]] = Field(
        None, description="List of related product IDs")


class Topic(TopicBase):
    id: int = Field(..., description="Primary key of the source")
