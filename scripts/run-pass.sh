#!/usr/bin/env bash
# Run one five-part brief as a headless Claude pass and log its cost.
# Usage: run-pass.sh brief.txt [pass-name]
# Env: MODEL (default opus), MAX_BUDGET_USD (optional cap), LEDGER (default passes.jsonl),
#      SETTING_SOURCES (default "project": keeps your personal hooks and plugins out),
#      ISOLATE (default 1: also excludes ~/.claude/CLAUDE.md, ~/.claude/rules and ~/CLAUDE.md,
#      which are otherwise picked up as "ancestor" project files for any game under $HOME)
set -euo pipefail

brief="${1:?usage: run-pass.sh brief.txt [pass-name]}"
name="${2:-$(basename "$brief" .txt)}"
[ -f "$brief" ] || { echo "brief not found: $brief" >&2; exit 1; }

mkdir -p runs
out="runs/$(date +%Y%m%d-%H%M%S)-$name.json"
budget=()
[ -n "${MAX_BUDGET_USD:-}" ] && budget=(--max-budget-usd "$MAX_BUDGET_USD")
[ "${ISOLATE:-1}" = 1 ] && budget+=(--settings "{\"claudeMdExcludes\":[\"$HOME/.claude/CLAUDE.md\",\"$HOME/.claude/rules/**\",\"$HOME/CLAUDE.md\"]}")

claude -p --model "${MODEL:-opus}" --output-format json --permission-mode acceptEdits \
  --setting-sources "${SETTING_SOURCES:-project}" \
  --allowedTools "Read,Write,Edit,Glob,Grep" ${budget[@]+"${budget[@]}"} < "$brief" > "$out" || true

# First line only: shell notices can trail the JSON.
python3 -I - "$out" "$name" "${LEDGER:-passes.jsonl}" <<'PY'
import json, sys, datetime
out, name, ledger = sys.argv[1:4]
try:
    d = json.loads(open(out).read().splitlines()[0])
except (IndexError, ValueError):
    sys.exit(f"no JSON result in {out}; inspect it")
row = {"at": datetime.datetime.now().isoformat(timespec="seconds"), "pass": name,
       "cost_usd": round(d.get("total_cost_usd") or 0, 2),
       "minutes": round((d.get("duration_ms") or 0) / 60000, 1),
       "turns": d.get("num_turns"), "is_error": d.get("is_error"), "raw": out}
open(ledger, "a").write(json.dumps(row) + "\n")
total = sum(json.loads(l)["cost_usd"] for l in open(ledger) if l.strip())
print(f"{name}: ${row['cost_usd']} · {row['minutes']} min · error={row['is_error']} · project total ${total:.2f}")
print((d.get("result") or "")[-1500:])
sys.exit(1 if d.get("is_error") else 0)
PY
