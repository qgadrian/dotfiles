#!/usr/bin/env bash
# Claude Code subagentStatusLine command
# Renders one custom row body per subagent in the agent panel below the prompt.
#
# Row: name [role]   ctx% (tokens) · 🪐 model effort
#
# HOW THE PANEL RENDERS US (read off the 2.1.220 bundle, component `$qf`):
#   When this hook returns content for a task, the row becomes ONLY
#   "<bullet><our content>" inside a single flex box with wrap:"truncate" —
#   Claude Code's own name column and description column are NOT drawn. So the
#   row is ours end to end, and anything past `columns` is silently cut from the
#   RIGHT. That is why the model/effort segment is width-budgeted below: the
#   name is what gets clipped, never the metadata.
#   Returning "" (empty string) for a task HIDES its row entirely.
#
# THE 5s BUDGET (the failure that looks like "the hook did nothing"):
#   The panel runs this script every 5s with a 5s timeout. On timeout or a
#   non-zero exit, Claude Code drops EVERY decoration and falls back to its
#   default row (name + raw prompt + elapsed) — with no model or effort on it at
#   all. So the script must always finish well inside 5s: the only unbounded
#   work here (the role lookup) is capped by LOOKUP_DEADLINE and cached.
#
# WHAT THE PAYLOAD GIVES US (2.1.220 builds it in `T8f`):
#   Top-level: session_id, transcript_path, cwd, prompt_id, agent_type,
#              columns (≈ terminal width - 4, i.e. our row's real budget), tasks[]
#   Per task:  id, name, type (always "local_agent"), status, description,
#              label (= progress.summary, else description), startTime,
#              model, effort, contextWindowSize, tokenCount, tokenSamples, cwd
#
#   model / effort / contextWindowSize / name are read straight off the payload —
#   they are real per-subagent values, so no settings.json guessing and no
#   agent-frontmatter parsing (an earlier revision did both; the payload carries
#   the truth). Session settings are only a last resort for an agent that
#   inherits and therefore reports no model of its own.
#
#   The ONE thing the payload does not forward is the agent's role: `type` is
#   always the literal "local_agent", while the real agentType lives only in app
#   state. We recover it from the PARENT transcript by matching the spawn
#   tool_use — keyed on the task's `name` (the Agent tool's `name:` argument),
#   falling back to its label. Matching the spawn tool_use, not a tool_result,
#   is what makes RUNNING foreground subagents resolvable: their tool_result,
#   which carries the agentId, does not exist until they finish.
#
# OUTPUT CONTRACT: one JSON line per row -> {"id":"<task id>","content":"<row body>"}.

input=$(cat)

settings="$HOME/.claude/settings.json"

# Wall-clock budget for transcript lookups, in seconds. Past this, unresolved
# roles are simply left blank for this tick (and retried on the next one) so we
# never lose the whole panel to the 5s hook timeout.
LOOKUP_DEADLINE=2

# --- Debug hard-overrides (win over the payload when set) --------------------
force_model="${CLAUDE_SUBAGENT_MODEL:-}"
force_effort="${CLAUDE_SUBAGENT_EFFORT:-}"
ctx_window_override="${CLAUDE_SUBAGENT_CTX_WINDOW:-0}"

# --- Session fallbacks (only for a subagent that reports no model of its own) -
session_model="$force_model"
session_effort="$force_effort"
if [ -z "$session_model" ] || [ -z "$session_effort" ]; then
  if [ -f "$settings" ]; then
    _s=$(jq -r '[(.model // ""), (.effortLevel // "")] | @tsv' "$settings" 2>/dev/null)
    IFS=$'\t' read -r _sm _se <<< "$_s"
    [ -z "$session_model" ]  && session_model="$_sm"
    [ -z "$session_effort" ] && session_effort="$_se"
  fi
fi

transcript_path=$(printf '%s' "$input" | jq -r '.transcript_path // empty')
cache_dir="${TMPDIR:-/tmp}/claude-statusline"
mkdir -p "$cache_dir" 2>/dev/null
_now=$(date +%s)

