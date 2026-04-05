"""
Pytest configuration file.
Shared fixtures and settings for all tests.
"""
import sys
from pathlib import Path

# Add app directory to path so imports work during tests
sys.path.insert(0, str(Path(__file__).parent))
