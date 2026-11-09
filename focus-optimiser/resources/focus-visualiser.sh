#!/usr/bin/env bash
set -euo pipefail

TASK_FILE=".focus/task-graph.tsv"
TODAY_FILE=".focus/today.md"
FORMAT="ascii"
TODAY_ONLY=false

usage() {
  cat <<'EOF'
Usage: focus-visualiser.sh [OPTIONS]

Options:
  -f, --file FILE      TSV task file (default: .focus/task-graph.tsv)
  -t, --today          Show only tasks listed in .focus/today.md
  -F, --format FORMAT  Output format: ascii | mermaid (default: ascii)
  -h, --help           Show this message

The TSV file must have a header row and these columns:
  id\ttitle\tproject\tstatus\tscore\teffort\tdue\tdeps
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -f|--file) TASK_FILE="$2"; shift 2 ;;
    -t|--today) TODAY_ONLY=true; shift ;;
    -F|--format) FORMAT="$2"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 1 ;;
  esac
done

if [[ ! -f "$TASK_FILE" ]]; then
  echo "Task file not found: $TASK_FILE" >&2
  exit 1
fi

# Load today IDs if requested
TODAY_IDS=""
if [[ "$TODAY_ONLY" == true ]]; then
  if [[ -f "$TODAY_FILE" ]]; then
    TODAY_IDS=$(sed -n 's/^[[:space:]]*Selected:[[:space:]]*//p' "$TODAY_FILE" 2>/dev/null | tr ',' '\n' | grep -oE '[0-9]+' | sort -u | paste -sd ' ' -) || true
    if [[ -z "$TODAY_IDS" ]]; then
      echo "No selected task IDs found in $TODAY_FILE" >&2
      exit 0
    fi
  else
    echo "Focus mode file not found: $TODAY_FILE" >&2
    exit 1
  fi
fi

print_ascii() {
  echo "Focus-optimiser visualiser"
  echo "=========================="

  awk -F'\t' -v today="$TODAY_IDS" '
  function in_today(i) {
    if (today == "") return 1;
    split(today, arr, " ");
    for (x in arr) if (arr[x] == i) return 1;
    return 0;
  }
  NR == 1 { next }
  {
    id = $1; title = $2; project = $3; status = $4; score = $5; effort = $6; due = $7; deps = $8;
    if (!in_today(id)) next;
    printf "[%s] %s (score=%s, effort=%sh, due=%s, deps=%s)\n", project, title, score, effort, due, deps;
  }' "$TASK_FILE"

  echo ""
  echo "Projected timeline (earliest -> due):"
  awk -F'\t' -v today="$TODAY_IDS" '
  function in_today(i) {
    if (today == "") return 1;
    split(today, arr, " ");
    for (x in arr) if (arr[x] == i) return 1;
    return 0;
  }
  NR == 1 { next }
  {
    id = $1; title = $2; project = $3; status = $4; score = $5; effort = $6; due = $7;
    if (!in_today(id) || due == "") next;
    print title " | due " due " | effort " effort "h";
  }' "$TASK_FILE" | sort -k3
}

print_mermaid() {
  echo '```mermaid'
  echo 'graph TD'

  awk -F'\t' -v today="$TODAY_IDS" '
  function in_today(i) {
    if (today == "") return 1;
    split(today, arr, " ");
    for (x in arr) if (arr[x] == i) return 1;
    return 0;
  }
  NR == 1 { next }
  {
    id = $1; title = $2; status = $4;
    if (!in_today(id)) next;
    printf "  %s[%s]\n", id, title;
  }' "$TASK_FILE"

  awk -F'\t' -v today="$TODAY_IDS" '
  function in_today(i) {
    if (today == "") return 1;
    split(today, arr, " ");
    for (x in arr) if (arr[x] == i) return 1;
    return 0;
  }
  NR == 1 { next }
  {
    id = $1; deps = $8;
    if (!in_today(id) || deps == "") next;
    split(deps, d, ",");
    for (i in d) {
      d[i] = d[i] + 0;
      if (d[i] > 0) printf "  %s --> %s\n", d[i], id;
    }
  }' "$TASK_FILE"

  echo "  classDef blocked fill:#f77,stroke:#333;"
  echo "  classDef inprogress fill:#fd7,stroke:#333;"
  echo "  classDef complete fill:#7f7,stroke:#333;"
  echo "  classDef notstarted fill:#eee,stroke:#333;"

  awk -F'\t' -v today="$TODAY_IDS" '
  function in_today(i) {
    if (today == "") return 1;
    split(today, arr, " ");
    for (x in arr) if (arr[x] == i) return 1;
    return 0;
  }
  NR == 1 { next }
  {
    id = $1; status = $4;
    if (!in_today(id)) next;
    gsub(/ /, "", status);
    if (status == "blocked") cls = "blocked";
    else if (status == "inprogress") cls = "inprogress";
    else if (status == "complete") cls = "complete";
    else cls = "notstarted";
    printf "  class %s %s;\n", id, cls;
  }' "$TASK_FILE"

  echo '```'
}

case "$FORMAT" in
  ascii) print_ascii ;;
  mermaid) print_mermaid ;;
  *) echo "Unknown format: $FORMAT" >&2; usage >&2; exit 1 ;;
esac
