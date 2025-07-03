__all__ = ["create_app"]

from fastapi import FastAPI

from .api.v1.health import router as health_router


def create_app() -> FastAPI:
    """Application factory so tests & ASGI servers share the same code path."""
    app = FastAPI(title="FastAPI Micro-service Template", version="0.1.0")

    # Mount versioned API
    app.include_router(health_router, prefix="/api/v1")

    return app


# Used by Uvicorn & Docker CMD
app = create_app()
