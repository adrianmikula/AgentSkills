#!/usr/bin/env bash
set -euo pipefail

SKILL_NAME="detect-codebase-entropy-lite"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
STAGING_DIR="${ROOT_DIR}/dist/staging/${SKILL_NAME}"
OUTPUT_ZIP="${ROOT_DIR}/dist/${SKILL_NAME}.zip"

echo "Building Claude skill: ${SKILL_NAME}"

mkdir -p "${ROOT_DIR}/dist"
rm -rf "${STAGING_DIR}"
rm -f "${OUTPUT_ZIP}"

mkdir -p "${STAGING_DIR}/resources"

cp "${SCRIPT_DIR}/SKILL.md" "${STAGING_DIR}/SKILL.md"
cp "${SCRIPT_DIR}/README.md" "${STAGING_DIR}/README.md"
cp "${SCRIPT_DIR}/vault.yaml" "${STAGING_DIR}/vault.yaml"

shopt -s nullglob
for f in "${SCRIPT_DIR}/resources/"*.*; do
  if [ -f "$f" ]; then
    cp "$f" "${STAGING_DIR}/resources/"
  fi
done
shopt -u nullglob

cd "$(dirname "${STAGING_DIR}")"
zip -r "${OUTPUT_ZIP}" "${SKILL_NAME}/"

rm -rf "${STAGING_DIR}"

echo "Done: ${OUTPUT_ZIP}"
echo ""
echo "Contents:"
unzip -l "${OUTPUT_ZIP}"
