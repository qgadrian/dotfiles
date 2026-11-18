#!/usr/bin/env python3
"""Claude Code attention state for external readers (the nvim tabline).

Invoked by claude-attention-flag.sh from every relevant hook event. It
dispatches on the payload's hook_event_name, so the command-line arguments
are ignored (older settings.json entries pass `write notify` / `clear`).

State lives in ~/.claude/attention/<pid>/ (pid = the Claude process, resolved
through ~/.claude/sessions/<pid>.json):

  flag          "needs_input <origin>". origin is "main" or the agent_id of
                the subagent that raised it, so only that origin's
                PostToolUse can clear it.
  agents/<id>   one marker per running subagent; mtime = start time. Readers
                ignore markers older than their TTL in case SubagentStop
                never fires.

Events:
  PermissionRequest            -> flag needs_input (origin = agent or main)
  Notification                 -> flag needs_input for permission_prompt /
                                  elicitation_dialog / agent_needs_input only;
                                  never overwrites an existing flag.
                                  idle_prompt and others are ignored.
  PostToolUse(Failure)         -> clear flag raised by the same origin
  UserPromptSubmit             -> clear flag
  Stop                         -> clear flag raised by main
  SubagentStart / SubagentStop -> add / remove agent marker (stop also
                                  clears that agent's flag)
  SessionStart                 -> clear flag (not on compact); on startup,
                                  sweep state of dead pids and legacy
                                  ~/.claude/sessions/*.flag files
  SessionEnd                   -> remove this pid's state
"""
import glob
import json
import os
import re
import shutil
import sys
import time

CLAUDE_DIR = os.environ.get("CLAUDE_CONFIG_DIR") or os.path.expanduser("~/.claude")
SESSIONS_DIR = os.path.join(CLAUDE_DIR, "sessions")
STATE_DIR = os.path.join(CLAUDE_DIR, "attention")
LOG = os.path.join(CLAUDE_DIR, "hooks", "claude-attention-flag.log")
LOG_MAX = 1 << 20  # trim when larger than 1 MiB...
LOG_KEEP = 256 << 10  # ...down to the last 256 KiB
NEEDS_INPUT_TYPES = {"permission_prompt", "elicitation_dialog", "agent_needs_input"}
SAFE_ID = re.compile(r"^[A-Za-z0-9_.-]{1,128}$")


def log(msg):
    try:
        if os.path.exists(LOG) and os.path.getsize(LOG) > LOG_MAX:
            with open(LOG, "rb") as f:
                f.seek(-LOG_KEEP, os.SEEK_END)
                tail = f.read().split(b"\n", 1)[-1]
            tmp = f"{LOG}.{os.getpid()}.tmp"
            with open(tmp, "wb") as f:
                f.write(tail)
            os.replace(tmp, LOG)
        with open(LOG, "a") as f:
            f.write(f"[{time.strftime('%Y-%m-%d %H:%M:%S')}] {msg}\n")
    except OSError:
        pass


def find_pid(session_id):
    try:
        entries = os.listdir(SESSIONS_DIR)
    except OSError:
        return None
    for entry in entries:
        if not entry.endswith(".json"):
            continue
        try:
            with open(os.path.join(SESSIONS_DIR, entry)) as f:
                d = json.load(f)
        except (OSError, ValueError):
            continue
        if d.get("sessionId") == session_id and isinstance(d.get("pid"), int):
            return d["pid"]
    return None


def pid_alive(pid):
    try:
        os.kill(pid, 0)
    except ProcessLookupError:
        return False
    except PermissionError:
        return True
    return True


def read_flag_origin(state):
    try:
        with open(os.path.join(state, "flag")) as f:
            parts = f.read().split()
    except OSError:
        return None
    if len(parts) >= 2 and parts[0] == "needs_input":
        return parts[1]
    return None


