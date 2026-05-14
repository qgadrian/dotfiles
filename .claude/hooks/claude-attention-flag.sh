#!/bin/bash
# Writes/clears ~/.claude/sessions/<pid>.flag to signal Claude Code attention
# state to external readers (e.g. nvim tabline indicator).
#
# Usage (from a Claude hook entry in ~/.claude/settings.json):
#   claude-attention-flag.sh write action_needed   # PermissionRequest
#   claude-attention-flag.sh write notify          # Notification
#   claude-attention-flag.sh clear                 # UserPromptSubmit / Stop
#
# Resolves the target session by matching the hook payload's session_id
# against the sessionId field in ~/.claude/sessions/<pid>.json. This is more
# robust than walking PPID (Claude hooks run from worker subprocesses).
set -euo pipefail

ACTION="${1:-}"
VALUE="${2:-}"
SESSIONS_DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/sessions"
LOG="${CLAUDE_CONFIG_DIR:-$HOME/.claude}/hooks/claude-attention-flag.log"

log() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" >> "$LOG" 2>/dev/null || true; }

case "$ACTION" in
  write)
    case "$VALUE" in
      action_needed|notify) ;;
      *) log "reject: invalid value '$VALUE'"; exit 0 ;;
    esac
    ;;
  clear) ;;
  *) log "reject: invalid action '$ACTION'"; exit 0 ;;
esac

# Read hook payload from stdin and extract session_id.
INPUT=$(cat || true)
SESSION_ID=$(printf '%s' "$INPUT" | python3 -c '
import json, sys
try:
    d = json.load(sys.stdin)
    print(d.get("session_id") or d.get("conversation_id") or "")
except Exception:
    pass
' 2>/dev/null || echo "")

if [ -z "$SESSION_ID" ]; then
  log "skip: no session_id in payload action=$ACTION"
  exit 0
fi

# Find the matching session.json by sessionId field.
PID=$(python3 - "$SESSIONS_DIR" "$SESSION_ID" <<'PY' 2>/dev/null || true
import json, os, sys
sessions_dir, target_sid = sys.argv[1], sys.argv[2]
if not os.path.isdir(sessions_dir): sys.exit(0)
for entry in os.listdir(sessions_dir):
    if not entry.endswith(".json"): continue
    path = os.path.join(sessions_dir, entry)
    try:
        with open(path, "r") as fd: d = json.load(fd)
    except Exception:
        continue
    if d.get("sessionId") == target_sid:
        pid = d.get("pid")
        if isinstance(pid, int):
            print(pid)
            break
PY
)

if [ -z "$PID" ]; then
  log "skip: no session.json found for sid=$SESSION_ID action=$ACTION"
  exit 0
fi

FLAG="$SESSIONS_DIR/$PID.flag"
case "$ACTION" in
  write)
    printf '%s' "$VALUE" > "$FLAG"
    log "write pid=$PID value=$VALUE sid=$SESSION_ID"
    ;;
  clear)
    rm -f "$FLAG"
    log "clear pid=$PID sid=$SESSION_ID"
    ;;
esac
