"""
SQLAlchemy ORM models for the Campaign Investigation Tracker.

Only the campaign-related models are mapped here — the investigation
workflow models (investigations, investigation_evidence, ai_runs) will
be built during the workshop.
"""
from datetime import datetime
from sqlalchemy import (
    Column, Integer, String, Float, DateTime, Boolean, ForeignKey, Text,
)
from sqlalchemy.orm import declarative_base

Base = declarative_base()


class Campaign(Base):
    """Campaign table — represents a marketing campaign."""
    __tablename__ = "campaigns"

    id = Column(String(50), primary_key=True, index=True)
    campaign_code = Column(String(50), unique=True, index=True)
    name = Column(String(255))
    advertiser = Column(String(255))
    status = Column(String(50))
    objective = Column(String(255))
    channel = Column(String(100))
    start_date = Column(DateTime)
    end_date = Column(DateTime)
    budget_usd = Column(Float)
    owner_name = Column(String(255))
    region = Column(String(100))
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class CampaignHealth(Base):
    """Campaign health snapshots — time-series performance data."""
    __tablename__ = "campaign_health"

    id = Column(String(50), primary_key=True, index=True)
    campaign_id = Column(String(50), ForeignKey("campaigns.id"), index=True)
    snapshot_at = Column(DateTime)
    impressions = Column(Integer)
    clicks = Column(Integer)
    ctr = Column(Float)
    viewability = Column(Float)
    completion_rate = Column(Float)
    spend_usd = Column(Float)
    budget_pacing_pct = Column(Float)
    delivery_rate_pct = Column(Float)
    anomaly_flag = Column(Boolean, default=False)
    anomaly_reason = Column(String(255))
    delivery_note = Column(Text)
