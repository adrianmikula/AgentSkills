#!/bin/bash
# Check open pull requests for health issues: merge conflicts, failing
# checks/CI, and failed deployments.
# Usage: ./check-pr-health.sh <owner> <repo>
#
# Output: JSON object on stdout, e.g.:
#   {
#     "conflicts": [{"number":123,"title":"...","headRefName":"...","baseRefName":"..."}],
#     "failing_checks": [{"pr_number":123,"pr_title":"...","headRefName":"...","check":"build","conclusion":"FAILURE","url":"..."}],
#     "failed_deployments": [{"deployment_id":456,"ref":"...","sha":"...","environment":"...","state":"failure","pr_number":123}]
#   }
# All arrays are empty when healthy.
#
# Notes:
# - mergeable=UNKNOWN means GitHub is still computing mergeability; it is NOT
#   treated as a conflict. Re-run on the next poll.
# - mergeStateStatus=DIRTY also indicates merge conflicts even if mergeable
#   has not yet settled to CONFLICTING.
# - In-progress/pending checks are NOT reported as failures.
# - Deployments are matched back to open PRs by head branch name or head SHA
#   when possible; unmatched deployments still include ref/sha for correlation.

set -e

OWNER=$1
REPO=$2

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
    echo "Usage: $0 <owner> <repo>" >&2
    echo "Example: $0 adrianmikula AgentSkills" >&2
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

# Fetch open PRs with mergeability and check-run rollup
PRS=$(gh pr list --repo "$OWNER/$REPO" --state open --limit 100 \
    --json number,title,headRefName,headRefOid,baseRefName,isDraft,mergeable,mergeStateStatus,statusCheckRollup)

# 1. Merge conflicts
CONFLICTS=$(echo "$PRS" | jq '[.[]
    | select(.mergeable == "CONFLICTING" or .mergeStateStatus == "DIRTY")
    | {number, title, headRefName, baseRefName, isDraft}]')

# 2. Failing checks/CI (CheckRun.conclusion or StatusContext.state)
FAILING_CHECKS=$(echo "$PRS" | jq '[.[]
    | . as $pr
    | (.statusCheckRollup // [])[]
    | . as $c
    | select(
        (($c.conclusion // "") | test("FAILURE|ERROR|TIMED_OUT|CANCELLED|STARTUP_FAILURE|ACTION_REQUIRED"))
        or (($c.state // "") | test("FAILURE|ERROR"))
      )
    | {
        pr_number: $pr.number,
        pr_title: $pr.title,
        headRefName: $pr.headRefName,
        check: ($c.name // $c.context // "unknown"),
        conclusion: ($c.conclusion // $c.state // "unknown"),
        url: ($c.detailsUrl // $c.targetUrl // "")
      }] | unique_by((.pr_number | tostring) + ":" + .check)')

# 3. Failed deployments (latest status per recent deployment)
FAILED_DEPLOYMENTS_RAW=$(mktemp)
trap 'rm -f "$FAILED_DEPLOYMENTS_RAW"' EXIT

echo "[]" > "$FAILED_DEPLOYMENTS_RAW"

DEPLOYMENTS=$(gh api "repos/$OWNER/$REPO/deployments?per_page=30" \
    --jq '[.[] | {id, ref, sha, environment, created_at}]' 2>/dev/null || echo "[]")

echo "$DEPLOYMENTS" | jq -r '.[].id' | while read -r dep_id; do
    LATEST=$(gh api "repos/$OWNER/$REPO/deployments/$dep_id/statuses?per_page=1" \
        --jq '.[0] | {state, environment, log_url}' 2>/dev/null || echo '{}')
    STATE=$(echo "$LATEST" | jq -r '.state // empty')
    if [ "$STATE" = "failure" ] || [ "$STATE" = "error" ]; then
        DEP_INFO=$(echo "$DEPLOYMENTS" | jq --argjson id "$dep_id" '.[] | select(.id == $id)')
        ENTRY=$(echo "$DEP_INFO" | jq --argjson latest "$LATEST" \
            '{deployment_id: .id, ref, sha, environment, state: $latest.state, log_url: ($latest.log_url // "")}')
        ACCUM=$(mktemp)
        jq --argjson e "$ENTRY" '. + [$e]' "$FAILED_DEPLOYMENTS_RAW" > "$ACCUM" && mv "$ACCUM" "$FAILED_DEPLOYMENTS_RAW"
    fi
done

FAILED_DEPLOYS=$(cat "$FAILED_DEPLOYMENTS_RAW")

# Match failed deployments to open PRs by head branch name or head SHA
FAILED_DEPLOYMENTS=$(jq -n --argjson deps "$FAILED_DEPLOYS" --argjson prs "$PRS" '
    [$deps[] | . as $d
     | ([$prs[] | select(.headRefName == $d.ref or .headRefOid == $d.sha)] | .[0] // null) as $pr
     | $d + {pr_number: ($pr.number // null), pr_title: ($pr.title // null)}]
    | unique_by(.deployment_id)')

# Combine all categories
jq -n \
    --argjson conflicts "$CONFLICTS" \
    --argjson failing_checks "$FAILING_CHECKS" \
    --argjson failed_deployments "$FAILED_DEPLOYMENTS" \
    '{conflicts: $conflicts, failing_checks: $failing_checks, failed_deployments: $failed_deployments}'