def write_flag(state, origin):
    os.makedirs(state, exist_ok=True)
    tmp = os.path.join(state, f"flag.{os.getpid()}.tmp")
    with open(tmp, "w") as f:
        f.write(f"needs_input {origin}")
    os.replace(tmp, os.path.join(state, "flag"))


def clear_flag(state):
    try:
        os.remove(os.path.join(state, "flag"))
        return True
    except OSError:
        return False


def sweep():
    removed = 0
    for path in glob.glob(os.path.join(STATE_DIR, "*")):  # skips dotfiles
        name = os.path.basename(path)
        if name.isdigit() and not pid_alive(int(name)):
            shutil.rmtree(path, ignore_errors=True)
            removed += 1
    legacy = glob.glob(os.path.join(SESSIONS_DIR, "*.flag"))
    for path in legacy:
        try:
            os.remove(path)
        except OSError:
            pass
    if removed or legacy:
        log(f"sweep: removed {removed} dead state dirs, {len(legacy)} legacy flags")


def main():
    try:
        payload = json.load(sys.stdin)
    except Exception:
        return
    if not isinstance(payload, dict):
        return

    event = payload.get("hook_event_name") or ""
    session_id = payload.get("session_id") or ""
    agent = payload.get("agent_id")
    agent = agent if isinstance(agent, str) and SAFE_ID.match(agent) else None
    origin = agent or "main"
    ntype = payload.get("notification_type") if event == "Notification" else None

    if not session_id:
        return
    pid = find_pid(session_id)
    if pid is None:
        if event in ("PermissionRequest", "Notification", "SubagentStart"):
            log(f"skip: no session json ev={event} sid={session_id}")
        return

    state = os.path.join(STATE_DIR, str(pid))
    current = read_flag_origin(state)
    tag = f"pid={pid} ev={event} agent={agent or '-'}"
    # `touch ~/.claude/attention/.debug` logs every event (remove it after).
    if os.path.exists(os.path.join(STATE_DIR, ".debug")):
        log(f"debug {tag} type={ntype} tool={payload.get('tool_name')} flag={current}")

    if event == "PermissionRequest":
        write_flag(state, origin)
        log(f"{tag} -> needs_input {origin}")
    elif event == "Notification":
        if ntype in NEEDS_INPUT_TYPES and current is None:
            write_flag(state, origin)
            log(f"{tag} type={ntype} -> needs_input {origin}")
        else:
            log(f"{tag} type={ntype} -> no change (flag={current})")
    elif event in ("PostToolUse", "PostToolUseFailure"):
        if current is not None and current == origin and clear_flag(state):
            log(f"{tag} -> clear")
    elif event == "UserPromptSubmit":
        if clear_flag(state):
            log(f"{tag} -> clear")
    elif event == "Stop":
        if current == "main" and clear_flag(state):
            log(f"{tag} -> clear")
    elif event == "SubagentStart":
        if agent:
            agents = os.path.join(state, "agents")
            os.makedirs(agents, exist_ok=True)
            with open(os.path.join(agents, agent), "w") as f:
                f.write(str(payload.get("agent_type") or ""))
            log(f"{tag} -> agent start ({payload.get('agent_type') or '?'})")
        else:
            log(f"{tag} -> agent start without agent_id; keys={sorted(payload)}")
    elif event == "SubagentStop":
        if agent:
            try:
                os.remove(os.path.join(state, "agents", agent))
            except OSError:
                pass
            if current == agent:
                clear_flag(state)
            log(f"{tag} -> agent stop")
    elif event == "SessionStart":
        source = payload.get("source")
        if source != "compact":
            clear_flag(state)
        if source == "startup":
            shutil.rmtree(os.path.join(state, "agents"), ignore_errors=True)
            sweep()
    elif event == "SessionEnd":
        shutil.rmtree(state, ignore_errors=True)
        log(f"{tag} -> end")


if __name__ == "__main__":
    try:
        main()
    except Exception as exc:  # a hook must never fail loudly
        log(f"error: {exc!r}")
