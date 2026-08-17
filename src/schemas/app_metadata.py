from pydantic import BaseModel, Field
from typing import Optional, Any


class AppMetadataRequest(BaseModel):
    value: Any = Field(..., description="JSONB value for the setting")
    description: Optional[str] = Field(
        None, description="Description of the setting")


class AppMetadata(AppMetadataRequest):
    key: str = Field(..., description="Primary key of the setting")
