#!/bin/bash
# Clean up old git worktrees
# Usage: ./cleanup-worktrees.sh [repo-path] [days-old]
# Default repo path: current directory
# Default days old: 7
#
# Safety: a worktree is only removed when its checked-out branch has been
# verified to contain zero unpushed commits. Verification:
#   - If the branch has an upstream: `git log origin/<branch>..<branch>` must be empty
#   - Otherwise: the branch tip must already be merged into origin/HEAD (origin/main)
#   - Detached HEAD or any verification failure => worktree is kept (fail-safe)

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
        
        if [ "$AGE_DAYS" -ge "$DAYS_OLD" ]; then
            # Verify-before-reclaim: confirm zero unpushed commits before removing
            BRANCH=$(git -C "$worktree_path" rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
            SAFE_TO_REMOVE=0
            if [ -z "$BRANCH" ] || [ "$BRANCH" = "HEAD" ]; then
                echo "Keeping worktree: $worktree_path (detached HEAD; cannot verify unpushed commits)"
                continue
            fi
            UPSTREAM=$(git -C "$worktree_path" rev-parse --abbrev-ref --symbolic-full-name '@{upstream}' 2>/dev/null || echo "")
            if [ -n "$UPSTREAM" ]; then
                UNPUSHED=$(git -C "$worktree_path" rev-list --count "$UPSTREAM..HEAD" 2>/dev/null || echo "")
                if [ "$UNPUSHED" = "0" ]; then
                    SAFE_TO_REMOVE=1
                else
                    echo "Keeping worktree: $worktree_path (branch '$BRANCH' has $UNPUSHED unpushed commit(s) vs $UPSTREAM)"
                fi
            else
                # No upstream: safe only if branch tip is already merged into origin/HEAD
                DEFAULT_REMOTE=$(git -C "$worktree_path" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null || echo "origin/main")
                if git -C "$worktree_path" merge-base --is-ancestor HEAD "$DEFAULT_REMOTE" 2>/dev/null; then
                    SAFE_TO_REMOVE=1
                else
                    echo "Keeping worktree: $worktree_path (branch '$BRANCH' has no upstream and is not merged into $DEFAULT_REMOTE)"
                fi
            fi
            if [ "$SAFE_TO_REMOVE" -eq 1 ]; then
                echo "Removing old worktree: $worktree_path (age: ${AGE_DAYS} days; verified zero unpushed commits on '$BRANCH')"
                git worktree remove "$worktree_path" --force || echo "Failed to remove $worktree_path"
            fi
        else
            echo "Keeping worktree: $worktree_path (age: ${AGE_DAYS} days)"
        fi
    fi
done

# Prune worktree metadata
echo "Pruning worktree metadata..."
git worktree prune

echo "=== Cleanup complete ==="
