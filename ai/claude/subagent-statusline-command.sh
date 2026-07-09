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
#     - model      -> resolved per-subagent, highest precedence first:
#                       1. $CLAUDE_SUBAGENT_MODEL (hard debug override)
#                       2. the spawn tool_use's input.model (explicit dispatch
#                          override passed to the Agent/Task tool)
#                       3. the agent file's frontmatter `model:` — read from
#                          <task cwd>/.claude/agents/<type>.md, then <session
#                          cwd>/.claude/agents/<type>.md, then
#                          ~/.claude/agents/<type>.md
#                       4. the inherited session model (~/.claude/settings.json
#                          .model)
#                     `model: inherit` in an agent file is treated as "unset" so
#                     it falls through to the session model.
#     - effort     -> same precedence: $CLAUDE_SUBAGENT_EFFORT, input.effort,
#                     frontmatter `effort:`, else session .effortLevel.
#     - ctx %      -> tokenCount / window; window sized from the RESOLVED model
#                     ("[1m]"/"1m" -> 1,000,000 else 200,000). This is why a
#                     plain-`sonnet` subagent under a fable-5[1m] session now
#                     reports its true ~200k-window %, not the session's 1M %.
#                     (hard override: $CLAUDE_SUBAGENT_CTX_WINDOW)
#   agent type, model, effort, and window are all resolved per-subagent; only the
#   session model/effort remain as last-resort fallbacks.
#
# OUTPUT CONTRACT: one JSON line per row -> {"id":"<task id>","content":"<row body>"}.

input=$(cat)

settings="$HOME/.claude/settings.json"

# --- Debug hard-overrides (win over per-agent resolution when set) -----------
force_model="${CLAUDE_SUBAGENT_MODEL:-}"
force_effort="${CLAUDE_SUBAGENT_EFFORT:-}"
ctx_window_override="${CLAUDE_SUBAGENT_CTX_WINDOW:-0}"

# --- Session-level fallbacks (last resort when nothing else resolves) --------
session_model="$force_model"
if [ -z "$session_model" ] && [ -f "$settings" ]; then
  session_model=$(jq -r '.model // empty' "$settings" 2>/dev/null)
fi
[ -z "$session_model" ] && session_model="?"

session_effort="$force_effort"
if [ -z "$session_effort" ] && [ -f "$settings" ]; then
  session_effort=$(jq -r '.effortLevel // empty' "$settings" 2>/dev/null)
fi

# --- Payload-level context ---------------------------------------------------
transcript_path=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
session_cwd=$(printf '%s' "$input" | jq -r '.cwd // empty')
cache_dir="${TMPDIR:-/tmp}/claude-statusline"
mkdir -p "$cache_dir" 2>/dev/null
_now=$(date +%s)

# Read a scalar frontmatter field (model:/effort:) from an agent .md file.
# Only scans the first --- ... --- block so body prose can't shadow it.
frontmatter_field() {
  local file="$1" key="$2" v
  [ -f "$file" ] || { printf ''; return; }
  v=$(awk '
        /^---[[:space:]]*$/ { n++; if (n>=2) exit; next }
        n==1 { print }
      ' "$file" 2>/dev/null \
      | sed -n -E "s/^${key}:[[:space:]]*//p" \
      | head -n1 \
      | sed -E "s/[[:space:]]*#.*$//; s/^[\"']//; s/[\"'][[:space:]]*$//; s/[[:space:]]*$//")
  printf '%s' "$v"
}

