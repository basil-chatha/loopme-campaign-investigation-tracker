"""
Database configuration and session management.
Connects to Supabase PostgreSQL using SQLAlchemy.

The engine and session are created lazily so the app can still start
(and serve /health) even when DATABASE_URL is not yet configured.
"""
import os
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Read database URL from environment
DATABASE_URL = os.getenv("DATABASE_URL")

# Engine and session factory — created lazily on first DB access.
# This lets the app boot (health endpoint, docs) even without a database.
_engine = None
_SessionLocal = None


def _init_db():
    """Create the engine and session factory on first use."""
    global _engine, _SessionLocal
    if _engine is not None:
        return

    if not DATABASE_URL:
        raise RuntimeError(
            "DATABASE_URL environment variable is not set. "
            "Copy .env.example to .env and add your Supabase connection string."
        )

    _engine = create_engine(
        DATABASE_URL,
        pool_pre_ping=True,
        echo=False,  # Set to True for SQL debugging
    )
    _SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=_engine)


def get_db():
    """
    FastAPI dependency that yields a database session.
    Usage: def my_route(db: Session = Depends(get_db))
    """
    _init_db()
    db = _SessionLocal()
    try:
        yield db
    finally:
        db.close()
