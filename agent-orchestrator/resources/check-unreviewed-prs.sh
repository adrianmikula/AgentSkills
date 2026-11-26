#!/bin/bash
# List open pull requests that have not yet been reviewed by the PR-review
# subagent (reasoning-section check + serious-issues-only code review).
# Usage: ./check-unreviewed-prs.sh <owner> <repo> [state-file]
# Default state file: .orchestrator-state.json
#
# Output: JSON object on stdout, e.g.:
#   {"unreviewed_prs":[{"number":123,"title":"...","headRefName":"...","isDraft":false,"author":"...","url":"...","createdAt":"..."}]}
# The array is empty when every open PR has been reviewed.
#
# Notes:
# - A PR counts as reviewed when its number appears in the state file's
#   "reviewed_prs" array (entries look like {"pr_number": 123, ...}).
# - If the state file does not exist or has no "reviewed_prs" key, ALL open
#   PRs are reported. This is the intended backfill path for PRs that were
#   opened while the orchestrator was down.
# - This script is read-only: it never posts comments or mutates state.

set -e

OWNER=$1
REPO=$2
STATE_FILE=${3:-.orchestrator-state.json}

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
    echo "Usage: $0 <owner> <repo> [state-file]" >&2
    echo "Example: $0 adrianmikula AgentSkills .orchestrator-state.json" >&2
    exit 1
fi

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first." >&2
    exit 1
fi

# Check if authenticated
gh auth status &> /dev/null || {
    echo "Error: Not authenticated with GitHub CLI. Run 'gh auth login' first." >&2
    exit 1
}

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it first." >&2
    exit 1
fi

# Fetch open PRs
PRS=$(gh pr list --repo "$OWNER/$REPO" --state open --limit 100 \
    --json number,title,headRefName,isDraft,author,url,createdAt)

# Collect reviewed PR numbers from the state file (empty set if unavailable)
REVIEWED="[]"
if [ -f "$STATE_FILE" ]; then
    REVIEWED=$(jq '[.reviewed_prs // [] | .[] | .pr_number]' "$STATE_FILE" 2>/dev/null || echo "[]")
fi

# Report open PRs whose number is not in the reviewed set
jq -n --argjson prs "$PRS" --argjson reviewed "$REVIEWED" '
    [$prs[] | select(.number as $n | ($reviewed | index($n)) | not)
     | {number, title, headRefName, isDraft,
        author: (.author.login // "unknown"), url, createdAt}]
    | {unreviewed_prs: .}'
