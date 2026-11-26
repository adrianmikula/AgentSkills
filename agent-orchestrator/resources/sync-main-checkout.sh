#!/bin/bash
# Fast-forward the primary (main) checkout to its upstream after a merge,
# so running dev servers pick up the newly merged code.
#
# Usage: ./sync-main-checkout.sh [--path <dir>] [--remote <name>] [--allow-diverged] [-h|--help]
#
# Defaults:
#   --path    Primary checkout directory. Defaults to the main worktree of
#             the repository containing the current directory.
#   --remote  Remote name. Defaults to the branch's configured remote,
#             falling back to "origin".
#
# Safe by default:
#   - Never force-pushes, resets, cleans, or discards uncommitted work.
#   - Uses `git pull --ff-only --autostash` so dirty trees are stashed and
#     restored automatically, and non-fast-forward updates are refused.
#   - Aborts on a detached HEAD (check out a branch first).
#   - Aborts when the local branch has diverged from upstream unless
#     --allow-diverged is passed (then pulls with --no-rebase, creating a
#     merge commit; history is never rewritten).

set -euo pipefail

usage() {
    sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
    exit "${1:-0}"
}

TARGET="."
REMOTE=""
ALLOW_DIVERGED=0

while [ $# -gt 0 ]; do
    case "$1" in
        --path)
            TARGET="${2:?--path requires a directory}"
            shift 2
            ;;
        --remote)
            REMOTE="${2:?--remote requires a name}"
            shift 2
            ;;
        --allow-diverged)
            ALLOW_DIVERGED=1
            shift
            ;;
        -h|--help)
            usage 0
            ;;
        *)
            echo "Error: unknown argument '$1'" >&2
            usage 1
            ;;
    esac
done

if [ ! -d "$TARGET" ]; then
    echo "Error: '$TARGET' is not a directory." >&2
    exit 1
fi

# Resolve the main (primary) worktree of the target repository.
MAIN_WORKTREE=$(git -C "$TARGET" worktree list --porcelain 2>/dev/null \
    | sed -n 's/^worktree //p' | head -n 1)
if [ -z "$MAIN_WORKTREE" ]; then
    echo "Error: '$TARGET' is not inside a git repository." >&2
    exit 1
fi

cd "$MAIN_WORKTREE"

echo "=== Syncing primary checkout: $MAIN_WORKTREE ==="

# Refuse to operate on a detached HEAD: there is no branch to fast-forward.
if ! git symbolic-ref -q HEAD >/dev/null; then
    echo "Error: primary checkout is on a detached HEAD." >&2
    echo "Check out a branch (e.g. 'git switch main') and re-run." >&2
    exit 1
fi

BRANCH=$(git symbolic-ref --short -q HEAD)

if ! UPSTREAM=$(git rev-parse --abbrev-ref --symbolic-full-name '@{u}' 2>/dev/null); then
    echo "Error: branch '$BRANCH' has no upstream configured." >&2
    exit 1
fi

CONFIG_REMOTE=$(git config --get "branch.$BRANCH.remote" || true)
REMOTE=${REMOTE:-${CONFIG_REMOTE:-origin}}

git fetch --prune "$REMOTE"

read -r AHEAD BEHIND <<< "$(git rev-list --left-right --count "HEAD...@{u}")"
echo "Branch: $BRANCH  upstream: $UPSTREAM  (ahead: $AHEAD, behind: $BEHIND)"

if [ "$BEHIND" -eq 0 ]; then
    echo "Already up to date."
    git rev-parse --short HEAD
    exit 0
fi

if [ "$AHEAD" -gt 0 ] && [ "$BEHIND" -gt 0 ]; then
    if [ "$ALLOW_DIVERGED" -ne 1 ]; then
        echo "Error: '$BRANCH' has diverged from upstream ($AHEAD local, $BEHIND remote)." >&2
        echo "Aborting to avoid a merge/rebase you did not ask for." >&2
        echo "Re-run with --allow-diverged to merge upstream into the branch," >&2
        echo "or resolve manually in $MAIN_WORKTREE." >&2
        exit 1
    fi
    echo "Diverged ($AHEAD local, $BEHIND remote); merging upstream with --allow-diverged."
    git pull --autostash --no-rebase "$REMOTE" "$BRANCH"
else
    git pull --autostash --ff-only "$REMOTE" "$BRANCH"
fi

# Verify the sync: HEAD must now equal upstream.
LOCAL_HEAD=$(git rev-parse HEAD)
UPSTREAM_HEAD=$(git rev-parse '@{u}')
if [ "$LOCAL_HEAD" != "$UPSTREAM_HEAD" ]; then
    echo "Error: sync did not converge; HEAD=$LOCAL_HEAD upstream=$UPSTREAM_HEAD" >&2
    echo "The stash (if any) was restored. Inspect $MAIN_WORKTREE manually." >&2
    exit 1
fi

echo "=== Sync complete ==="
git status -sb
git log -1 --oneline
