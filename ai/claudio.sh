#!/usr/bin/env zsh
#
# claudio — interactive launcher for `claude`.
#
# Fuzzy-picks (via peco) the agent, then the model, then the effort level
# for the session, then hands off to a normal interactive `claude` session
# with those flags set. Cancel any picker (Esc/Ctrl-C) to abort.
#
# The agent list has two groups, in this order:
#   1. Built-in agents  — ship with Claude Code itself (general-purpose,
#      claude, Explore, Plan), always offered, general-purpose first.
#   2. Custom agents    — discovered dynamically for the CURRENT directory:
#        <repo root>/.claude/agents/*.md   (project agents — win on clash)
#        ~/.claude/agents/*.md             (user-level agents)
#      so this group always reflects whatever repo you run `claudio` from.
# A dim, unselectable-looking header line separates the groups (picking one
# by mistake just re-prompts you with an error, no harm done). The agent
# picker always requires an explicit pick — there is no generic "use
# Claude Code's default" shortcut, so you never land on a session with no
# particular agent by accident; general-purpose is a real, first-class
# choice instead. If an agent's frontmatter declares its own
# `model:`/`effort:`, that becomes the top suggestion in the next picker,
# without forcing it — you can still pick anything else, or skip the
# override entirely.
#
# Passing --agent/--model/--effort yourself skips the matching picker, and
# any other arguments (prompt text, extra claude flags) are forwarded to
# `claude` untouched. Override the binaries with CLAUDIO_BIN / CLAUDIO_PECO.
#
# Every picker is colored: agent names (cyan custom / yellow built-in),
# model names (magenta), and effort levels as a green→red cost gradient
# (low=cheap/green through max=expensive/red). Set NO_COLOR to disable all
# of it.

set -euo pipefail

claude_bin="${CLAUDIO_BIN:-claude}"
peco_bin="${CLAUDIO_PECO:-peco}"

