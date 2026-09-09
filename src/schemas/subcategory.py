from typing import Optional

from pydantic import BaseModel, Field


class SubcategoryBase(BaseModel):
    category_id: int = Field(..., description="Foreign key to the category")
    geo_level: str = Field(..., min_length=1, description="Geography level")
    url_id: str = Field(..., min_length=1, description="URL-safe subcategory identifier")
    label: str = Field(..., min_length=1, description="Display label for the subcategory")


class SubcategoryCreate(SubcategoryBase):
    pass


class SubcategoryUpdate(BaseModel):
    url_id: Optional[str] = Field(None, min_length=1, description="URL-safe subcategory identifier")
    label: Optional[str] = Field(None, min_length=1, description="Display label for the subcategory")
    sort_weight: Optional[int] = Field(None, description="Sort weight")


