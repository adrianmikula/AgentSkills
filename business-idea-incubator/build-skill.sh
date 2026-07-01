#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="business-idea-incubator-skill"
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

# Copy resource files into flat resources/ folder
cp "${SCRIPT_DIR}/resources/idea-validation.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/startup-foundations.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/marketing.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/outreach-framing.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/profitability.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/competitive-intelligence.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/business-operations.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/vibe-coding.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/production-deployment.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/ecommerce-selling.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/social-media.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/accessing-idea-files.md" "${STAGING_DIR}/resources/"

# Package: ZIP must have the skill folder as its root (not files at root)
cd "${SCRIPT_DIR}"
zip -r "${OUTPUT_ZIP}" "${SKILL_NAME}/"

# Clean up staging dir
rm -rf "${STAGING_DIR}"

echo "Done: ${OUTPUT_ZIP}"
echo ""
echo "Contents:"
unzip -l "${OUTPUT_ZIP}"

# --- Setup agent symlinks (Kilo Code, Opencode, Devin) ---
echo ""
echo "=== Setting up multi-agent symlinks ==="
bash "${SCRIPT_DIR}/../scripts/setup-agent-links.sh" "business-idea-incubator"