if [[ "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
  awk 'NR==1 { next } /^#/ { sub("^# ?", ""); print; next } { exit }' "$0"
  exit 0
fi

if ! command -v "$claude_bin" >/dev/null 2>&1; then
  print -u2 "claudio: claude command not found (looked for '$claude_bin')"
  exit 127
fi
if ! command -v "$peco_bin" >/dev/null 2>&1; then
  print -u2 "claudio: peco command not found (looked for '$peco_bin'). Install with: brew install peco"
  exit 127
fi

# ---- labels for "skip this picker" entries ---------------------------------
#
# Model and effort are session tuning knobs, so it's fine to skip them.
# Agent is not offered a skip: see the agent-picker section below.

MODEL_DEFAULT_LABEL="(no model override — use Claude Code's default)"
EFFORT_DEFAULT_LABEL="(no effort override — use Claude Code's default)"

# ---- colors (peco renders ANSI codes in its input by default) --------------

typeset -A EFFORT_COLOR
if [[ -z "${NO_COLOR:-}" ]]; then
  COLOR_NAME=$'\e[1;36m'    # bold cyan — custom (project/user) agent names
  COLOR_BUILTIN=$'\e[1;33m' # bold yellow — Claude Code's built-in agent names
  COLOR_MODEL=$'\e[1;35m'   # bold magenta — model names
  COLOR_DIVIDER=$'\e[2m'    # dim — group headers and "(agent default)" hints
  COLOR_RESET=$'\e[0m'
  # Effort as a cheap→expensive heat gradient, same idea as a traffic light.
  EFFORT_COLOR=(low $'\e[38;5;42m' medium $'\e[38;5;118m' high $'\e[38;5;220m' xhigh $'\e[38;5;208m' max $'\e[38;5;196m')
else
  COLOR_NAME=""
  COLOR_BUILTIN=""
  COLOR_MODEL=""
  COLOR_DIVIDER=""
  COLOR_RESET=""
  EFFORT_COLOR=(low "" medium "" high "" xhigh "" max "")
fi

# ---- helpers ----------------------------------------------------------------

# frontmatter_field <file> <field> — print the scalar value of "field: value"
# from the first YAML frontmatter block (between the first two "---" lines).
frontmatter_field() {
  awk -v field="$2" '
    /^---[[:space:]]*$/ { delim++; next }
    delim == 1 && $0 ~ "^" field ":" {
      sub("^" field ":[[:space:]]*", "")
      print
      exit
    }
    delim >= 2 { exit }
  ' "$1"
}

# has_flag <flag> "$@" — true if the arg list contains --flag or --flag=value.
has_flag() {
  local wanted="$1"; shift
  local a
  for a in "$@"; do
    [[ "$a" == "$wanted" || "$a" == "$wanted"=* ]] && return 0
  done
  return 1
}

# strip_ansi <text> — remove ANSI color escapes, so a colorized display
# field never leaks decoration into the value we actually pass to claude.
strip_ansi() {
  print -r -- "$1" | sed $'s/\x1b\\[[0-9;]*m//g'
}

# pick <prompt> <line>... — run peco over the given lines and print the
# chosen line's text before the first TAB (or the whole line, if it has no
# TAB — that's how the "(no override)" sentinel entries round-trip as-is),
# with any color codes stripped out. Returns 1 with no output on cancel.
pick() {
  local prompt="$1"; shift
  local choice
  choice="$(print -l -- "$@" | "$peco_bin" --prompt="$prompt")" || return 1
  [[ -n "$choice" ]] || return 1
  strip_ansi "${choice%%$'\t'*}"
}

# ---- built-in agents (ship with Claude Code, not backed by any file) ------
#
# `claude --agent <bogus>` conveniently echoes its full known-agent list in
# the error message, which is how these were confirmed: every name here is
# accepted by --agent yet has no .claude/agents/*.md file behind it.

BUILTIN_AGENT_NAMES=(general-purpose claude Explore Plan)
typeset -A BUILTIN_AGENT_DESC
BUILTIN_AGENT_DESC[general-purpose]="Researches complex questions, searches code, and executes multi-step tasks."
BUILTIN_AGENT_DESC[claude]="Plain catch-all agent for anything that doesn't fit a more specific one."
BUILTIN_AGENT_DESC[Explore]="Fast read-only search for locating code by pattern, symbol, or keyword."
BUILTIN_AGENT_DESC[Plan]="Software-architect agent for designing an implementation plan before executing."

# ---- discover custom agents for the current repo ---------------------------

typeset -A SEEN_AGENT AGENT_MODEL AGENT_EFFORT
custom_agent_lines=()

for name in $BUILTIN_AGENT_NAMES; do
  SEEN_AGENT[$name]=1 # project/user agents never shadow a built-in name
done

add_agents_from_dir() {
  local dir="$1" file name desc
  [[ -d "$dir" ]] || return 0
  for file in "$dir"/*.md(N); do
    name="$(frontmatter_field "$file" name)"
    [[ -n "$name" ]] || name="${file:t:r}"
    (( ${+SEEN_AGENT[$name]} )) && continue
    SEEN_AGENT[$name]=1
    desc="$(frontmatter_field "$file" description)"
    AGENT_MODEL[$name]="$(frontmatter_field "$file" model)"
    AGENT_EFFORT[$name]="$(frontmatter_field "$file" effort)"
    custom_agent_lines+=("${COLOR_NAME}${name}${COLOR_RESET}"$'\t'"${desc:-(no description)}")
  done
}

repo_root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
add_agents_from_dir "$repo_root/.claude/agents"
add_agents_from_dir "$HOME/.claude/agents"
custom_agent_lines=("${(@o)custom_agent_lines}")

# ---- assemble the grouped agent menu ---------------------------------------

DIVIDER_BUILTIN="${COLOR_DIVIDER}── Built-in agents (Claude Code defaults) ──${COLOR_RESET}"
DIVIDER_CUSTOM="${COLOR_DIVIDER}── Custom agents (this repo) ──${COLOR_RESET}"

agent_lines=("$DIVIDER_BUILTIN")
for name in $BUILTIN_AGENT_NAMES; do
  agent_lines+=("${COLOR_BUILTIN}${name}${COLOR_RESET}"$'\t'"${BUILTIN_AGENT_DESC[$name]}")
done
if (( ${#custom_agent_lines[@]} > 0 )); then
  agent_lines+=("$DIVIDER_CUSTOM" "${custom_agent_lines[@]}")
fi

# ---- pick agent -------------------------------------------------------------
#
# No "use the default agent" shortcut here on purpose: picking one from the
# menu is mandatory, so you always land in a session driven by a specific
# agent — general-purpose is a real, top-of-the-list choice, not a hidden
# fallback you land on by skipping the picker.

agent_name=""
if has_flag --agent "$@"; then
  : # already provided on the command line — skip the picker
else
  agent_name="$(pick "Agent > " "${agent_lines[@]}")" || {
    print -u2 "claudio: cancelled"
    exit 130
  }
  if [[ "$agent_name" == "$(strip_ansi "$DIVIDER_BUILTIN")" || "$agent_name" == "$(strip_ansi "$DIVIDER_CUSTOM")" ]]; then
    print -u2 "claudio: that's a group header, not an agent — run claudio again and pick a real one."
    exit 1
  fi
fi

# ---- pick model ---------------------------------------------------------------

model_name=""
if has_flag --model "$@"; then
  :
else
  agent_model="${AGENT_MODEL[$agent_name]:-}"
  model_lines=()
  [[ -n "$agent_model" ]] && model_lines+=("${COLOR_MODEL}${agent_model}${COLOR_RESET}"$'\t'"${COLOR_DIVIDER}(agent default)${COLOR_RESET}")
  for m in sonnet opus fable haiku; do
    [[ "$m" == "$agent_model" ]] && continue
    model_lines+=("${COLOR_MODEL}${m}${COLOR_RESET}")
  done
  model_name="$(pick "Model > " "${COLOR_DIVIDER}${MODEL_DEFAULT_LABEL}${COLOR_RESET}" "${model_lines[@]}")" || {
    print -u2 "claudio: cancelled"
    exit 130
  }
  [[ "$model_name" == "$MODEL_DEFAULT_LABEL" ]] && model_name=""
fi

# ---- pick effort ----------------------------------------------------------------

effort_name=""
if has_flag --effort "$@"; then
  :
else
  agent_effort="${AGENT_EFFORT[$agent_name]:-}"
  effort_lines=()
  [[ -n "$agent_effort" ]] && effort_lines+=("${EFFORT_COLOR[$agent_effort]}${agent_effort}${COLOR_RESET}"$'\t'"${COLOR_DIVIDER}(agent default)${COLOR_RESET}")
  for e in low medium high xhigh max; do
    [[ "$e" == "$agent_effort" ]] && continue
    effort_lines+=("${EFFORT_COLOR[$e]}${e}${COLOR_RESET}")
  done
  effort_name="$(pick "Effort > " "${COLOR_DIVIDER}${EFFORT_DEFAULT_LABEL}${COLOR_RESET}" "${effort_lines[@]}")" || {
    print -u2 "claudio: cancelled"
    exit 130
  }
  [[ "$effort_name" == "$EFFORT_DEFAULT_LABEL" ]] && effort_name=""
fi

# ---- launch ---------------------------------------------------------------------

claude_args=()
[[ -n "$agent_name" ]] && claude_args+=(--agent "$agent_name")
[[ -n "$model_name" ]] && claude_args+=(--model "$model_name")
[[ -n "$effort_name" ]] && claude_args+=(--effort "$effort_name")

exec "$claude_bin" "${claude_args[@]}" "$@"
