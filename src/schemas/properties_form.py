from pydantic import BaseModel, Field, model_validator
from typing import Optional, List


class PropertiesFormRequest(BaseModel):
    content_sources: Optional[List[int]] = Field(..., description="Content sources")
    viz_sources: Optional[List[int]] = Field(..., description="Viz sources")
    products: Optional[List[int]] = Field(..., description="Related products")
    is_visible: bool = Field(..., min_length=1, description="Is topic visible")
    catalog_link: Optional[str] = Field(..., min_length=1,
                          description="Data catalog link")
    census_link: Optional[str] = Field(..., min_length=1,
                          description="Census link")

