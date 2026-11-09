#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT"

mkdir -p .focus

TSV=".focus/task-graph.tsv"
id=1

cat > .focus/config.md <<'EOF'
# Focus Config

- **auto_sync:** true
- **focus_mode_auto:** false
- **focus_mode_size:** 5
EOF

printf 'id\ttitle\tproject\tstatus\tscore\teffort\tdue\tdeps\n' > "$TSV"

append() {
  local title="$1" project="$2" score="$3"
  title=$(printf '%s' "$title" | tr '\n\t' '  ' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  [[ -z "$title" ]] && return
  title=$(printf '%s' "$title" | tr '\t' ' ')
  printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$id" "$title" "$project" "notstarted" "$score" "1" "" "" >> "$TSV"
  id=$((id + 1))
}

# --- Business Idea Incubator ---
for f in .ideas/ideas/*.md; do
  [[ ! -f "$f" ]] && continue
  idea=$(sed -n 's/^# //p' "$f" | head -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  [[ -z "$idea" ]] && continue

  immediate=$(awk 'BEGIN{RS=""; FS="\n"} /\*\*Immediate Next Action:\*\*/ {for (i=2; i<=NF; i++) if ($i ~ /[^[:space:]]/) {gsub(/^[[:space:]]*[-*][[:space:]]*/, "", $i); gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i); if ($i) print $i; exit}}' "$f" | head -1)
  [[ -n "$immediate" ]] && append "$immediate" "$idea" 90

  current=$(awk 'BEGIN{RS=""; FS="\n"} /^## Current Focus/ {for (i=2; i<=NF; i++) if ($i ~ /[^[:space:]]/ && $i !~ /^#/ && $i !~ /^\*\*/) {gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i); if ($i) print $i; exit}}' "$f" | head -1)
  [[ -n "$current" && "$current" != "$immediate" ]] && append "$current" "$idea" 80

  while IFS= read -r line; do
    [[ -n "$line" ]] && append "$line" "$idea" 70
  done < <(awk 'BEGIN{RS=""; FS="\n"} /\*\*Missing \/ Next Gate:\*\*/ {for (i=2; i<=NF; i++) if ($i ~ /^[[:space:]]*[-*][[:space:]]/ || $i ~ /^[[:space:]]+[A-Za-z]/) {gsub(/^[[:space:]]*[-*][[:space:]]*/, "", $i); gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i); if ($i) print $i}}' "$f")

  while IFS= read -r line; do
    [[ -n "$line" ]] && append "$line" "$idea" 60
  done < <(awk 'BEGIN{RS=""; FS="\n"} /\*\*Next Step:\*\*/ {for (i=2; i<=NF; i++) if ($i ~ /^[[:space:]]*[-*][[:space:]]/ || $i ~ /^[[:space:]]+[A-Za-z]/) {gsub(/^[[:space:]]*[-*][[:space:]]*/, "", $i); gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i); if ($i) print $i}}' "$f" | head -3)
done

# --- Business Outreach Generator (lead next actions) ---
for f in .leads/*.md; do
  [[ "$f" == .leads/todo-index.md ]] && continue
  [[ ! -f "$f" ]] && continue
  lead=$(sed -n 's/^# //p' "$f" | head -1 | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
  [[ -z "$lead" ]] && continue

  next=$(awk 'BEGIN{RS=""; FS="\n"} /\*\*Next Action:\*\*/ {for (i=2; i<=NF; i++) if ($i ~ /[^[:space:]]/) {gsub(/^[[:space:]]*[-*][[:space:]]*/, "", $i); gsub(/^[[:space:]]+|[[:space:]]+$/, "", $i); if ($i) print $i; exit}}' "$f" | head -1)
  [[ -n "$next" && "$next" != "Unknown" ]] && append "$next" "$lead" 75
done

# --- todo-index ---
while IFS=$'\t' read -r lead action; do
  [[ -n "$lead" && -n "$action" ]] && append "$action" "$lead" 85
done < <(awk -F'|' '
  /^[[:space:]]*\|[[:space:]]*[0-9]+/ {
    if ($0 ~ /Priority/) next;
    if ($0 ~ /\|\-\-\-/) next;
    n = split($0, a, "|");
    lead = "";
    for (i = 3; i <= n; i++) {
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", a[i]);
      if (a[i] == "" || a[i] ~ /^[0-9]+$/) continue;
      lead = a[i];
      break;
    }
    action = "";
    for (i = n; i >= 1; i--) {
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", a[i]);
      if (a[i] == "") continue;
      if (a[i] ~ /\.md$/) continue;
      action = a[i];
      break;
    }
    if (lead != "" && action != "") print lead "\t" action;
  }
' .leads/todo-index.md)

# --- daily focus snapshot (top 5 by score) ---
top=$(tail -n +2 "$TSV" | sort -t$'\t' -k5,5 -n -r | head -5 | cut -f1 | paste -sd ',' -)
cat > .focus/today.md <<EOF
# Daily Focus — $(date +%Y-%m-%d)

Selected: $top
EOF

echo "Imported $((id - 1)) tasks into .focus/task-graph.tsv"
