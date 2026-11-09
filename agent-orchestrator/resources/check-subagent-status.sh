#!/bin/bash
# Check status of active subagents
# Usage: ./check-subagent-status.sh [state-file]
# Default state file: .orchestrator-state.json

set -e

STATE_FILE=${1:-.orchestrator-state.json}

if [ ! -f "$STATE_FILE" ]; then
    echo "Error: State file '$STATE_FILE' not found."
    echo "Create it first or specify a different path."
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it first."
    exit 1
fi

# Read active subagents
echo "=== Active Subagents ==="
jq -r '.active_subagents[] | "Issue #\(.issue_number): \(.status) (started: \(.start_time), last check: \(.last_check))"' "$STATE_FILE"

# Count active subagents
ACTIVE_COUNT=$(jq '.active_subagents | length' "$STATE_FILE")
echo "Total active subagents: $ACTIVE_COUNT"

# Check for stale subagents (no check in last 5 minutes)
echo "=== Stale Subagents (no check in 5+ minutes) ==="
CURRENT_TIME=$(date -u +%s)
STALE_COUNT=0

jq -r '.active_subagents[] | select(.status == "running") | .issue_number' "$STATE_FILE" | while read -r issue_num; do
    LAST_CHECK=$(jq -r ".active_subagents[] | select(.issue_number == $issue_num) | .last_check" "$STATE_FILE")
    if [ "$LAST_CHECK" != "null" ]; then
        LAST_CHECK_TIME=$(date -u -d "$LAST_CHECK" +%s 2>/dev/null || echo 0)
        TIME_DIFF=$((CURRENT_TIME - LAST_CHECK_TIME))
        if [ $TIME_DIFF -gt 300 ]; then
            echo "Issue #$issue_num: Last check was $((TIME_DIFF / 60)) minutes ago"
            ((STALE_COUNT++))
        fi
    fi
done

echo "Stale subagents: $STALE_COUNT"
