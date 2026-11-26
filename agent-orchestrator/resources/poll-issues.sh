#!/bin/bash
# Poll GitHub issues for a repository and report deltas (new / changed / closed)
# Usage: ./poll-issues.sh <owner> <repo> [state] [interval-seconds]
# Defaults: state=open, interval=60 seconds
#
# Delta tracking:
#   - A baseline snapshot of the issue set is stored in $POLL_STATE_FILE
#     (default: .poll-issues-state.json) in the current directory.
#   - The first run only establishes the baseline and reports how many issues
#     were seen. Each subsequent poll diffs the live API response against the
#     snapshot and reports new, changed (updatedAt differs: new comments,
#     labels, edits), and closed/disappeared issues.
#   - Failed API calls or non-JSON responses are logged and skipped; they
#     never overwrite the snapshot, so a network outage, machine sleep, or
#     empty/error response cannot be mistaken for "no issues".
#   - A heartbeat line is printed every cycle for transparency.
#
# Auth: requires the GitHub CLI (`gh`) authenticated via `gh auth login` or
# the GH_TOKEN environment variable. No tokens are stored by this script.

set -euo pipefail

OWNER=${1:-}
REPO=${2:-}
STATE=${3:-open}
INTERVAL=${4:-${POLL_INTERVAL:-60}}

STATE_FILE=${POLL_STATE_FILE:-.poll-issues-state.json}

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
    echo "Usage: $0 <owner> <repo> [state] [interval-seconds]"
    echo "Example: $0 adrianmikula AgentSkills open 60"
    echo "State snapshot file: $STATE_FILE (override with POLL_STATE_FILE)"
    exit 1
fi

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

# Check if jq is installed (needed for delta detection)
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it first."
    exit 1
fi

# Check if authenticated (gh auth login or GH_TOKEN env var)
gh auth status &> /dev/null || {
    echo "Error: Not authenticated with GitHub CLI. Run 'gh auth login' or set GH_TOKEN."
    exit 1
}

# Fetch open issues in the requested state as a JSON array.
# Returns non-zero on any API/CLI failure so callers can skip the cycle.
fetch_issues() {
    gh issue list --repo "$OWNER/$REPO" --state "$STATE" \
        --json number,title,updatedAt,labels \
        --limit 100
}

# Write the snapshot atomically: {"issues": {"<number>": {"title":..., "updatedAt":...}}}
write_snapshot() {
    jq -c '{issues: ([.[] | {key: (.number|tostring), value: {title: .title, updatedAt: .updatedAt}}] | from_entries)}' \
        > "$STATE_FILE.tmp" <<<"$1" && mv "$STATE_FILE.tmp" "$STATE_FILE"
}

# Diff the live issue array ($new) against the snapshot's issue map ($old).
# Emits {"new": [...], "changed": [...], "closed": [...]} with {number,title} entries.
compute_deltas() {
    jq -n --argjson old "$1" --argjson new "$2" '
        ($new | map({key: (.number|tostring), value: {number, title, updatedAt}}) | from_entries) as $n
        | {
            new:     [$n | to_entries[] | select($old[.key] == null) | .value | {number, title}],
            changed: [$n | to_entries[] | select($old[.key] != null and $old[.key].updatedAt != .value.updatedAt) | .value | {number, title}],
            closed:  [$old | to_entries[] | select($n[.key] == null) | {number: (.key|tonumber), title: .value.title}]
          }'
}

print_deltas() {
    jq -r '.new[]     | "delta: new issue     #\(.number) - \(.title)"' <<<"$1"
    jq -r '.changed[] | "delta: issue updated #\(.number) - \(.title)"' <<<"$1"
    jq -r '.closed[]  | "delta: issue closed  #\(.number) - \(.title)"' <<<"$1"
}

CYCLE=0
echo "=== Issue poller started for $OWNER/$REPO (state: $STATE, interval: ${INTERVAL}s) ==="
echo "Snapshot file: $STATE_FILE"
echo "First cycle establishes the baseline; deltas are reported from cycle 2 onward."
echo "Press Ctrl+C to stop"
trap 'echo ""; echo "=== Poller stopped ==="; exit 0' INT

while true; do
    CYCLE=$((CYCLE + 1))
    TS=$(date -u '+%Y-%m-%dT%H:%M:%SZ')
    echo "[heartbeat] $TS cycle=$CYCLE repo=$OWNER/$REPO state=$STATE"

    # Fetch issues; skip the whole cycle on failure (never treat errors as empty state)
    if ! ISSUES=$(fetch_issues 2>/dev/null) || ! jq -e 'type == "array"' > /dev/null <<<"$ISSUES"; then
        echo "[heartbeat] $TS WARNING: issue fetch failed or returned non-JSON; skipping cycle (snapshot preserved)"
        sleep "$INTERVAL"
        continue
    fi

    COUNT=$(jq 'length' <<<"$ISSUES")

    # Read previous snapshot; a missing or corrupt snapshot means "needs baseline"
    OLD='{}'
    HAS_SNAPSHOT=0
    if [ -f "$STATE_FILE" ]; then
        PARSED=$(jq -c '.issues // empty' "$STATE_FILE" 2>/dev/null || true)
        if [ -n "$PARSED" ] && jq -e 'type == "object"' > /dev/null <<<"$PARSED"; then
            OLD="$PARSED"
            HAS_SNAPSHOT=1
        fi
    fi

    if [ "$HAS_SNAPSHOT" -eq 0 ]; then
        # First run (or corrupt/missing snapshot): establish baseline, report no deltas
        write_snapshot "$ISSUES"
        echo "[heartbeat] $TS baseline established: $COUNT $STATE issue(s) tracked in $STATE_FILE"
    else
        DELTAS=$(compute_deltas "$OLD" "$ISSUES")
        NEW_N=$(jq '.new | length' <<<"$DELTAS")
        CHG_N=$(jq '.changed | length' <<<"$DELTAS")
        CLS_N=$(jq '.closed | length' <<<"$DELTAS")

        echo "[heartbeat] $TS poll: $COUNT $STATE issue(s) tracked | +$NEW_N new ~$CHG_N changed -$CLS_N closed"
        if [ "$((NEW_N + CHG_N + CLS_N))" -gt 0 ]; then
            print_deltas "$DELTAS"
        fi

        # Persist the new snapshot only after a successful fetch+diff
        write_snapshot "$ISSUES"
    fi

    sleep "$INTERVAL"
done
