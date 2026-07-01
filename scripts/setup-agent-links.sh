#!/usr/bin/env bash
# Creates symlinks for .agents/skills/<name>/ and .opencode/skill/<name>/
# pointing back to the canonical skill source files.
#
# Usage: setup-agent-links.sh <skill-dir-name>
#
# The skill directory name must match the `name` field in the Skill.md
# frontmatter (lowercase, hyphens only — required by Kilo Code).
#
# Cognitive-sustainability uses 10-policies/ as its resource source,
# all other skills use resources/.

set -euo pipefail

SKILL_DIR="$1"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [ -z "$SKILL_DIR" ]; then
  echo "Usage: setup-agent-links.sh <skill-dir-name>" >&2
  exit 1
fi

# Determine the resource source directory for this skill.
# Most skills use resources/. cognitive-sustainability uses 10-policies/.
RESOURCE_SRC="resources"
if [ "$SKILL_DIR" = "cognitive-sustainability" ]; then
  RESOURCE_SRC="10-policies"
fi

SKILL_SOURCE_DIR="${ROOT_DIR}/${SKILL_DIR}"
RESOURCE_SOURCE_DIR="${SKILL_SOURCE_DIR}/${RESOURCE_SRC}"

if [ ! -d "$SKILL_SOURCE_DIR" ]; then
  echo "ERROR: Skill source directory does not exist: ${SKILL_SOURCE_DIR}" >&2
  exit 1
fi

if [ ! -f "${SKILL_SOURCE_DIR}/Skill.md" ]; then
  echo "ERROR: ${SKILL_SOURCE_DIR}/Skill.md not found" >&2
  exit 1
fi

# --- .agents/skills/<name>/ (Kilo Code + Devin standard) ---
AGENTS_TARGET="${ROOT_DIR}/.agents/skills/${SKILL_DIR}"
mkdir -p "${AGENTS_TARGET}"
rm -f "${AGENTS_TARGET}/SKILL.md" "${AGENTS_TARGET}/resources"
ln -sf "../../../${SKILL_DIR}/Skill.md" "${AGENTS_TARGET}/SKILL.md"
echo "  ${AGENTS_TARGET}/SKILL.md -> ../../../${SKILL_DIR}/Skill.md"
if [ -d "$RESOURCE_SOURCE_DIR" ]; then
  ln -sf "../../../${SKILL_DIR}/${RESOURCE_SRC}" "${AGENTS_TARGET}/resources"
  echo "  ${AGENTS_TARGET}/resources -> ../../../${SKILL_DIR}/${RESOURCE_SRC}"
else
  echo "  (no resources to link)"
fi

# --- .opencode/skill/<name>/ ---
OPENCODE_TARGET="${ROOT_DIR}/.opencode/skill/${SKILL_DIR}"
mkdir -p "${OPENCODE_TARGET}"
rm -f "${OPENCODE_TARGET}/SKILL.md" "${OPENCODE_TARGET}/resources"
ln -sf "../../../.agents/skills/${SKILL_DIR}/SKILL.md" "${OPENCODE_TARGET}/SKILL.md"
echo "  ${OPENCODE_TARGET}/SKILL.md -> ../../../.agents/skills/${SKILL_DIR}/SKILL.md"
if [ -d "$RESOURCE_SOURCE_DIR" ]; then
  ln -sf "../../../.agents/skills/${SKILL_DIR}/resources" "${OPENCODE_TARGET}/resources"
  echo "  ${OPENCODE_TARGET}/resources -> ../../../.agents/skills/${SKILL_DIR}/resources"
else
  echo "  (no resources to link)"
fi
