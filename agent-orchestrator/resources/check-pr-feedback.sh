#!/bin/bash
# Check open pull requests for new human feedback: issue comments and PR
# reviews submitted since the last poll. Read-only (GitHub API GETs only).
# Usage: ./check-pr-feedback.sh <owner> <repo> [state-file]
#
# Output: JSON object on stdout, e.g.:
#   {
#     "issue_comments": [{"pr_number":123,"pr_title":"...","headRefName":"...","comment_id":456,"author":"alice","created_at":"...","url":"...","body_preview":"..."}],
#     "reviews": [{"pr_number":123,"pr_title":"...","headRefName":"...","review_id":789,"state":"CHANGES_REQUESTED","author":"alice","submitted_at":"...","url":"...","body_preview":"..."}]
#   }
# Both arrays are empty when there is no new feedback.
#
# Human-only filter: bot authors are excluded (user.type == "Bot" or login
# ending in "[bot]"), so CI bots and GitHub Actions never create work items.
# Filtering is by created_at/submitted_at (not updated_at), so editing an old
# comment does not re-report it; the ?since= API param is only used to reduce
# payload size.
#
# State file: last-seen markers are stored per PR under the top-level
# "pr_feedback_seen" object ("<pr_number>": "<iso8601 timestamp>") and the
# poll time under "last_pr_feedback_poll". The state file is created if it
# does not exist; existing keys are preserved. Markers advance only to
# timestamps actually observed, so feedback submitted mid-poll is still
# caught on the next run. PRs with no new feedback keep their previous
# marker. Reviews are re-scanned each poll because the GitHub reviews
# endpoint does not support "since".
#
# Orchestrator routing (see Skill.md Phase 6 and resources/README.md):
# detected feedback items are work items routed to a follow-up agent on the
# SAME PR branch (never a new PR, never a force-push). Deduplicate with the
# PR-maintenance agent rules: at most one maintenance/follow-up agent at a
# time, and never re-assign feedback for a PR that already has an active
# follow-up agent.

set -e

OWNER=$1
REPO=$2
STATE_FILE=${3:-.orchestrator-state.json}

if [ -z "$OWNER" ] || [ -z "$REPO" ]; then
    echo "Usage: $0 <owner> <repo> [state-file]" >&2
    echo "Example: $0 adrianmikula AgentSkills .orchestrator-state.json" >&2
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

NOW=$(date -u +%Y-%m-%dT%H:%M:%SZ)

# Load last-seen markers per PR (empty object on first run / missing file)
if [ -f "$STATE_FILE" ]; then
    SEEN=$(jq '.pr_feedback_seen // {}' "$STATE_FILE")
else
    SEEN='{}'
fi

# Fetch open PRs
PRS=$(gh pr list --repo "$OWNER/$REPO" --state open --limit 100 \
    --json number,title,headRefName,createdAt)

COMMENTS_FILE=$(mktemp)
REVIEWS_FILE=$(mktemp)
trap 'rm -f "$COMMENTS_FILE" "$REVIEWS_FILE"' EXIT

echo "[]" > "$COMMENTS_FILE"
echo "[]" > "$REVIEWS_FILE"

