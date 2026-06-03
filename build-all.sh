#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIRS=(
  "ai-era-vulnerability-scanner"
  "business-outreach-generator"
  "cognitive-sustainability"
  "dev-level-up"
  "city-risk-landscape"
)

echo "=== Validating plugin manifests ==="
for dir in "${SKILL_DIRS[@]}"; do
  plugin_json="${SCRIPT_DIR}/${dir}/.claude-plugin/plugin.json"
  if [[ ! -f "${plugin_json}" ]]; then
    echo "ERROR: Missing ${plugin_json}" >&2
    exit 1
  fi
  if ! python3 -m json.tool "${plugin_json}" > /dev/null 2>&1; then
    echo "ERROR: Invalid JSON in ${plugin_json}" >&2
    exit 1
  fi
  echo "  OK: ${dir}"
done

echo ""
echo "=== Validating root marketplace.json ==="
if ! python3 -m json.tool "${SCRIPT_DIR}/marketplace.json" > /dev/null 2>&1; then
  echo "ERROR: Invalid JSON in marketplace.json" >&2
  exit 1
fi
echo "  OK: marketplace.json"

echo ""
echo "=== Building individual skill ZIPs ==="
for dir in "${SKILL_DIRS[@]}"; do
  echo ""
  echo "--- Building ${dir} ---"
  (cd "${SCRIPT_DIR}/${dir}" && bash build-skill.sh)
done

echo ""
echo "=== All builds complete ==="
