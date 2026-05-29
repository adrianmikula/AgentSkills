#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="business-outreach-generator-skill"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STAGING_DIR="${SCRIPT_DIR}/${SKILL_NAME}"
OUTPUT_ZIP="${SCRIPT_DIR}/${SKILL_NAME}.zip"

echo "Building Claude skill: ${SKILL_NAME}"

# Clean previous staging dir and ZIP
rm -rf "${STAGING_DIR}"
rm -f "${OUTPUT_ZIP}"

# Create staging structure
mkdir -p "${STAGING_DIR}/resources"

# Copy Skill.md to staging root
cp "${SCRIPT_DIR}/Skill.md" "${STAGING_DIR}/Skill.md"

# Copy resource policy files into flat resources/ folder
cp "${SCRIPT_DIR}/resources/ai-era-security-audit-offer.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/jakarta-migration-risk-assessment-offer.md" "${STAGING_DIR}/resources/"
cp "${SCRIPT_DIR}/resources/ai-codebase-entropy-audit-offer.md" "${STAGING_DIR}/resources/"

# Package: ZIP must have the skill folder as its root (not files at root)
cd "${SCRIPT_DIR}"
zip -r "${OUTPUT_ZIP}" "${SKILL_NAME}/"

# Clean up staging dir
rm -rf "${STAGING_DIR}"

echo "Done: ${OUTPUT_ZIP}"
echo ""
echo "Contents:"
unzip -l "${OUTPUT_ZIP}"
