#!/bin/bash
# Long-running orchestrator that polls for new GitHub issues every 5 minutes
# Usage: ./long-running-orchestrator.sh <owner> <repo> [interval-seconds]
# Default interval: 300 seconds (5 minutes)

set -e

OWNER=$1
REPO=$2
INTERVAL=${3:-300}

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
    echo "Usage: $0 <owner> <repo> [interval-seconds]"
    echo "Example: $0 adrianmikula AgentSkills 300"
    exit 1
fi

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

# Initialize state file if it doesn't exist
if [ ! -f "$STATE_FILE" ]; then
    echo '{"active_subagents": [], "last_poll": null, "processed_issues": []}' > "$STATE_FILE"
fi

# Initialize processed issues file if it doesn't exist
if [ ! -f "$PROCESSED_FILE" ]; then
    touch "$PROCESSED_FILE"
fi

echo "=== Long-Running Orchestrator Started ==="
echo "Repository: $OWNER/$REPO"
echo "Poll interval: ${INTERVAL} seconds"
echo "State file: $STATE_FILE"
echo "Processed issues file: $PROCESSED_FILE"
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
    
    # Update last poll time
    jq --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '.last_poll = $time' "$STATE_FILE" > "$STATE_FILE.tmp" && mv "$STATE_FILE.tmp" "$STATE_FILE"
    
    echo "Next poll in ${INTERVAL} seconds..."
    sleep "$INTERVAL"
done
