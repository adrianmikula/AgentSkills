#!/bin/bash
# Clean up old git worktrees
# Usage: ./cleanup-worktrees.sh [repo-path] [days-old]
# Default repo path: current directory
# Default days old: 7

set -e

REPO_PATH=${1:-.}
DAYS_OLD=${2:-7}

if [ ! -d "$REPO_PATH/.git" ]; then
    echo "Error: '$REPO_PATH' is not a git repository."
    exit 1
fi

cd "$REPO_PATH"

echo "=== Cleaning up worktrees older than $DAYS_OLD days ==="

# List all worktrees
git worktree list --porcelain | grep "^worktree " | cut -d' ' -f2- | while read -r worktree_path; do
    # Skip the main worktree
    if [ "$worktree_path" = "$(pwd)" ]; then
        continue
    fi
    
    # Check if worktree exists
    if [ -d "$worktree_path" ]; then
        # Get last modification time
        LAST_MODIFIED=$(stat -c %Y "$worktree_path" 2>/dev/null || echo 0)
        CURRENT_TIME=$(date +%s)
        AGE_DAYS=$(( (CURRENT_TIME - LAST_MODIFIED) / 86400 ))
        
        if [ $AGE_DAYS -ge $DAYS_OLD ]; then
            echo "Removing old worktree: $worktree_path (age: ${AGE_DAYS} days)"
            git worktree remove "$worktree_path" --force || echo "Failed to remove $worktree_path"
        else
            echo "Keeping worktree: $worktree_path (age: ${AGE_DAYS} days)"
        fi
    fi
done

# Prune worktree metadata
echo "Pruning worktree metadata..."
git worktree prune

echo "=== Cleanup complete ==="