# Resolve {type, model, effort} for a task, cached per task id.
#   type   <- spawn tool_use input.subagent_type (parent transcript)
#   model  <- force_model | input.model | frontmatter model | session_model
#   effort <- force_effort | input.effort | frontmatter effort | session_effort
# Matching a spawn tool_use (not a tool_result) keeps RUNNING foreground
# subagents resolvable. Positive results cache permanently; failed lookups are
# throttled to one attempt per 12s to bound cost.
resolve_meta() {
  local id="$1" name="$2" task_cwd="$3" cf raw spawn type mdl eff af mtime cand
  cf="$cache_dir/ameta_$(printf '%s' "$id" | tr -c 'A-Za-z0-9' '_')"

  if [ -s "$cf" ]; then
    raw=$(cat "$cf" 2>/dev/null)
    if [ -n "$raw" ] && [ "$raw" != "?" ]; then printf '%s' "$raw"; return; fi
  fi

  if [ -z "$name" ] || [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then printf ''; return; fi

  mtime=0
  [ -f "$cf" ] && mtime=$(stat -f %m "$cf" 2>/dev/null || stat -c %Y "$cf" 2>/dev/null || echo 0)
  if [ -f "$cf" ] && [ "$(( _now - mtime ))" -lt 12 ]; then printf ''; return; fi
  printf '?' > "$cf" 2>/dev/null   # lease/throttle marker

  # type + dispatch-time model/effort override from the spawn tool_use (last wins).
  spawn=$(grep -F "$name" "$transcript_path" 2>/dev/null | jq -rs --arg n "$name" '
    [ .[].message.content[]?
      | select(type=="object" and .type=="tool_use"
               and (.input.subagent_type != null)
               and (.input.description == $n))
      | {type: .input.subagent_type,
         model: (.input.model // ""),
         effort: (.input.effort // "")} ] | last // empty' 2>/dev/null)

  type=$(printf '%s' "$spawn" | jq -r '.type // empty' 2>/dev/null)
  if [ -z "$type" ] || [ "$type" = "null" ]; then printf ''; return; fi

  mdl=$(printf '%s' "$spawn" | jq -r '.model // empty' 2>/dev/null)
  eff=$(printf '%s' "$spawn" | jq -r '.effort // empty' 2>/dev/null)

  # Debug hard-override beats everything.
  [ -n "$force_model" ]  && mdl="$force_model"
  [ -n "$force_effort" ] && eff="$force_effort"

  # Fill from the agent file frontmatter when still unset.
  if [ -z "$mdl" ] || [ -z "$eff" ]; then
    af=""
    for cand in "$task_cwd/.claude/agents/$type.md" \
                "$session_cwd/.claude/agents/$type.md" \
                "$HOME/.claude/agents/$type.md"; do
      case "$cand" in /.claude/*) continue ;; esac   # skip empty-base joins
      if [ -f "$cand" ]; then af="$cand"; break; fi
    done
    if [ -n "$af" ]; then
      [ -z "$mdl" ] && mdl=$(frontmatter_field "$af" model)
      [ -z "$eff" ] && eff=$(frontmatter_field "$af" effort)
    fi
  fi

  # `model: inherit` -> fall through to the session model.
  [ "$mdl" = "inherit" ] && mdl=""

  # Session fallbacks.
  [ -z "$mdl" ] && mdl="$session_model"
  [ -z "$eff" ] && eff="$session_effort"

  raw=$(jq -cn --arg t "$type" --arg m "$mdl" --arg e "$eff" \
        '{type:$t, model:$m, effort:$e}')
  printf '%s' "$raw" > "$cf" 2>/dev/null
  printf '%s' "$raw"
}

# Build an {id: {type,model,effort}} map for the renderer.
meta_json="{}"
_ntasks=$(printf '%s' "$input" | jq '.tasks | length // 0' 2>/dev/null)
[ -z "$_ntasks" ] && _ntasks=0
_i=0
while [ "$_i" -lt "$_ntasks" ]; do
  id=$(printf '%s' "$input" | jq -r ".tasks[$_i].id // empty" 2>/dev/null)
  name=$(printf '%s' "$input" | jq -r ".tasks[$_i].label // .tasks[$_i].description // empty" 2>/dev/null)
  tcwd=$(printf '%s' "$input" | jq -r ".tasks[$_i].cwd // empty" 2>/dev/null)
  _i=$(( _i + 1 ))
  [ -z "$id" ] && continue
  m=$(resolve_meta "$id" "$name" "$tcwd")
  [ -z "$m" ] && continue
  meta_json=$(printf '%s' "$meta_json" | jq -c --arg id "$id" --argjson m "$m" '. + {($id): $m}')
done

# --- Render -----------------------------------------------------------------
printf '%s' "$input" | jq -rc \
  --argjson meta "$meta_json" \
  --arg smodel "$session_model" --arg seffort "$session_effort" \
  --argjson winoverride "$ctx_window_override" '
  # ANSI helpers. The agent panel renders content "as-is, including ANSI colors
  # and OSC 8 hyperlinks" (statusline docs), same as the main status line. ESC
  # is written as the jq escape \u001b (NOT a raw 0x1b byte — raw ESC bytes in
  # this file have been silently stripped by editors before, breaking colors).
  def esc:    "\u001b";
  def blue:   esc + "[34m"       + . + esc + "[0m";
  def cyan:   esc + "[36m"       + . + esc + "[0m";
  def green:  esc + "[32m"       + . + esc + "[0m";
  def yellow: esc + "[33m"       + . + esc + "[0m";
  def orange: esc + "[38;5;208m" + . + esc + "[0m";
  def red:    esc + "[31m"       + . + esc + "[0m";
  def dim:    esc + "[2m"        + . + esc + "[0m";

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

  # Context window sized from the resolved model string.
  def winsize($m):
    if ($m | type) == "string" and ($m | ascii_downcase | test("1m"))
    then 1000000 else 200000 end;

  .tasks[]?
  | .id as $id
  | ($meta[$id] // {})                      as $mm
  | ($mm.type // "")                        as $atype
  | (($mm.model // $smodel)
       | if (type == "string" and length > 0) then . else "?" end) as $model
  | ($mm.effort // $seffort // "")           as $effort
  | (if $winoverride > 0 then $winoverride else winsize($model) end) as $win
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
