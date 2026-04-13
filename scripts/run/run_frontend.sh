#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

FRONTEND_DIR="${REPO_ROOT}/frontend/webapp"
PACKAGE_JSON="${FRONTEND_DIR}/package.json"
NODE_MODULES_DIR="${FRONTEND_DIR}/node_modules"

echo "==> Run frontend"

if [ ! -d "${FRONTEND_DIR}" ]; then
  echo "Error: frontend directory not found at ${FRONTEND_DIR}"
  exit 1
fi

if [ ! -f "${PACKAGE_JSON}" ]; then
  echo "Error: package.json not found at ${PACKAGE_JSON}"
  echo "Initialize the frontend app first."
  exit 1
fi

if [ ! -d "${NODE_MODULES_DIR}" ]; then
  echo "Error: frontend dependencies are not installed."
  echo "Run ./scripts/bootstrap/bootstrap_frontend.sh first."
  exit 1
fi

cd "${FRONTEND_DIR}"
echo "==> Starting frontend dev server"
npm run dev