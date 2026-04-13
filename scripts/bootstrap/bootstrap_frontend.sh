#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

FRONTEND_DIR="${REPO_ROOT}/frontend/webapp"
PACKAGE_JSON="${FRONTEND_DIR}/package.json"

echo "==> Bootstrap frontend environment"

if ! command -v node >/dev/null 2>&1; then
  echo "Error: node not found in PATH."
  exit 1
fi

if ! command -v npm >/dev/null 2>&1; then
  echo "Error: npm not found in PATH."
  exit 1
fi

if [ ! -d "${FRONTEND_DIR}" ]; then
  echo "Error: frontend directory not found at ${FRONTEND_DIR}"
  exit 1
fi

if [ ! -f "${PACKAGE_JSON}" ]; then
  echo "==> No package.json found in ${FRONTEND_DIR}."
  echo "==> Skipping npm install for now."
  echo
  echo "Frontend bootstrap completed with no dependencies installed."
  exit 0
fi

echo "==> Installing frontend dependencies in ${FRONTEND_DIR}"
cd "${FRONTEND_DIR}"
npm install

echo
echo "Frontend bootstrap completed."
echo "Next step: run ./scripts/run/run_frontend.sh"