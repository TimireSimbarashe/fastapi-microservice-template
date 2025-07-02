FROM python:3.12-slim

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

COPY pyproject.toml poetry.lock ./
RUN pip install --no-cache-dir poetry && poetry config installer.parallel false \
 && poetry install --no-root --no-interaction --no-ansi

COPY app/ app/
EXPOSE 8000
CMD ["poetry", "run", "uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
