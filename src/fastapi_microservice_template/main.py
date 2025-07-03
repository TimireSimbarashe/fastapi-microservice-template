from fastapi import FastAPI

app = FastAPI(title="FastAPI Micro-service Template")


@app.get("/healthz")
def healthcheck() -> dict[str, str]:
    return {"status": "ok"}
