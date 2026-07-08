#!/usr/bin/env bash
# Claude Code subagentStatusLine command
# Renders one custom row body per subagent in the agent panel below the prompt.
#
# Row: [agent-type] name   ctx% (tokens) · model (effort)
#
# WHAT THE HOOK GIVES US (captured empirically — the docs' schema was wrong):
#   Top-level: session_id, transcript_path, cwd, prompt_id, agent_type, columns,
#              tasks[]
#   Per task:  id, type (ALWAYS "local_agent"), status, description, label,
#              startTime, tokenCount, tokenSamples[], cwd
#
#   The payload does NOT carry the subagent's real agent type, its model, its
#   thinking effort, or a context-window size. We recover each as follows:
#     - name       -> .label (fallback .description)
#     - agent type -> resolved from the PARENT transcript by matching the task's
#                     label against a Task/Agent tool_use's input.description; that
#                     tool_use's input.subagent_type is the type. (Matching by the
#                     spawn tool_use, not a tool_result, is what makes RUNNING
#                     foreground subagents resolvable — their tool_result, which
#                     carries the agentId, doesn't exist until they finish.)
#                     Resolved via streaming grep, cached per task id.
#     - model      -> inherited session model, from ~/.claude/settings.json .model
#                     (override: $CLAUDE_SUBAGENT_MODEL)
#     - effort     -> inherited session effort, from settings.json .effortLevel
#                     (override: $CLAUDE_SUBAGENT_EFFORT)
#     - ctx %      -> tokenCount / window; window sized from the model
#                     ("[1m]" -> 1,000,000 else 200,000).
#                     (override: $CLAUDE_SUBAGENT_CTX_WINDOW)
#   model/effort/type reflect the session defaults a subagent inherits; a per-
#   agent `model:`/effort override in an agent file isn't exposed to this hook
#   (except the type, which we resolve from the transcript).
#
# OUTPUT CONTRACT: one JSON line per row -> {"id":"<task id>","content":"<row body>"}.

input=$(cat)

settings="$HOME/.claude/settings.json"

# --- Inherited session model ------------------------------------------------
model="${CLAUDE_SUBAGENT_MODEL:-}"
if [ -z "$model" ] && [ -f "$settings" ]; then
  model=$(jq -r '.model // empty' "$settings" 2>/dev/null)
fi
[ -z "$model" ] && model="?"

# --- Context window, sized from the model -----------------------------------
ctx_window="${CLAUDE_SUBAGENT_CTX_WINDOW:-}"
if [ -z "$ctx_window" ]; then
  case "$(printf '%s' "$model" | tr 'A-Z' 'a-z')" in
    *1m*) ctx_window=1000000 ;;
    *)    ctx_window=200000  ;;
  esac
fi

# --- Inherited session thinking effort --------------------------------------
effort="${CLAUDE_SUBAGENT_EFFORT:-}"
if [ -z "$effort" ] && [ -f "$settings" ]; then
  effort=$(jq -r '.effortLevel // empty' "$settings" 2>/dev/null)
fi

# --- Per-subagent agent type (resolved from the parent transcript, cached) --
transcript_path=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
cache_dir="${TMPDIR:-/tmp}/claude-statusline"
mkdir -p "$cache_dir" 2>/dev/null
_now=$(date +%s)

