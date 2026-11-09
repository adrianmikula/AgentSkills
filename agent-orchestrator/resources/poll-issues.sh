#!/bin/bash
# Poll GitHub issues for a repository
# Usage: ./poll-issues.sh <owner> <repo> [state]
# Default state: open

set -e

OWNER=$1
REPO=$2
STATE=${3:-open}

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
    echo "Usage: $0 <owner> <repo> [state]"
    echo "Example: $0 adrianmikula AgentSkills open"
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

# Poll issues every 60 seconds
while true; do
    echo "=== Polling issues for $OWNER/$REPO (state: $STATE) at $(date) ==="
    
    # Fetch issues
    gh issue list --repo "$OWNER/$REPO" --state "$STATE" --json number,title,labels,assignees,createdAt,updatedAt --limit 50
    
    echo "=== Poll complete. Next poll in 60 seconds ==="
    sleep 60
done
