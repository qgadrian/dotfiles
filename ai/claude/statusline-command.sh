#!/usr/bin/env bash
# Claude Code statusLine command
# Segments: [worktree|branch] | issue | PR | 🪐 model effort | 🧠 ctx% | ♨️ cache | ⏳ 5h% | 📅 total%

input=$(cat)

# One jq pass for every field: 13 separate invocations cost ~105ms per render,
# and the statusline re-runs on every assistant message plus the refreshInterval
# tick. Fields are emitted one per line, read back in the same order; "-" stands
# in for absent so blank lines never desync the read.
IFS=$'\n' read -r -d '' cwd model ctx_used ctx_size exceeds_200k \
  five_hour_used seven_day_used five_hour_resets seven_day_resets \
  effort_level transcript_path pr_number worktree_name \
  < <(printf '%s' "$input" | jq -r '
        [ .workspace.current_dir // .cwd, .model.display_name,
          .context_window.used_percentage, .context_window.context_window_size,
          (.exceeds_200k_tokens // false),
          .rate_limits.five_hour.used_percentage, .rate_limits.seven_day.used_percentage,
          .rate_limits.five_hour.resets_at, .rate_limits.seven_day.resets_at,
          .effort.level, .transcript_path, .pr.number, .worktree.name ]
        | map(if . == null or . == "" then "-" else tostring end) | .[]' ; printf '\0')

for _v in cwd model ctx_used ctx_size exceeds_200k five_hour_used seven_day_used \
          five_hour_resets seven_day_resets effort_level transcript_path \
          pr_number worktree_name; do
  [ "${!_v}" = "-" ] && printf -v "$_v" '%s' ""
done

# ---------------------------------------------------------------------------
# Git context: worktree vs branch name, real branch, and dirty flag
# ---------------------------------------------------------------------------
branch_label=""    # what we display (worktree name, else branch)
is_worktree=""     # "1" when this checkout is a linked worktree
branch=""          # real git branch, used for issue/PR inference
is_dirty=""

abs_cwd="${cwd/#\~/$HOME}"

if [ -n "$worktree_name" ]; then
  branch_label="$worktree_name"
  is_worktree="1"
fi

git_dir=$(git -C "$abs_cwd" rev-parse --git-dir 2>/dev/null)
if [ -n "$git_dir" ]; then
  branch=$(git -C "$abs_cwd" branch --show-current 2>/dev/null || true)
  if [ -z "$branch_label" ]; then
    abs_git_dir=$(cd "$abs_cwd" && git rev-parse --absolute-git-dir 2>/dev/null || true)
    case "$abs_git_dir" in
      */.git/worktrees/*)
        branch_label=$(basename "$abs_git_dir")
        is_worktree="1"
        ;;
      *)
        branch_label="${branch:-$(git -C "$abs_cwd" rev-parse --short HEAD 2>/dev/null || true)}"
        ;;
    esac
  fi
fi

# Dirty check: any uncommitted change (tracked or untracked) marks the branch.
if [ -n "$branch_label" ] && [ -d "$abs_cwd" ]; then
  if [ -n "$(git -C "$abs_cwd" status --porcelain 2>/dev/null | head -n1)" ]; then
    is_dirty="1"
  fi
fi

# ---------------------------------------------------------------------------
# Issue reference, inferred from the branch name
#   GitHub convention:      <type>/<number>-<slug>    ->  "#4233"
#   Linear (when adopted):  <user>/<team>-<n>-<slug>  ->  "TAB-42"
# Set LINEAR_PREFIXES to your Linear team key(s) once you switch. Pinning to a
# known key avoids matching slug words such as "node-18" as if they were issues.
# ---------------------------------------------------------------------------
# Linear team key(s) are kept OUT of version control (this file is committed).
# Set them locally, via either:
#   1. env var:   export CLAUDE_STATUSLINE_LINEAR_PREFIXES="<team-key>"
#   2. local file ~/.config/claude/statusline.local.sh  ->  LINEAR_PREFIXES="<team-key>"
# Pipe-separate multiple keys, e.g. "ENG|OPS". If unset, Linear detection is
# skipped and the GitHub #N fallback still works.
LINEAR_PREFIXES="${CLAUDE_STATUSLINE_LINEAR_PREFIXES:-}"
if [ -z "$LINEAR_PREFIXES" ]; then
  _sl_local="${XDG_CONFIG_HOME:-$HOME/.config}/claude/statusline.local.sh"
  [ -f "$_sl_local" ] && . "$_sl_local"
fi
issue_ref=""
if [ -n "$branch" ]; then
  linear=""
  if [ -n "$LINEAR_PREFIXES" ]; then
    linear=$(printf '%s' "$branch" | grep -oiE "(^|/)(${LINEAR_PREFIXES})-[0-9]+" | grep -oiE "(${LINEAR_PREFIXES})-[0-9]+" | head -n1)
  fi
  if [ -n "$linear" ]; then
    issue_ref=$(printf '%s' "$linear" | tr 'a-z' 'A-Z')
  else
    num=$(printf '%s' "$branch" | grep -oE '(^|/)#?[0-9]{2,}' | grep -oE '[0-9]+' | head -n1)
    [ -n "$num" ] && issue_ref="#${num}"
  fi
fi

# ---------------------------------------------------------------------------
# ANSI colors
# ---------------------------------------------------------------------------
YELLOW=$'\033[33m'
ORANGE=$'\033[38;5;208m'
RED=$'\033[31m'
CYAN=$'\033[36m'
GREY=$'\033[38;5;245m'
ESC=$'\033'
RESET=$'\033[0m'

# ---------------------------------------------------------------------------
# Color helpers
# ---------------------------------------------------------------------------
# Context: default -> yellow at 25 -> red above 45
color_ctx() {
  local v="$1"
  # integer compare on rounded value
  local n
  n=$(printf '%.0f' "$v")
  if   [ "$n" -gt 45 ]; then printf '%s' "$RED"
  elif [ "$n" -ge 25 ]; then printf '%s' "$YELLOW"
  else printf '%s' ""
  fi
}

# Usage (5h / total): default -> yellow at 50 -> orange at 75 -> red at 90
color_usage() {
  local v="$1"
  local n
  n=$(printf '%.0f' "$v")
  if   [ "$n" -ge 90 ]; then printf '%s' "$RED"
  elif [ "$n" -ge 75 ]; then printf '%s' "$ORANGE"
  elif [ "$n" -ge 50 ]; then printf '%s' "$YELLOW"
  else printf '%s' ""
  fi
}


# Effort level: grey -> cyan -> yellow -> orange -> red as the spend climbs.
color_effort() {
  case "$1" in
    low)    printf '%s' "$GREY"   ;;
    medium) printf '%s' "$CYAN"   ;;
    high)   printf '%s' "$YELLOW" ;;
    xhigh)  printf '%s' "$ORANGE" ;;
    max)    printf '%s' "$RED"    ;;
    *)      printf '%s' "$YELLOW" ;;
  esac
}

# Emoji + name color per model family, matched on a substring of the display
# name so it survives version bumps ("Opus 5" -> "Opus 6" keeps its planet).
# Each color is the dominant hue of its own emoji glyph, picked to stay clear
# of the effort ramp above so the two adjacent words never blur together.
model_style() {   # -> "<emoji> <xterm-256 color>"
  case "$(printf '%s' "$1" | tr 'A-Z' 'a-z')" in
    *fable*)  printf '🦄 177' ;;   # orchid — the mane
    *opus*)   printf '🪐 220' ;;   # gold   — the planet
    *sonnet*) printf '🪶 230' ;;   # ivory  — the feather
    *haiku*)  printf '🍃 114' ;;   # green  — the leaf
    *)        printf '✨ 252' ;;   # unknown model: neutral
  esac
}

# Compact human duration from now until a Unix epoch seconds value.
# Examples: "45m", "2h15m", "3d4h", "<1m".
fmt_until() {
  local target="$1"
  local now diff d h m
  now=$(date +%s)
  diff=$(( target - now ))
  if [ "$diff" -le 0 ]; then printf '%s' "now"; return; fi
  if [ "$diff" -lt 60 ]; then printf '%s' "<1m"; return; fi
  if [ "$diff" -lt 3600 ]; then
    m=$(( diff / 60 ))
    printf '%dm' "$m"; return
  fi
  if [ "$diff" -lt 86400 ]; then
    h=$(( diff / 3600 ))
    m=$(( (diff % 3600) / 60 ))
    if [ "$m" -eq 0 ]; then printf '%dh' "$h"
    else printf '%dh%dm' "$h" "$m"
    fi
    return
  fi
  d=$(( diff / 86400 ))
  h=$(( (diff % 86400) / 3600 ))
  if [ "$h" -eq 0 ]; then printf '%dd' "$d"
  else printf '%dd%dh' "$d" "$h"
  fi
}

# The label is emitted verbatim, so callers own their emoji and separator
# ("🧠 ctx:"); only the percentage and its color are formatted here.
fmt_pct() {
  local label="$1"
  local value="$2"
  local color="$3"
  local n
  n=$(printf '%.0f' "$value")
  if [ -n "$color" ]; then
    printf '%s %s%s%%%s' "$label" "$color" "$n" "$RESET"
  else
    printf '%s %s%%' "$label" "$n"
  fi
}

# ---------------------------------------------------------------------------
# Compose: worktree | issue | PR | model | ctx% | 5h% | total%
# ---------------------------------------------------------------------------
parts=()

if [ -n "$branch_label" ]; then
  if [ -n "$is_worktree" ]; then wt_prefix="worktree"; else wt_prefix="branch"; fi
  if [ -n "$is_dirty" ]; then
    parts+=("${wt_prefix}: ${YELLOW}${branch_label}${RESET} ${ORANGE}●${RESET}")
  else
    parts+=("${wt_prefix}: ${YELLOW}${branch_label}${RESET}")
  fi
fi

if [ -n "$issue_ref" ]; then
  parts+=("issue: ${CYAN}${issue_ref}${RESET}")
fi

if [ -n "$pr_number" ]; then
  parts+=("PR: ${CYAN}${pr_number}${RESET}")
fi

if [ -n "$model" ]; then
  # Bold on the name, plain on the effort: the weight difference keeps the two
  # readable side by side even when their hues sit close (gold Opus / amber high).
  read -r m_emoji m_color <<< "$(model_style "$model")"
  model_seg="${m_emoji} ${ESC}[1;38;5;${m_color}m${model}${RESET}"
  if [ -n "$effort_level" ]; then
    model_seg="${model_seg} $(color_effort "$effort_level")${effort_level}${RESET}"
  fi
  parts+=("$model_seg")
fi

if [ -n "$ctx_used" ]; then
  ctx_seg="$(fmt_pct "🧠 ctx:" "$ctx_used" "$(color_ctx "$ctx_used")")"
  if [ "$ctx_size" = "1000000" ]; then
    if [ "$exceeds_200k" = "true" ]; then
      ctx_seg="${ctx_seg} ${RED}[1M]${RESET}"
    else
      ctx_seg="${ctx_seg} [1M]"
    fi
  fi
  parts+=("$ctx_seg")
fi

# ---------------------------------------------------------------------------
# Prompt-cache freshness. Concept credit: KatsuJinCode/claude-cache-countdown
# (MIT); this is an original implementation — no hooks, no ticker process, no
# sounds.
#
# The clock is the timestamp of the last transcript entry that carries a usage
# block, i.e. the last actual API request — NOT the transcript file's mtime.
# Claude Code appends non-API entries (custom-title, last-prompt, mode,
# file-history-snapshot, agent-setting) and rewrites the file on resume, so
# mtime runs ahead of the last request: measured across 854 local transcripts,
# median skew 232s and 19% skewed by over an hour. An hour-stale mtime reads as
# a fully warm cache, which is exactly backwards on the resume path where this
# segment matters most.
#
# TTL is read from the same entry: cache_creation reports the bucket the request
# actually used (ephemeral_1h_input_tokens vs ephemeral_5m_input_tokens), so no
# guessing. CLAUDE_CACHE_TTL_SECONDS still overrides.
#
# Anthropic refreshes the entry on every use and measures the lifetime from the
# START of the writing/reading request, so this reads optimistic by one turn
# duration (locally p99 38s, max 236s — under 7% of a 1h TTL, but material if a
# session ever falls back to the 5m bucket).
#
# The statusline's own refreshInterval keeps the countdown ticking while idle.
# ---------------------------------------------------------------------------
cache_epoch=""
cache_ttl="${CLAUDE_CACHE_TTL_SECONDS:-}"
if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
  # Tail a bounded window: a 66MB transcript resolves in ~16ms, and the last
  # request is nearly always inside it. Widen once before giving up.
  for win in 262144 4194304; do
    last_req=$(tail -c "$win" "$transcript_path" 2>/dev/null | grep -a '"cache_read_input_tokens"' | tail -n 1)
    [ -n "$last_req" ] && break
  done
  if [ -n "$last_req" ]; then
    ts=$(printf '%s' "$last_req" | grep -aoE '"timestamp":"[^"]+"' | tail -n 1 | cut -d'"' -f4)
    if [ -n "$ts" ]; then
      cache_epoch=$(TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "${ts%%.*}" +%s 2>/dev/null \
        || date -u -d "$ts" +%s 2>/dev/null || true)
    fi
    if [ -z "$cache_ttl" ]; then
      case "$last_req" in
        *'ephemeral_1h_input_tokens":'[1-9]*) cache_ttl=3600 ;;
        *'ephemeral_5m_input_tokens":'[1-9]*) cache_ttl=300  ;;
      esac
    fi
  fi
fi
[ -n "$cache_ttl" ] || cache_ttl=3600

if [ -n "$cache_epoch" ] && [ "$cache_epoch" -gt 0 ] 2>/dev/null && [ "$cache_ttl" -gt 0 ] 2>/dev/null; then
  cache_left=$(( cache_ttl - ( $(date +%s) - cache_epoch ) ))
  if [ "$cache_left" -le 0 ]; then
    parts+=("❄️ cache: ${GREY}cold${RESET}")
  else
    # Ceil to whole minutes so a warm cache never reads "0m".
    cache_min=$(( (cache_left + 59) / 60 ))
    cache_pct=$(( cache_left * 100 / cache_ttl ))
    # Ramp on share of TTL left, so it scales to any TTL (1h or 5m alike).
    if   [ "$cache_pct" -le 10 ]; then cache_color="$RED"
    elif [ "$cache_pct" -le 25 ]; then cache_color="$ORANGE"
    elif [ "$cache_pct" -le 50 ]; then cache_color="$YELLOW"
    else cache_color=""
    fi
    if [ -n "$cache_color" ]; then
      parts+=("♨️ cache: ${cache_color}${cache_min}m${RESET}")
    else
      parts+=("♨️ cache: ${cache_min}m")
    fi
  fi
fi

if [ -n "$five_hour_used" ]; then
  seg="$(fmt_pct "⏳ 5h:" "$five_hour_used" "$(color_usage "$five_hour_used")")"
  if [ -n "$five_hour_resets" ]; then
    seg="${seg} (↻$(fmt_until "$five_hour_resets"))"
  fi
  parts+=("$seg")
fi

if [ -n "$seven_day_used" ]; then
  seg="$(fmt_pct "📅 total:" "$seven_day_used" "$(color_usage "$seven_day_used")")"
  if [ -n "$seven_day_resets" ]; then
    seg="${seg} (↻$(fmt_until "$seven_day_resets"))"
  fi
  parts+=("$seg")
fi

# Join with " | "
sep=" | "
result=""
for part in "${parts[@]}"; do
  if [ -z "$result" ]; then
    result="$part"
  else
    result="${result}${sep}${part}"
  fi
done

printf '%s\n' "$result"
