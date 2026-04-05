"""
Campaigns router — campaign list endpoint.

Additional endpoints (campaign detail, health snapshots, investigations)
will be added during the workshop.
"""
from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.models import Campaign
from app.schemas import CampaignOut

router = APIRouter(prefix="/campaigns", tags=["campaigns"])


@router.get("", response_model=List[CampaignOut])
def list_campaigns(db: Session = Depends(get_db)):
    """
    Get all campaigns.
    Returns a list of all campaigns in the system.
    """
    campaigns = db.query(Campaign).all()
    return campaigns
