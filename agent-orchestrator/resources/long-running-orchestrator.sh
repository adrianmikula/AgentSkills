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
LAST_PR_POLL=0

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo '{"active_subagents": [], "last_poll": null, "processed_issues": [], "pr_maintenance_agent": null}' > "$STATE_FILE"
fi

# Initialize processed issues file if it doesn't exist
if [ ! -f "$PROCESSED_FILE" ]; then
    touch "$PROCESSED_FILE"
fi

echo "=== Long-Running Orchestrator Started ==="
echo "Repository: $OWNER/$REPO"
echo "Poll interval (issues): ${INTERVAL} seconds"
echo "Poll interval (PR health): ${PR_INTERVAL} seconds"
echo "State file: $STATE_FILE"
echo "Processed issues file: $PROCESSED_FILE"
echo "PR health file: $PR_HEALTH_FILE"
echo "Press Ctrl+C to stop"
echo ""

# Trap Ctrl+C to exit gracefully
trap 'echo ""; echo "=== Orchestrator stopped ==="; exit 0' INT

# Main polling loop
while true; do
    echo "=== Poll at $(date) ==="
    
    # Fetch open issues
    ISSUES=$(gh issue list --repo "$OWNER/$REPO" --state open --json number,title,labels,assignees,createdAt --limit 50 2>/dev/null || echo "[]")
    
    # Parse issues and check for new ones
    echo "$ISSUES" | jq -r '.[] | "\(.number)|\(.title)"' 2>/dev/null | while IFS='|' read -r issue_num issue_title; do
        # Skip if already processed
        if grep -q "^$issue_num$" "$PROCESSED_FILE" 2>/dev/null; then
            continue
        fi
        
        # Check if already in active subagents
        if jq -e ".active_subagents[] | select(.issue_number == $issue_num)" "$STATE_FILE" > /dev/null 2>&1; then
            continue
        fi
        
        echo "New issue detected: #$issue_num - $issue_title"
        echo "Add to processed issues file: $issue_num"
        echo "$issue_num" >> "$PROCESSED_FILE"
        
        # TODO: Create worktree and spawn subagent
        # This is where the orchestrator would:
        # 1. Create a worktree at .worktrees/issue-$issue_num
        # 2. Create a branch feature/issue-$issue_num-description
        # 3. Launch a subagent with the issue details
        # 4. Add to active_subagents in state file
        # 5. Notify via Slack
        
        echo "TODO: Implement subagent spawning logic"
    done
    
    # Poll PR health (merge conflicts, failing checks, failed deployments)
    # on its own interval, less frequent than issue polling by default
    NOW=$(date +%s)
    if [ $((NOW - LAST_PR_POLL)) -ge "$PR_INTERVAL" ]; then
        echo "--- PR health poll at $(date) ---"
        if [ -x "$SCRIPT_DIR/check-pr-health.sh" ]; then
            "$SCRIPT_DIR/check-pr-health.sh" "$OWNER" "$REPO" > "$PR_HEALTH_FILE" 2>/dev/null || echo '{"conflicts":[],"failing_checks":[],"failed_deployments":[]}' > "$PR_HEALTH_FILE"
            CONFLICT_COUNT=$(jq '.conflicts | length' "$PR_HEALTH_FILE" 2>/dev/null || echo 0)
            CHECK_COUNT=$(jq '.failing_checks | length' "$PR_HEALTH_FILE" 2>/dev/null || echo 0)
            DEPLOY_COUNT=$(jq '.failed_deployments | length' "$PR_HEALTH_FILE" 2>/dev/null || echo 0)
            echo "PR health: $CONFLICT_COUNT conflicts, $CHECK_COUNT failing checks, $DEPLOY_COUNT failed deployments"
            if [ "$((CONFLICT_COUNT + CHECK_COUNT + DEPLOY_COUNT))" -gt 0 ]; then
                echo "PR health issues detected - see $PR_HEALTH_FILE"
                echo "TODO: Spawn a single PR-maintenance subagent (see pr-maintenance-prompt-template.md) if one is not already running"
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
