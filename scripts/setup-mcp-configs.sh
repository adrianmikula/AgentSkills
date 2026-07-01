#!/usr/bin/env bash
# Copies example MCP config files to their real (gitignored) locations
# so you can fill in API credentials without risking a commit.
#
# Usage: setup-mcp-configs.sh [--force]
#
# --force  Overwrite existing real configs (otherwise skip if exists)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

FORCE=false
if [ "${1:-}" = "--force" ]; then
  FORCE=true
fi

copy_example() {
  local example="$1"
  local real="$2"
  local label="$3"

  if [ ! -f "$example" ]; then
    echo "  SKIP  ${label} — example file missing: ${example}" >&2
    return
  fi

  if [ -f "$real" ] && [ "$FORCE" = false ]; then
    echo "  SKIP  ${label} — real config exists at ${real} (use --force to overwrite)"
    return
  fi

  cp "$example" "$real"
  echo "  OK    ${label} — created ${real}"
}

echo "Setting up MCP config files..."
echo "  (edit the real files afterward to add your API credentials)"
echo "  (real files are gitignored — safe from accidental commits)"
echo ""

copy_example "${ROOT_DIR}/.kilocode/mcp.example.json" ".kilocode/mcp.json" "Kilo Code"
copy_example "${ROOT_DIR}/.opencode/config.example.json" ".opencode/config.json" "Opencode"
copy_example "${ROOT_DIR}/.devin/config.local.example.json" ".devin/config.local.json" "Devin (local override)"

echo ""
echo "Done. Edit the files above to add your API keys and fix the PROJECT_ROOT path."
