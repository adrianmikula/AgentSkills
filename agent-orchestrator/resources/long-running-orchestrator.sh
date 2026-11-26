#!/bin/bash
# Long-running orchestrator that polls for new GitHub issues and PR health issues
# Usage: ./long-running-orchestrator.sh <owner> <repo> [issue-interval-seconds] [pr-interval-seconds]
# Default intervals: 300 seconds (5 minutes) for both

set -e

OWNER=$1
REPO=$2
INTERVAL=${3:-300}
PR_INTERVAL=${4:-300}

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
    echo "Usage: $0 <owner> <repo> [issue-interval-seconds] [pr-interval-seconds]"
    echo "Example: $0 adrianmikula AgentSkills 300 300"
    exit 1
fi

# Locate helper scripts relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if gh CLI is installed
if ! command -v gh &> /dev/null; then
    echo "Error: GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

# Check if authenticated
gh auth status &> /dev/null || {
    echo "Error: Not authenticated with GitHub CLI. Run 'gh auth login' first."
    exit 1
}

# State file for tracking processed issues
STATE_FILE=".orchestrator-state.json"
PROCESSED_FILE=".processed-issues.txt"
PR_HEALTH_FILE=".pr-health.json"
# Snapshot of the last-seen issue set, used for delta detection
# (new / changed / closed) instead of an ever-growing processed list.
SNAPSHOT_FILE=".issue-snapshot.json"
LAST_PR_POLL=0
BASELINED=0

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo '{"active_subagents": [], "last_poll": null, "processed_issues": [], "pr_maintenance_agent": null}' > "$STATE_FILE"
fi

# Initialize processed issues file if it doesn't exist
if [ ! -f "$PROCESSED_FILE" ]; then
    touch "$PROCESSED_FILE"
fi

# Fetch open issues as a JSON array. Returns non-zero on any API/CLI failure
# so callers can skip the cycle instead of treating errors as "no issues".
fetch_open_issues() {
    gh issue list --repo "$OWNER/$REPO" --state open \
        --json number,title,labels,assignees,createdAt,updatedAt --limit 50
}

# Write the issue snapshot atomically:
# {"issues": {"<number>": {"title":..., "updatedAt":...}}}
write_issue_snapshot() {
    jq -c '{issues: ([.[] | {key: (.number|tostring), value: {title: .title, updatedAt: .updatedAt}}] | from_entries)}' \
        > "$SNAPSHOT_FILE.tmp" <<<"$1" && mv "$SNAPSHOT_FILE.tmp" "$SNAPSHOT_FILE"
}

# Diff the live issue array against the snapshot's issue map.
# Emits {"new": [...], "changed": [...], "closed": [...]} entries {number,title}.
compute_issue_deltas() {
    jq -n --argjson old "$1" --argjson new "$2" '
        ($new | map({key: (.number|tostring), value: {number, title, updatedAt}}) | from_entries) as $n
        | {
            new:     [$n | to_entries[] | select($old[.key] == null) | .value | {number, title}],
            changed: [$n | to_entries[] | select($old[.key] != null and $old[.key].updatedAt != .value.updatedAt) | .value | {number, title}],
            closed:  [$old | to_entries[] | select($n[.key] == null) | {number: (.key|tonumber), title: .value.title}]
          }'
}

# Re-baseline on startup: seed the snapshot from live API state so that a
# restart, network outage, or machine sleep cannot silently skip or
# misreport deltas. If the fetch fails, the first successful poll in the
# loop below will establish the baseline instead.
echo "Re-baselining issue snapshot from live API..."
if STARTUP_ISSUES=$(fetch_open_issues 2>/dev/null) && jq -e 'type == "array"' > /dev/null <<<"$STARTUP_ISSUES"; then
    write_issue_snapshot "$STARTUP_ISSUES"
    BASELINED=1
    echo "Baseline established: $(jq 'length' <<<"$STARTUP_ISSUES") open issue(s) tracked in $SNAPSHOT_FILE"
else
    echo "Warning: startup baseline fetch failed; first successful poll will establish the baseline"
fi

echo "=== Long-Running Orchestrator Started ==="
echo "Repository: $OWNER/$REPO"
echo "Poll interval (issues): ${INTERVAL} seconds"
echo "Poll interval (PR health): ${PR_INTERVAL} seconds"
echo "State file: $STATE_FILE"
echo "Processed issues file: $PROCESSED_FILE"
echo "Issue snapshot file: $SNAPSHOT_FILE"
echo "PR health file: $PR_HEALTH_FILE"
echo "Press Ctrl+C to stop"
echo ""

# Trap Ctrl+C to exit gracefully
trap 'echo ""; echo "=== Orchestrator stopped ==="; exit 0' INT

