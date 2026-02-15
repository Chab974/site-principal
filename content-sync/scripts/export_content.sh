#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
SITE_ROOT="$(cd "${ROOT_DIR}/.." && pwd)"

DB_PATH="${ROOT_DIR}/.local/content.db"
MENU_PATH="${SITE_ROOT}/menu/menu.json"
APPS_PATH="${SITE_ROOT}/data/apps.json"
MENU_TMP="${MENU_PATH}.tmp"
APPS_TMP="${APPS_PATH}.tmp"

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
SNAPSHOT_DIR="${ROOT_DIR}/snapshots/${TIMESTAMP}"

if ! command -v sqlite3 >/dev/null 2>&1; then
  echo "sqlite3 is required but not found." >&2
  exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
  echo "python3 is required but not found." >&2
  exit 1
fi

mkdir -p "${SNAPSHOT_DIR}"

if [[ -f "${MENU_PATH}" ]]; then
  cp "${MENU_PATH}" "${SNAPSHOT_DIR}/menu.json"
fi
if [[ -f "${APPS_PATH}" ]]; then
  cp "${APPS_PATH}" "${SNAPSHOT_DIR}/apps.json"
fi

echo "Snapshot created: ${SNAPSHOT_DIR}"

if [[ "${1:-}" == "--snapshot-only" ]]; then
  echo "Snapshot only mode: no export performed."
  exit 0
fi

if [[ ! -f "${DB_PATH}" ]]; then
  cat >&2 <<EOF
Database not found: ${DB_PATH}
Initialize it with:
  sqlite3 "${DB_PATH}" < "${ROOT_DIR}/migrations/001_init.sql"
  sqlite3 "${DB_PATH}" < "${ROOT_DIR}/seeds/001_seed_from_current.sql"
EOF
  exit 1
fi

python3 "${SCRIPT_DIR}/export_content.py" \
  --db "${DB_PATH}" \
  --menu-out "${MENU_TMP}" \
  --apps-out "${APPS_TMP}"

# Validate generated JSON before atomic replace.
python3 - <<'PY' "${MENU_TMP}" "${APPS_TMP}"
import json
import sys
for p in sys.argv[1:]:
    with open(p, "r", encoding="utf-8") as f:
        json.load(f)
PY

mv "${MENU_TMP}" "${MENU_PATH}"
mv "${APPS_TMP}" "${APPS_PATH}"

echo "Export complete."
echo "- menu: ${MENU_PATH}"
echo "- apps: ${APPS_PATH}"