# Resolve a task's role (agentType) from the parent transcript, cached per task
# id. Positive results cache permanently — a subagent never changes role. Misses
# cache as "-" and are retried at most once per 30s, because the common miss
# (an agent spawned in an earlier session, so absent from this transcript) is
# permanent and re-scanning it every tick is pure cost.
resolve_role() {
  local id="$1" key="$2" cf raw mtime role
  cf="$cache_dir/arole_${id//[^A-Za-z0-9]/_}"

  if [ -s "$cf" ]; then
    raw=$(<"$cf")
    if [ -n "$raw" ] && [ "$raw" != "-" ]; then printf '%s' "$raw"; return; fi
    mtime=$(stat -f %m "$cf" 2>/dev/null || stat -c %Y "$cf" 2>/dev/null || echo 0)
    if [ "$(( _now - mtime ))" -lt 30 ]; then return; fi
  fi

  [ -n "$key" ] || return
  [ -n "$transcript_path" ] && [ -f "$transcript_path" ] || return
  [ "$SECONDS" -lt "$LOOKUP_DEADLINE" ] || return

  # grep -F narrows the transcript to candidate lines; tail bounds what jq has
  # to parse. The spawn of a live subagent is near the end by construction.
  role=$(grep -F "$key" "$transcript_path" 2>/dev/null | tail -n 40 | jq -rs --arg k "$key" '
    [ .[]?.message?.content[]?
      | select(type == "object" and .type == "tool_use" and (.input.subagent_type != null))
      | select(((.input.name // "") == $k)
               or ((.input.description // "") | startswith($k))
               or ((.input.prompt // "") | startswith($k)))
      | .input.subagent_type ] | last // empty' 2>/dev/null)

  if [ -n "$role" ]; then
    printf '%s' "$role" > "$cf" 2>/dev/null
    printf '%s' "$role"
  else
    printf '%s' '-' > "$cf" 2>/dev/null
  fi
}

# One jq pass for every lookup key: id, name, and a label prefix as fallback.
# Tabs/newlines are flattened first so @tsv never has to escape them — the key
# is fed to grep -F literally.
roles=""
while IFS=$'\t' read -r t_id t_name t_label; do
  [ -n "$t_id" ] || continue
  key="$t_name"
  [ -z "$key" ] && key="$t_label"
  role=$(resolve_role "$t_id" "$key")
  [ -n "$role" ] || continue
  roles="${roles}${t_id}	${role}
"
done < <(printf '%s' "$input" | jq -r '
  .tasks[]?
  | [ (.id // ""),
      ((.name // "") | gsub("[\t\r\n]"; " ")),
      ((.label // .description // "") | split("\n")[0] | gsub("[\t\r]"; " ") | .[0:60]) ]
  | @tsv')

meta_json=$(printf '%s' "$roles" | jq -Rn '[inputs | split("\t") | {(.[0]): .[1]}] | add // {}' 2>/dev/null)
[ -n "$meta_json" ] || meta_json="{}"

# --- Render -----------------------------------------------------------------
printf '%s' "$input" | jq -rc \
  --argjson meta "$meta_json" \
  --arg smodel "$session_model" --arg seffort "$session_effort" \
  --arg fmodel "$force_model" --arg feffort "$force_effort" \
  --argjson winoverride "$ctx_window_override" '
  # ANSI helpers. The agent panel renders content "as-is, including ANSI colors
  # and OSC 8 hyperlinks" (statusline docs), same as the main status line. ESC
  # is written as the jq escape \u001b (NOT a raw 0x1b byte — raw ESC bytes in
  # this file have been silently stripped by editors before, breaking colors).
  def esc:      "\u001b";
  def cyan:     esc + "[36m"       + . + esc + "[0m";
  def green:    esc + "[32m"       + . + esc + "[0m";
  def yellow:   esc + "[33m"       + . + esc + "[0m";
  def orange:   esc + "[38;5;208m" + . + esc + "[0m";
  def red:      esc + "[31m"       + . + esc + "[0m";
  def grey:     esc + "[38;5;245m" + . + esc + "[0m";
  def dim:      esc + "[2m"        + . + esc + "[0m";
  def boldfg($c): esc + "[1;38;5;" + $c + "m" + . + esc + "[0m";

  def compact($n):
    if   $n >= 1000000 then (((($n / 100000) | floor) / 10) | tostring) + "M"
    elif $n >= 1000    then (($n / 1000) | floor | tostring) + "k"
    else ($n | tostring) end;

  def clip($s; $n):
    if $n <= 1 then ""
    elif ($s | length) > $n then ($s[0:$n-1] + "…")
    else $s end;

  def pad($n): if $n > 0 then (" " * $n) else "" end;

  def heat($p; $s):
    if   $p >= 75 then ($s | red)
    elif $p >= 50 then ($s | orange)
    elif $p >= 25 then ($s | yellow)
    else $s end;

  # Model segment: emoji + bold name + effort, matching the main status line.
  # Emoji and color are matched on a substring so they survive version bumps;
  # each color is the dominant hue of its own emoji glyph, kept clear of the
  # effort ramp. Bold name / plain effort separates close hues. NOTE: no
  # apostrophes in this jq program — it is single-quoted in the shell.
  def modelstyle($m):
    ($m | ascii_downcase) as $l
    | if   ($l | test("fable"))  then ["🦄","177"]   # unicorn, orchid — the mane
      elif ($l | test("opus"))   then ["🪐","220"]   # planet,  gold   — the planet
      elif ($l | test("sonnet")) then ["🪶","230"]   # feather, ivory  — the feather
      elif ($l | test("haiku"))  then ["🍃","114"]   # leaf,    green  — the leaf
      else ["✨","252"] end;                               # unknown model: neutral

  def effortcolor($e):
    if   $e == "low"    then ($e | grey)
    elif $e == "medium" then ($e | cyan)
    elif $e == "high"   then ($e | yellow)
    elif $e == "xhigh"  then ($e | orange)
    elif $e == "max"    then ($e | red)
    else ($e | yellow) end;

  # Context window: the payload sizes it per model; fall back to the model
  # string only when an inheriting agent reports none.
  def winsize($m):
    if ($m | ascii_downcase | test("1m")) then 1000000 else 200000 end;

  # `columns` is already terminal width minus the bullet gutter. Nested agents
  # additionally carry a tree connector we cannot see, hence the small margin.
  ((.columns // 80) - 2) as $W

  | [ .tasks[]?
      | . as $t
      | .id as $id
      | ($meta[$id] // "")                                    as $role
      | (if $fmodel  != "" then $fmodel
         else ((.model  // "") | if . == "" then $smodel else . end) end)  as $model
      | (if $feffort != "" then $feffort
         else ((.effort // "") | if . == "" then $seffort else . end) end) as $effort
      | (if   $winoverride > 0        then $winoverride
         elif (.contextWindowSize // 0) > 0 then .contextWindowSize
         else winsize($model) end)                            as $win
      | (.tokenCount // 0)                                    as $tok
      | (.status // "")                                       as $status
      | (if ($t.name // "") != "" then $t.name
         else (($t.label // $t.description // "agent") | split("\n")[0]) end) as $name
      | (if $win > 0 then (($tok * 100) / $win) else 0 end | floor) as $pct
      | (if $role != "" then " [" + $role + "]" else "" end)   as $rolestr
      | (if $status != "" and $status != "running" and $status != "in_progress"
           then " [" + $status + "]" else "" end)             as $statusstr
      | (($pct | tostring) + "% (" + compact($tok) + ") · "
         + (if $model == "" then "?" else $model end)
         + (if $effort != "" then " " + $effort else "" end)
         + $statusstr)                                        as $tailplain
      # +3: the emoji is two columns wide plus its trailing space.
      | (($tailplain | length) + 3)                           as $tailw
      | {id: $id, name: $name, role: $role, rolestr: $rolestr, status: $statusstr,
         model: $model, effort: $effort, pct: $pct, tok: $tok,
         tailw: $tailw, budget: ($W - $tailw - 2)}
    ] as $rows

  # Align the name column across rows, but never at the cost of the metadata:
  # every row keeps its own budget, and the shared width is the largest that
  # still fits in all of them.
  | ([$rows[] | .budget] | min // 0) as $minbudget
  | ([$rows[] | (.name | length) + (.rolestr | length)] | max // 0) as $widest
  | ([$widest, $minbudget, 34] | min) as $col

  | $rows[]
  | (if (.rolestr | length) > 0 and (.budget - (.rolestr | length)) >= 6
       then .rolestr else "" end) as $rolestr
  | clip(.name; .budget - ($rolestr | length))                as $name
  | (($name | length) + ($rolestr | length))                  as $headw
  | modelstyle(.model) as $st
  | {
      id: .id,
      content: (
        ($name | cyan)
        + (if $rolestr != "" then ($rolestr | green) else "" end)
        + pad($col - $headw)
        + "  " + heat(.pct; (.pct | tostring) + "%")
        + " " + (("(" + compact(.tok) + ")") | dim)
        + " · " + $st[0] + " "
        + ((if .model == "" then "?" else .model end) | boldfg($st[1]))
        + (if .effort != "" then " " + effortcolor(.effort) else "" end)
        + (if .status != "" then (.status | dim) else "" end)
      )
    }
'
