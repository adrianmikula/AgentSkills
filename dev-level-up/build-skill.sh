#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="dev-level-up-skill"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
STAGING_DIR="${SCRIPT_DIR}/${SKILL_NAME}"
OUTPUT_ZIP="${ROOT_DIR}/dist/${SKILL_NAME}.zip"

echo "Building Claude skill: ${SKILL_NAME}"

# Clean previous staging dir and ZIP
mkdir -p "${ROOT_DIR}/dist"
rm -rf "${STAGING_DIR}"
rm -f "${OUTPUT_ZIP}"

# Create staging structure
mkdir -p "${STAGING_DIR}/resources"

# Copy Skill.md to staging root
cp "${SCRIPT_DIR}/Skill.md" "${STAGING_DIR}/Skill.md"

# Copy resource files into resources/ folder
cp "${SCRIPT_DIR}/resources/source-search-templates.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/evaluation-rubric.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/search-api-guide.md" "${STAGING_DIR}/resources/"

# Package: ZIP must have the skill folder as its root (not files at root)
cd "${SCRIPT_DIR}"
zip -r "${OUTPUT_ZIP}" "${SKILL_NAME}/"

# Clean up staging dir
rm -rf "${STAGING_DIR}"

echo "Build complete: ${OUTPUT_ZIP}"

# --- Setup agent symlinks (Kilo Code, Opencode, Devin) ---
echo ""
echo "=== Setting up multi-agent symlinks ==="
bash "${SCRIPT_DIR}/../scripts/setup-agent-links.sh" "dev-level-up"
