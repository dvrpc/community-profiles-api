from pydantic import BaseModel, Field
from typing import Optional, Any


class AppMetadataBase(BaseModel):
    value: Any = Field(..., description="JSONB value for the setting")
    description: Optional[str] = Field(
        None, description="Description of the setting")


class AppMetadataCreate(AppMetadataBase):
    pass


class AppMetadataUpdate(BaseModel):
    value: Optional[Any] = Field(None, description="JSONB value for the setting")
    description: Optional[str] = Field(None, description="Description of the setting")




