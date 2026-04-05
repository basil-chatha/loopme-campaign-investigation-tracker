"""
Tests for health and basic connectivity.
These tests verify the API is structured correctly.
"""
import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)


def test_health_endpoint_returns_200():
    """Test that /health endpoint returns 200 status code."""
    response = client.get("/health")
    assert response.status_code == 200


def test_health_endpoint_returns_correct_json():
    """Test that /health endpoint returns expected JSON structure."""
    response = client.get("/health")
    data = response.json()
    assert data["status"] == "healthy"
    assert data["service"] == "campaign-investigation-tracker"


def test_root_endpoint_returns_200():
    """Test that / endpoint returns 200 status code."""
    response = client.get("/")
    assert response.status_code == 200


def test_root_endpoint_returns_api_info():
    """Test that / endpoint returns API info."""
    response = client.get("/")
    data = response.json()
    assert "message" in data
    assert "version" in data
    assert "docs" in data


def test_campaigns_endpoint_exists():
    """Test that /campaigns endpoint exists and is routable."""
    response = client.get("/campaigns")
    # 200 if database is connected, 503 if DATABASE_URL is not set.
    # Either way, the route exists and FastAPI handled it gracefully.
    assert response.status_code in [200, 503]


def test_docs_endpoint_exists():
    """Test that Swagger UI is available at /docs."""
    response = client.get("/docs")
    assert response.status_code == 200