# Main polling loop
while true; do
    echo "[heartbeat] $(date -u '+%Y-%m-%dT%H:%M:%SZ') issue poll cycle"

    # Fetch open issues; skip the cycle on failure (never treat errors as "no issues")
    if ISSUES=$(fetch_open_issues 2>/dev/null) && jq -e 'type == "array"' > /dev/null <<<"$ISSUES"; then
        # Read previous snapshot; missing/corrupt snapshot means "needs baseline"
        OLD='{}'
        HAS_SNAPSHOT=0
        if [ "$BASELINED" -eq 1 ] && [ -f "$SNAPSHOT_FILE" ]; then
            PARSED=$(jq -c '.issues // empty' "$SNAPSHOT_FILE" 2>/dev/null || true)
            if [ -n "$PARSED" ] && jq -e 'type == "object"' > /dev/null <<<"$PARSED"; then
                OLD="$PARSED"
                HAS_SNAPSHOT=1
            fi
        fi

        if [ "$HAS_SNAPSHOT" -eq 0 ]; then
            # Establish/re-establish baseline; report no deltas this cycle
            write_issue_snapshot "$ISSUES"
            BASELINED=1
            echo "[heartbeat] baseline established: $(jq 'length' <<<"$ISSUES") open issue(s) tracked in $SNAPSHOT_FILE"
        else
            DELTAS=$(compute_issue_deltas "$OLD" "$ISSUES")
            NEW_N=$(jq '.new | length' <<<"$DELTAS")
            CHG_N=$(jq '.changed | length' <<<"$DELTAS")
            CLS_N=$(jq '.closed | length' <<<"$DELTAS")
            ISSUE_COUNT=$(jq 'length' <<<"$ISSUES")

            echo "[heartbeat] issues: $ISSUE_COUNT open | +$NEW_N new ~$CHG_N changed -$CLS_N closed"

            # Report deltas so the orchestrator wakes to act
            jq -r '.new[]     | "New issue detected: #\(.number) - \(.title)"' <<<"$DELTAS"
            jq -r '.changed[] | "Issue updated (re-triage): #\(.number) - \(.title)"' <<<"$DELTAS"
            jq -r '.closed[]  | "Issue closed: #\(.number) - \(.title)"' <<<"$DELTAS"

            # Record newly-seen issue numbers for backward compatibility with
            # consumers of .processed-issues.txt, and skip issues that already
            # have an active subagent.
            jq -r '.new[].number' <<<"$DELTAS" | while read -r issue_num; do
                if jq -e ".active_subagents[] | select(.issue_number == $issue_num)" "$STATE_FILE" > /dev/null 2>&1; then
                    echo "Issue #$issue_num already has an active subagent; skipping spawn"
                    continue
                fi
                echo "$issue_num" >> "$PROCESSED_FILE"
                echo "TODO: Create worktree and spawn subagent for issue #$issue_num"
                # This is where the orchestrator would:
                # 1. Create a worktree at .worktrees/issue-$issue_num
                # 2. Create a branch feature/issue-$issue_num-description
                # 3. Launch a subagent with the issue details
                # 4. Add to active_subagents in state file
                # 5. Notify via Slack
            done

            # Persist the new snapshot only after a successful fetch+diff
            write_issue_snapshot "$ISSUES"
        fi
    else
        echo "[heartbeat] $(date -u '+%Y-%m-%dT%H:%M:%SZ') WARNING: issue fetch failed or returned non-JSON; skipping issue check (snapshot preserved)"
    fi
    
    # Poll PR health (merge conflicts, failing checks, failed deployments)
    # on its own interval, less frequent than issue polling by default
    NOW=$(date +%s)
    if [ $((NOW - LAST_PR_POLL)) -ge "$PR_INTERVAL" ]; then
        echo "[heartbeat] $(date -u '+%Y-%m-%dT%H:%M:%SZ') PR health poll"
        if [ -x "$SCRIPT_DIR/check-pr-health.sh" ]; then
            # Write to a temp file first; a failed check must not be
            # indistinguishable from "no PR health issues".
            if "$SCRIPT_DIR/check-pr-health.sh" "$OWNER" "$REPO" > "$PR_HEALTH_FILE.tmp" 2>/dev/null \
                && jq -e 'type == "object"' > /dev/null < "$PR_HEALTH_FILE.tmp"; then
                mv "$PR_HEALTH_FILE.tmp" "$PR_HEALTH_FILE"
            else
                rm -f "$PR_HEALTH_FILE.tmp"
                echo "Warning: PR health check failed; keeping previous $PR_HEALTH_FILE"
            fi
            if [ -f "$PR_HEALTH_FILE" ]; then
                CONFLICT_COUNT=$(jq '.conflicts | length' "$PR_HEALTH_FILE" 2>/dev/null || echo 0)
                CHECK_COUNT=$(jq '.failing_checks | length' "$PR_HEALTH_FILE" 2>/dev/null || echo 0)
                DEPLOY_COUNT=$(jq '.failed_deployments | length' "$PR_HEALTH_FILE" 2>/dev/null || echo 0)
                echo "PR health: $CONFLICT_COUNT conflicts, $CHECK_COUNT failing checks, $DEPLOY_COUNT failed deployments"
                if [ "$((CONFLICT_COUNT + CHECK_COUNT + DEPLOY_COUNT))" -gt 0 ]; then
                    echo "PR health issues detected - see $PR_HEALTH_FILE"
                    echo "TODO: Spawn a single PR-maintenance subagent (see pr-maintenance-prompt-template.md) if one is not already running"
                fi
            fi
        else
            echo "Warning: check-pr-health.sh not found or not executable in $SCRIPT_DIR"
        fi
        LAST_PR_POLL=$NOW
        jq --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '.last_pr_health_poll = $time' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
    fi

    # Update last poll time
    jq --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '.last_poll = $time' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
    
    echo "Next poll in ${INTERVAL} seconds..."
    sleep "$INTERVAL"
done
