#!/bin/bash
# Append a timestamped event to the orchestrator event log (JSON Lines)
# Usage: ./log-event.sh <type> <message> [details-json]
#   type:    detection | action | error
#   message: human-readable description of what happened
#   details: optional JSON object with extra context (e.g. issue/PR numbers); defaults to {}
# Event log file: .orchestrator-events.log (override with ORCHESTRATOR_EVENTS_LOG env var)
# The log is append-only: never rewrite, truncate, or rotate it manually.

set -e

TYPE=$1
MESSAGE=$2
DETAILS=${3:-"{}"}

if [ -z "$TYPE" ] || [ -z "$MESSAGE" ]; then
    echo "Usage: $0 <type> <message> [details-json]"
    echo "  type: detection | action | error"
    echo "Example: $0 detection 'new issue detected' '{\"issue\": 42}'"
    exit 1
fi

case "$TYPE" in
    detection|action|error) ;;
    *)
        echo "Error: Invalid event type '$TYPE'. Must be one of: detection, action, error"
        exit 1
        ;;
esac

# Check if jq is installed (used for safe JSON escaping)
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it first."
    exit 1
fi

LOG_FILE=${ORCHESTRATOR_EVENTS_LOG:-.orchestrator-events.log}

# Validate details is valid JSON before appending
if ! echo "$DETAILS" | jq -e . &> /dev/null; then
    echo "Error: details must be valid JSON (got: $DETAILS)"
    exit 1
fi

# Build the event record and append it atomically-ish (single printf + jq)
EVENT=$(jq -nc \
    --arg timestamp "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg type "$TYPE" \
    --arg message "$MESSAGE" \
    --argjson details "$DETAILS" \
    '{timestamp: $timestamp, type: $type, message: $message, details: $details}')

echo "$EVENT" >> "$LOG_FILE"
