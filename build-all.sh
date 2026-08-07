#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIRS=(
  "ai-era-vulnerability-scanner"
  "business-outreach-generator"
  "cognitive-sustainability"
  "dev-level-up"
  "city-risk-landscape"
  "optimise-agentic-coding"
  "build-wordpress-plugin"
  "business-idea-incubator"
  "deterministic-refactor"
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
echo "=== Validating Skill.md frontmatter (Kilo compatibility) ==="
for dir in "${SKILL_DIRS[@]}"; do
  skill_md="${SCRIPT_DIR}/${dir}/Skill.md"
  if ! head -5 "${skill_md}" | grep -q "^name: ${dir}$"; then
    echo "ERROR: ${skill_md} frontmatter 'name' must match directory name '${dir}'" >&2
    echo "  Found: $(head -3 "${skill_md}" | grep '^name:' | sed 's/^name: //')" >&2
    exit 1
  fi
  echo "  OK: ${dir}"
done

echo ""
echo "=== Setting up multi-agent symlinks ==="
for dir in "${SKILL_DIRS[@]}"; do
  bash "${SCRIPT_DIR}/scripts/setup-agent-links.sh" "${dir}"
done

echo ""
echo "=== Validating agent symlinks ==="
for dir in "${SKILL_DIRS[@]}"; do
  agents_link="${SCRIPT_DIR}/.agents/skills/${dir}/SKILL.md"
  if [[ ! -L "${agents_link}" ]]; then
    echo "ERROR: Missing symlink ${agents_link}" >&2
    exit 1
  fi
  opencode_link="${SCRIPT_DIR}/.opencode/skill/${dir}/SKILL.md"
  if [[ ! -L "${opencode_link}" ]]; then
    echo "ERROR: Missing symlink ${opencode_link}" >&2
    exit 1
  fi
  echo "  OK: ${dir}"
done

echo ""
echo "=== Building individual skill ZIPs ==="
for dir in "${SKILL_DIRS[@]}"; do
  echo ""
  echo "--- Building ${dir} ---"
  (cd "${SCRIPT_DIR}/${dir}" && bash build-skill.sh)
done

echo ""
echo "=== All builds complete ==="
echo ""
echo "=== Output ZIPs ==="
ls -lh "${SCRIPT_DIR}/dist/"*"-skill.zip" 2>/dev/null || echo "  (none found)"