# Echo the resolved subagent_type for a task, or "" if not (yet) known.
# Matches the task's label/description against a Task/Agent spawn tool_use in the
# transcript and reads its input.subagent_type (last match wins, so a re-dispatch
# resolves to the current one). Positive results cache permanently (types never
# change); failed lookups are throttled to one attempt per 12s to bound cost.
resolve_type() {
  local id="$1" name="$2" cf v mtime t
  cf="$cache_dir/atype_$(printf '%s' "$id" | tr -c 'A-Za-z0-9' '_')"

  if [ -s "$cf" ]; then
    v=$(cat "$cf" 2>/dev/null)
    if [ -n "$v" ] && [ "$v" != "?" ]; then printf '%s' "$v"; return; fi
  fi

  if [ -z "$name" ] || [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then printf ''; return; fi

  mtime=0
  [ -f "$cf" ] && mtime=$(stat -f %m "$cf" 2>/dev/null || stat -c %Y "$cf" 2>/dev/null || echo 0)
  if [ -f "$cf" ] && [ "$(( _now - mtime ))" -lt 12 ]; then printf ''; return; fi
  printf '?' > "$cf" 2>/dev/null   # lease/throttle marker

  # label/description -> subagent_type, via the spawn tool_use (last match wins).
  t=$(grep -F "$name" "$transcript_path" 2>/dev/null | jq -rs --arg n "$name" '
    [ .[].message.content[]?
      | select(type=="object" and .type=="tool_use"
               and (.input.subagent_type != null)
               and (.input.description == $n))
      | .input.subagent_type ] | last // empty' 2>/dev/null)

  if [ -n "$t" ] && [ "$t" != "null" ]; then
    printf '%s' "$t" > "$cf" 2>/dev/null
    printf '%s' "$t"
  else
    printf ''
  fi
}

# Build an {id: type} map for the renderer.
types_json="{}"
_ntasks=$(printf '%s' "$input" | jq '.tasks | length // 0' 2>/dev/null)
[ -z "$_ntasks" ] && _ntasks=0
_i=0
while [ "$_i" -lt "$_ntasks" ]; do
  id=$(printf '%s' "$input" | jq -r ".tasks[$_i].id // empty" 2>/dev/null)
  name=$(printf '%s' "$input" | jq -r ".tasks[$_i].label // .tasks[$_i].description // empty" 2>/dev/null)
  _i=$(( _i + 1 ))
  [ -z "$id" ] && continue
  t=$(resolve_type "$id" "$name")
  [ -z "$t" ] && continue
  types_json=$(printf '%s' "$types_json" | jq -c --arg id "$id" --arg t "$t" '. + {($id): $t}')
done

# --- Render -----------------------------------------------------------------
printf '%s' "$input" | jq -rc \
  --arg model "$model" --argjson win "$ctx_window" --arg effort "$effort" \
  --argjson types "$types_json" '
  # ANSI helpers. The agent panel renders content "as-is, including ANSI colors
  # and OSC 8 hyperlinks" (statusline docs), same as the main status line. We
  # write ESC as ; jq emits it JSON-escaped and Claude Code renders it.
  def blue:   "[34m"      + . + "[0m";
  def cyan:   "[36m"      + . + "[0m";
  def green:  "[32m"      + . + "[0m";
  def yellow: "[33m"      + . + "[0m";
  def orange: "[38;5;208m"+ . + "[0m";
  def red:    "[31m"      + . + "[0m";
  def dim:    "[2m"       + . + "[0m";

  def compact($n):
    if   $n >= 1000000 then (((($n / 100000) | floor) / 10) | tostring) + "M"
    elif $n >= 1000    then (($n / 1000) | floor | tostring) + "k"
    else ($n | tostring) end;

  def clip($s; $n): if ($s | length) > $n then ($s[0:$n-1] + "…") else $s end;

  def heat($p; $s):
    if   $p >= 75 then ($s | red)
    elif $p >= 50 then ($s | orange)
    elif $p >= 25 then ($s | yellow)
    else $s end;

  .tasks[]?
  | .id as $id
  | ($types[$id] // "")                    as $atype
  | (.label // .description // "subagent")  as $rawname
  | (.status // "")                         as $status
  | (.tokenCount // 0)                      as $tok
  | (if $win > 0 then (($tok * 100) / $win) else 0 end | floor) as $pct
  | {
      id: .id,
      content: (
        (if $atype != "" then (("[" + $atype + "]") | green) + " " else "" end)
        + (clip($rawname; 48) | cyan)
        + "  " + heat($pct; ($pct | tostring) + "%")
        + " " + (("(" + compact($tok) + " tok)") | dim)
        + " · " + (($model + (if $effort != "" then " (" + $effort + ")" else "" end)) | blue)
        + (if $status != "" and $status != "running" and $status != "in_progress"
             then " " + (("[" + $status + "]") | dim) else "" end)
      )
    }
'
