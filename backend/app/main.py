"""
Campaign Investigation Tracker API
Main FastAPI application entry point.
"""
from fastapi import FastAPI, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from app.routers import campaigns

# Initialize FastAPI app
app = FastAPI(
    title="Campaign Investigation Tracker API",
    description="Backend for investigating campaign performance issues and anomalies",
    version="0.1.0",
)

# CORS middleware - allow all origins for workshop simplicity
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allow all origins
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


@app.exception_handler(RuntimeError)
async def runtime_error_handler(request: Request, exc: RuntimeError):
    """Return a clear JSON error when the database isn't configured yet."""
    return JSONResponse(
        status_code=503,
        content={"detail": str(exc)},
    )


# Register routers
app.include_router(campaigns.router)


@app.get("/health")
def health_check():
    """
    Health check endpoint.
    Returns service status - useful for monitoring and load balancers.
    """
    return {
        "status": "healthy",
        "service": "campaign-investigation-tracker",
    }


@app.get("/")
def root():
    """
    Root endpoint - returns API info.
    """
    return {
        "message": "Campaign Investigation Tracker API",
        "version": "0.1.0",
        "docs": "/docs",
    }
