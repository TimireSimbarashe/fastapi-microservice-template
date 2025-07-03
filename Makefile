## ─────────────────────────────────────────────────────────────
## High-level targets
## ─────────────────────────────────────────────────────────────

.PHONY: ci dev lint test fmt install

ci: install lint fmt test            # local mirror of GitHub CI

dev: install                         # hot-reload server
	@echo "⬣ Starting Uvicorn with --reload"
	poetry run uvicorn fastapi_microservice_template.main:app --reload --port 8000

## ─────────────────────────────────────────────────────────────
## Sub-targets
## ─────────────────────────────────────────────────────────────

install: .venv                       # run once unless lock/pyproject change

.venv: pyproject.toml poetry.lock
	@echo "⬣ Installing (or syncing) deps via Poetry"
	poetry install
	@poetry run python -c "import pathlib,sys; pathlib.Path('.venv').touch()"

lint:
	@echo "⬣ Ruff lint"
	poetry run ruff check .

fmt:
	@echo "⬣ Black format check"
	poetry run black --check .

test:
	@echo "⬣ Pytest"
	poetry run pytest -q
