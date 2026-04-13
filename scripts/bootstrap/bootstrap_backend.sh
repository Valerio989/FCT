#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

BACKEND_DIR="${REPO_ROOT}/backend"
VENV_DIR="${BACKEND_DIR}/.venv"
REQUIREMENTS_FILE="${BACKEND_DIR}/requirements.txt"

echo "==> Bootstrap backend environment"

if ! command -v python3 >/dev/null 2>&1; then
  echo "Error: python3 not found in PATH."
  exit 1
fi

if ! python3 -m venv --help >/dev/null 2>&1; then
  echo "Error: Python venv module is not available."
  exit 1
fi

if [ ! -d "${BACKEND_DIR}" ]; then
  echo "Error: backend directory not found at ${BACKEND_DIR}"
  exit 1
fi

if [ ! -d "${VENV_DIR}" ]; then
  echo "==> Creating virtual environment at ${VENV_DIR}"
  python3 -m venv "${VENV_DIR}"
else
  echo "==> Virtual environment already exists at ${VENV_DIR}"
fi

# shellcheck disable=SC1091
source "${VENV_DIR}/bin/activate"

echo "==> Upgrading pip"
python -m pip install --upgrade pip

if [ -f "${REQUIREMENTS_FILE}" ]; then
  echo "==> Installing backend dependencies from ${REQUIREMENTS_FILE}"
  pip install -r "${REQUIREMENTS_FILE}"
else
  echo "==> No requirements.txt found in backend/. Skipping dependency installation."
fi

echo
echo "Backend bootstrap completed."
echo "Next step: run ./scripts/run/run_backend.sh"