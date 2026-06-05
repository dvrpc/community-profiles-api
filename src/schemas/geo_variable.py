from pydantic import BaseModel, Field, model_validator
from typing import Literal, Optional

from datetime import datetime





class GeoVariableRequest(BaseModel):
    variable_id: int = Field(..., description="Foreign key to variable")
    geo_level: Literal['region', 'county', 'municipality'] = Field(..., description="Geographical level this variable applies to")

class GeoVariable(GeoVariableRequest):
    id: int = Field(..., description="Primary key of the variable")