# Iterate PR numbers without a subshell so we can accumulate results.
for pr_number in $(echo "$PRS" | jq -r '.[].number'); do
    PR_INFO=$(echo "$PRS" | jq --argjson n "$pr_number" '.[] | select(.number == $n)')
    PR_TITLE=$(echo "$PR_INFO" | jq -r '.title')
    HEAD_REF=$(echo "$PR_INFO" | jq -r '.headRefName')
    PR_CREATED=$(echo "$PR_INFO" | jq -r '.createdAt')

    # Last-seen marker for this PR; fall back to PR creation time on first sight
    MARKER=$(echo "$SEEN" | jq -r --argjson n "$pr_number" '.[$n | tostring] // empty')
    SINCE=${MARKER:-$PR_CREATED}

    # --- Issue comments (endpoint supports ?since= to shrink payload) ---
    RAW_COMMENTS=$(gh api "repos/$OWNER/$REPO/issues/$pr_number/comments?since=$SINCE&per_page=100" \
        2>/dev/null || echo "[]")
    NEW_COMMENTS=$(echo "$RAW_COMMENTS" | jq --arg since "$SINCE" \
        --argjson n "$pr_number" --arg t "$PR_TITLE" --arg h "$HEAD_REF" \
        '[.[] | select((.user.type // "") != "Bot"
                      and (((.user.login // "") | endswith("[bot]")) | not)
                      and ((.created_at // "") > $since))
         | {pr_number: $n, pr_title: $t, headRefName: $h,
                  comment_id: .id, author: .user.login, created_at,
                  url: .html_url, body_preview: ((.body // "") | .[0:200])}]' 2>/dev/null || echo "[]")

    if [ "$(echo "$NEW_COMMENTS" | jq 'length')" -gt 0 ]; then
        ACCUM=$(mktemp)
        jq --argjson e "$NEW_COMMENTS" '. + $e' "$COMMENTS_FILE" > "$ACCUM" && mv "$ACCUM" "$COMMENTS_FILE"
    fi

    # --- PR reviews (no since param; filter client-side) ---
    RAW_REVIEWS=$(gh api "repos/$OWNER/$REPO/pulls/$pr_number/reviews?per_page=100" \
        2>/dev/null || echo "[]")
    NEW_REVIEWS=$(echo "$RAW_REVIEWS" | jq --arg since "$SINCE" \
        --argjson n "$pr_number" --arg t "$PR_TITLE" --arg h "$HEAD_REF" \
        '[.[] | select(.state != "PENDING"
                      and ((.user.type // "") != "Bot")
                      and (((.user.login // "") | endswith("[bot]")) | not)
                      and ((.submitted_at // "") > $since)
                      and (((.body // "") != "") or .state == "CHANGES_REQUESTED"))
         | {pr_number: $n, pr_title: $t, headRefName: $h,
                  review_id: .id, state, author: .user.login, submitted_at,
                  url: .html_url, body_preview: ((.body // "") | .[0:200])}]' 2>/dev/null || echo "[]")

    if [ "$(echo "$NEW_REVIEWS" | jq 'length')" -gt 0 ]; then
        ACCUM=$(mktemp)
        jq --argjson e "$NEW_REVIEWS" '. + $e' "$REVIEWS_FILE" > "$ACCUM" && mv "$ACCUM" "$REVIEWS_FILE"
    fi
done

# De-duplicate defensively (a comment/review should only ever appear once)
COMMENTS=$(jq 'unique_by(.comment_id)' "$COMMENTS_FILE")
REVIEWS=$(jq 'unique_by(.review_id)' "$REVIEWS_FILE")

# Feedback timestamps per PR, used to advance last-seen markers.
FB_TS=$(jq -n --argjson c "$COMMENTS" --argjson r "$REVIEWS" \
    '[$c[] | {pr: (.pr_number | tostring), ts: .created_at}]
     + [$r[] | {pr: (.pr_number | tostring), ts: .submitted_at}]')

# Build the new seen map: every open PR gets a marker (falling back to its
# creation time), advanced to the newest observed feedback timestamp and
# never regressed. Closed/merged PRs drop out of the map naturally.
NEW_SEEN=$(jq -n --argjson seen "$SEEN" --argjson fb "$FB_TS" --argjson prs "$PRS" '
    reduce ($fb[] | {key: .pr, value: .ts}) as $e ($seen;
        .[$e.key] = ([.[$e.key] // "", $e.value]
                     | map(select(type == "string" and . != ""))
                     | max // (.[$e.key] // "")))
    | . as $m
    | reduce ($prs[] | {key: (.number | tostring), value: .createdAt}) as $e ($m;
        .[$e.key] = ([.[$e.key] // "", $e.value]
                     | map(select(type == "string" and . != ""))
                     | max // (.[$e.key] // "")))
    | with_entries(select(.value != ""))')

# Persist markers + poll timestamp back to the state file (create if missing,
# preserve all existing keys, write atomically).
if [ -f "$STATE_FILE" ]; then
    TMP=$(mktemp)
    jq --argjson seen "$NEW_SEEN" --arg now "$NOW" \
        '.pr_feedback_seen = $seen | .last_pr_feedback_poll = $now' \
        "$STATE_FILE" > "$TMP" && mv "$TMP" "$STATE_FILE"
else
    jq -n --argjson seen "$NEW_SEEN" --arg now "$NOW" \
        '{pr_feedback_seen: $seen, last_pr_feedback_poll: $now}' > "$STATE_FILE"
fi

# Emit result JSON
jq -n --argjson comments "$COMMENTS" --argjson reviews "$REVIEWS" \
    '{issue_comments: $comments, reviews: $reviews}'
