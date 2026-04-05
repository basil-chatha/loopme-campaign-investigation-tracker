"""
Pydantic response schemas for API responses.

Only the campaign list schema is defined here — additional schemas
for health snapshots, investigations, and AI runs will be built
during the workshop as new endpoints are added.
"""
from datetime import datetime
from typing import Optional
from pydantic import BaseModel, ConfigDict


class CampaignOut(BaseModel):
    """Response schema for a campaign."""
    model_config = ConfigDict(from_attributes=True)

    id: str
    campaign_code: str
    name: str
    advertiser: str
    status: str
    objective: str
    channel: Optional[str] = None
    start_date: datetime
    end_date: datetime
    budget_usd: float
    owner_name: Optional[str] = None
    region: Optional[str] = None
    created_at: datetime
    updated_at: datetime
