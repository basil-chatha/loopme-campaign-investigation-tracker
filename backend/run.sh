#!/bin/bash
# Quick script to run the Campaign Investigation Tracker backend

# Check if .env exists
if [ ! -f .env ]; then
    echo "Error: .env file not found"
    echo "Please copy .env.example to .env and add your Supabase DATABASE_URL"
    exit 1
fi

# Run uvicorn server
echo "Starting Campaign Investigation Tracker API..."
echo "API will be available at http://localhost:8000"
echo "Documentation: http://localhost:8000/docs"
echo ""

uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
