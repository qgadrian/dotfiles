#!/usr/bin/env bash
# Claude Code statusLine command
# Segments: [branch|worktree] | model (effort) | ctx% | 5h% | total%

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
ctx_used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
exceeds_200k=$(echo "$input" | jq -r '.exceeds_200k_tokens // false')
five_hour_used=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_day_used=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')
effort_level=$(echo "$input" | jq -r '.effort.level // empty')

# ---------------------------------------------------------------------------
# Segment 1: branch or worktree name
# ---------------------------------------------------------------------------
branch_label=""
is_dirty=""

worktree_name=$(echo "$input" | jq -r '.worktree.name // empty')
abs_cwd="${cwd/#\~/$HOME}"

if [ -n "$worktree_name" ]; then
  branch_label="$worktree_name"
else
  git_dir=$(git -C "$abs_cwd" rev-parse --git-dir 2>/dev/null)
  if [ -n "$git_dir" ]; then
    abs_git_dir=$(cd "$abs_cwd" && git rev-parse --absolute-git-dir 2>/dev/null || true)
    case "$abs_git_dir" in
      */.git/worktrees/*)
        branch_label=$(basename "$abs_git_dir")
        ;;
      *)
        branch_label=$(git -C "$abs_cwd" branch --show-current 2>/dev/null || git -C "$abs_cwd" rev-parse --short HEAD 2>/dev/null || true)
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
# ANSI colors
# ---------------------------------------------------------------------------
YELLOW=$'\033[33m'
ORANGE=$'\033[38;5;208m'
RED=$'\033[31m'
BLUE=$'\033[34m'
RESET=$'\033[0m'

# ---------------------------------------------------------------------------
# Color helpers
# ---------------------------------------------------------------------------
# Context: default → yellow at 25 → red above 45
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

# Usage (5h / total): default → yellow at 50 → orange at 75 → red at 90
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

fmt_pct() {
  local label="$1"
  local value="$2"
  local color="$3"
  local n
  n=$(printf '%.0f' "$value")
  if [ -n "$color" ]; then
    printf '%s: %s%s%%%s' "$label" "$color" "$n" "$RESET"
  else
    printf '%s: %s%%' "$label" "$n"
  fi
}

# ---------------------------------------------------------------------------
# Compose: branch | model | ctx% | 5h% | total%
# ---------------------------------------------------------------------------
parts=()

if [ -n "$branch_label" ]; then
  if [ -n "$is_dirty" ]; then
    parts+=("${YELLOW}${branch_label}${RESET} ${ORANGE}●${RESET}")
  else
    parts+=("${YELLOW}${branch_label}${RESET}")
  fi
fi
if [ -n "$model" ]; then
  if [ -n "$effort_level" ]; then
    parts+=("${BLUE}${model} (${effort_level})${RESET}")
  else
    parts+=("${BLUE}${model}${RESET}")
  fi
fi

if [ -n "$ctx_used" ]; then
  ctx_seg="$(fmt_pct "ctx" "$ctx_used" "$(color_ctx "$ctx_used")")"
  if [ "$ctx_size" = "1000000" ]; then
    if [ "$exceeds_200k" = "true" ]; then
      ctx_seg="${ctx_seg} ${RED}[1M]${RESET}"
    else
      ctx_seg="${ctx_seg} [1M]"
    fi
  fi
  parts+=("$ctx_seg")
fi

if [ -n "$five_hour_used" ]; then
  seg="$(fmt_pct "5h" "$five_hour_used" "$(color_usage "$five_hour_used")")"
  n=$(printf "%.0f" "$five_hour_used")
  if [ "$n" -gt 20 ] && [ -n "$five_hour_resets" ]; then
    seg="${seg} (↻$(fmt_until "$five_hour_resets"))"
  fi
  parts+=("$seg")
fi

if [ -n "$seven_day_used" ]; then
  seg="$(fmt_pct "total" "$seven_day_used" "$(color_usage "$seven_day_used")")"
  n=$(printf "%.0f" "$seven_day_used")
  if [ "$n" -gt 20 ] && [ -n "$seven_day_resets" ]; then
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
