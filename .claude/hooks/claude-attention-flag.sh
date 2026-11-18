#!/bin/bash
# Claude Code attention state for the nvim tabline. All logic lives in
# claude_attention.py next to this file (see its docstring for the state
# layout and per-event behaviour). It dispatches on the payload's
# hook_event_name, so arguments are ignored; older settings.json entries
# that still pass `write notify` / `clear` keep working.
#
# Wire it to: PermissionRequest, Notification, PostToolUse,
# PostToolUseFailure, UserPromptSubmit, Stop, SubagentStart, SubagentStop,
# SessionStart, SessionEnd (see ../install-attention-flag.sh).
SELF="$(readlink -f "$0" 2>/dev/null || echo "$0")"
exec python3 "$(dirname "$SELF")/claude_attention.py" 2>/dev/null
