#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

BACKEND_DIR="${REPO_ROOT}/backend"
VENV_DIR="${BACKEND_DIR}/.venv"
MAIN_FILE="${BACKEND_DIR}/main.py"

echo "==> Run backend"

if [ ! -d "${BACKEND_DIR}" ]; then
  echo "Error: backend directory not found at ${BACKEND_DIR}"
  exit 1
fi

if [ ! -d "${VENV_DIR}" ]; then
  echo "Error: backend virtual environment not found at ${VENV_DIR}"
  echo "Run ./scripts/bootstrap/bootstrap_backend.sh first."
  exit 1
fi

# shellcheck disable=SC1091
source "${VENV_DIR}/bin/activate"

if [ ! -f "${MAIN_FILE}" ]; then
  echo "Error: backend entrypoint not found at ${MAIN_FILE}"
  echo "Expected a FastAPI app entrypoint in backend/main.py"
  exit 1
fi

if ! python -c "import uvicorn" >/dev/null 2>&1; then
  echo "Error: uvicorn is not installed in backend virtual environment."
  echo "Add it to backend/requirements.txt and rerun bootstrap."
  exit 1
fi

cd "${BACKEND_DIR}"
echo "==> Starting FastAPI dev server"
uvicorn main:app --reload