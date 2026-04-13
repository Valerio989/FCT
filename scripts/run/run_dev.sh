#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

BOOTSTRAP_BACKEND="${REPO_ROOT}/scripts/bootstrap/bootstrap_backend.sh"
BOOTSTRAP_FRONTEND="${REPO_ROOT}/scripts/bootstrap/bootstrap_frontend.sh"
RUN_BACKEND="${REPO_ROOT}/scripts/run/run_backend.sh"
RUN_FRONTEND="${REPO_ROOT}/scripts/run/run_frontend.sh"

BACKEND_VENV="${REPO_ROOT}/backend/.venv"
FRONTEND_PACKAGE_JSON="${REPO_ROOT}/frontend/webapp/package.json"
FRONTEND_NODE_MODULES="${REPO_ROOT}/frontend/webapp/node_modules"

echo "==> FCT local development workflow"
echo

for script in \
  "${BOOTSTRAP_BACKEND}" \
  "${BOOTSTRAP_FRONTEND}" \
  "${RUN_BACKEND}" \
  "${RUN_FRONTEND}"; do
  if [ ! -f "${script}" ]; then
    echo "Error: required script not found: ${script}"
    exit 1
  fi
done

echo "Workflow status:"
echo

if [ -d "${BACKEND_VENV}" ]; then
  echo "[OK] Backend virtual environment found: backend/.venv"
else
  echo "[MISSING] Backend virtual environment not found."
  echo "          Run: ./scripts/bootstrap/bootstrap_backend.sh"
fi

if [ -f "${FRONTEND_PACKAGE_JSON}" ]; then
  echo "[OK] Frontend package.json found."
else
  echo "[MISSING] Frontend package.json not found."
  echo "          Initialize the frontend app first."
fi

if [ -d "${FRONTEND_NODE_MODULES}" ]; then
  echo "[OK] Frontend dependencies installed."
else
  echo "[MISSING] Frontend dependencies not installed."
  echo "          Run: ./scripts/bootstrap/bootstrap_frontend.sh"
fi

echo
echo "Recommended local development sequence:"
echo "1. ./scripts/bootstrap/bootstrap_backend.sh"
echo "2. ./scripts/bootstrap/bootstrap_frontend.sh"
echo "3. ./scripts/run/run_backend.sh"
echo "4. ./scripts/run/run_frontend.sh"
echo
echo "Notes:"
echo "- In workflow v0, backend and frontend are started separately."
echo "- PX4 SITL, ROS2 runtime, adapter, and database orchestration are not included yet."