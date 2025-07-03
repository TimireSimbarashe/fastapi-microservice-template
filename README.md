# FastAPI Micro-Service Template 🚀

A production-ready, **Poetry-managed**, **Docker-packaged** scaffold for building small, maintainable FastAPI services.
It ships with testing, linting, CI, and typed Python 3.12—from `git clone` to a running container (or a GitHub deploy) in minutes.

[![CI](https://img.shields.io/github/actions/workflow/status/your-org/fastapi-microservice-template/ci.yml?branch=main\&label=CI)](https://github.com/your-org/fastapi-microservice-template/actions)
[![Licence: MIT](https://img.shields.io/badge/licence-MIT-blue)](#licence)

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Project Layout](#project-layout)
3. [Local Tooling](#local-tooling)
4. [Developer Workflows](#developer-workflows)
5. [API Example](#api-example)
6. [Quality Gates](#quality-gates)
7. [CI/CD Pipeline](#cicd-pipeline)
8. [Deployment Recipes](#deployment-recipes)
9. [Versioning & Releases](#versioning--releases)
10. [Contributing](#contributing)
11. [Licence](#licence)

---

## Quick Start

> **Prerequisites**
> – Docker 24 + (Desktop or Engine)
> – Git ₂ +
> – Make (Unix/macOS/Linux) **or** PowerShell alias `pci` on Windows ▼

```bash
# Clone the template
git clone https://github.com/your-org/fastapi-microservice-template.git
cd fastapi-microservice-template

# Spin up container in dev mode (hot-reload)
docker compose up --build
# → http://localhost:8000/docs
```

<details>
<summary>Windows PowerShell (without Make)</summary>

```powershell
# add “pci” alias once to your $PROFILE:
function Invoke-CI {
    poetry install; poetry check --lock
    poetry run ruff check .; poetry run black --check .
    poetry run pytest -q
}
Set-Alias pci Invoke-CI
```

</details>

---

## Project Layout

```
└─ src/
   └─ fastapi_microservice_template/
      ├── __init__.py          # create_app() factory
      ├── main.py              # Uvicorn entry-point
      └─ api/
          └─ v1/
              └─ health.py     # /api/v1/healthz
└─ tests/                      # pytest —q
└─ docker/
   └─ Dockerfile               # slim Python 3.12 image
└─ compose.yaml                # dev container
└─ pyproject.toml              # Poetry + PEP 621 metadata
└─ Makefile (optional)         # make ci / make dev / make fmt
└─ .pre-commit-config.yaml     # ruff + black + pytest hook
```

### Key Design Points

| Principle                      | Implementation                                                                            |
| ------------------------------ | ----------------------------------------------------------------------------------------- |
| **`src/`-layout**              | Keeps your package off `PYTHONPATH` until installed—tests mirror production import paths. |
| **App factory** (`create_app`) | Enables multiple ASGI apps in-memory (tests, Celery, background tasks).                   |
| **Versioned routers**          | Easy to roll out `/api/v2` without breaking `/v1`.                                        |
| **Single toolchain**           | Poetry (deps & venv) ➜ Ruff (lint & fmt) ➜ Pytest ➜ Uvicorn.                              |

---

## Local Tooling

| Tool           | Purpose                               | Install                                               |
| -------------- | ------------------------------------- | ----------------------------------------------------- |
| **Poetry 2.1** | dependency & venv manager             | `pipx install poetry`                                 |
| **Ruff**       | linter + import sorter + formatter    | installed by Poetry                                   |
| **Black**      | formatting (guard only—Ruff enforces) | ”                                                     |
| **Pytest**     | test runner                           | ”                                                     |
| **Make**       | cross-OS task runner                  | `winget install GnuWin32.Make` or `brew install make` |
| **Docker**     | packaging / runtime parity            | docker.com                                            |

---

## Developer Workflows

### Daily loop

```bash
git switch -c feat/awesome
make dev          # poetry install + uvicorn --reload
## code...
make ci           # lint → format → tests
git commit -am "feat: awesome endpoint"
git push origin feat/awesome
```

### Quality gates

```
make ci
│
├─ poetry install           # exact-lock install
├─ poetry check --lock      # lockfile drift guard
├─ ruff check .             # linter (E,F,I,UP,B) & import-sort
├─ ruff format --check .    # formatter guard
└─ pytest -q                # fast unit tests
```

*Runs identically in GitHub Actions.*

---

## API Example

```python
# src/fastapi_microservice_template/api/v1/health.py
from fastapi import APIRouter

router = APIRouter(tags=["health"])


@router.get("/healthz", summary="Liveness probe")
async def healthcheck() -> dict[str, str]:
    return {"status": "ok"}
```

Live at **`GET /api/v1/healthz`** (200 → `{"status":"ok"}`).

---

## CI/CD Pipeline

| Stage                     | Job                   | Notes                                                                    |
| ------------------------- | --------------------- | ------------------------------------------------------------------------ |
| **PR** (`dev` branch)     | **CI** — `build-test` | Lint + format + tests must pass before merge.                            |
| **Merge** (`main` branch) | **Release**           | Reads `pyproject.toml` version → tags `vX.Y.Z` → creates GitHub release. |
| (optional)                | **Docker publish**    | Add Buildx step to push multi-arch image to GHCR/ECR.                    |

---

## Deployment Recipes

| Target                       | Command / link                                          |
| ---------------------------- | ------------------------------------------------------- |
| **Docker Swarm / Compose**   | `docker compose -f compose.yaml up -d --build`          |
| **Kubernetes (deploy.yaml)** | `kubectl apply -k k8s/overlays/prod`                    |
| **AWS App Runner**           | Point App Runner to GitHub repo; build from Dockerfile. |
| **Azure Container Apps**     | `az containerapp up --source .`                         |

*(K8s manifest & Terraform modules provided in the `deploy/` folder—stubbed.)*

---

## Versioning & Releases

* Semantic Versioning (`MAJOR.MINOR.PATCH`)
* `poetry version patch` → commit → PR “Release vX.Y.Z” → merge into **main**
  → GitHub Action tags release + (optionally) publishes Docker image.
* `CHANGELOG.md` is generated from Conventional Commit messages.

---

## Contributing

1. Fork / clone, create a feature branch (`feat/*`, `fix/*`).
2. `make ci` (or `pci`) must pass.
3. Open a Pull Request into **dev**; at least one reviewer required.
4. Keep PRs under 500 LoC; larger ones need an Architecture Decision Record (`docs/adr/`).
5. For non-code contributions (docs, issues) follow the issue templates.

---

## Licence

```
MIT License

Copyright (c) 2025 Simbarashe Timire

Permission is hereby granted, free of charge, to any person obtaining...
```

---

Happy hacking 🎉
