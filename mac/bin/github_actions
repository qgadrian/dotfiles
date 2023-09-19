#!/usr/bin/env bash

set -Eeuo pipefail
trap cleanup SIGINT SIGTERM ERR EXIT

script_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd -P)

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-v] -p param_value arg1 [arg2...]

Script description here.

Available options:

-h, --help          Print this help and exit
-v, --verbose       Print script debug info
-o, --owner         The owner of the organization
-w, --workflow-id   The file name of the GitHub actions workflow
-r, --release-name  The name of the release
EOF
  exit
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

msg() {
  echo >&2 -e "${1-}"
}

die() {
  local msg=$1
  local code=${2-1} # default exit status 1
  msg "$msg"
  exit "$code"
}

parse_params() {
  # default values of variables set from params
  flag=0
  OWNER=''
  WORKFLOW_ID=''
  RELEASE_NAME=''

  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -v | --verbose) set -x ;;
    --no-color) NO_COLOR=1 ;;
    -f | --flag) flag=1 ;; # example flag
    -o | --OWNER)
      OWNER="${2-}"
      shift
      ;;
    -w | --workflow-id)
      WORKFLOW_ID="${2-}"
      shift
      ;;
    -r | --release-name)
      RELEASE_NAME="${2-}"
      shift
      ;;
    -?*) die "Unknown option: $1" ;;
    *) break ;;
    esac
    shift
  done

  args=("$@")

  # check required params and arguments
  [[ -z "${OWNER-}" ]] && die "Missing required parameter: owner"
  [[ -z "${WORKFLOW_ID-}" ]] && die "Missing required parameter: workflow-id"
  [[ -z "${RELEASE_NAME-}" ]] && die "Missing required parameter: release-name"
  # [[ ${#args[@]} -eq 0 ]] && die "Missing script arguments"

  return 0
}

parse_params "$@"
setup_colors

CURRENT_PATH_PROJECT=$(git remote get-url origin | xargs basename -s .git)
URL=https://api.github.com/repos/$OWNER/$CURRENT_PATH_PROJECT/actions/workflows/$WORKFLOW_ID/dispatches
REQUEST_BODY="{\"ref\":\"{}\",\"inputs\":{\"release_name\":\"$RELEASE_NAME\"}}"

GITHUB_RESPONSE_CODE=$(git branch --sort=-committerdate -l | peco | sed 's/\* //g' | xargs -I{} curl \
    -X POST \
    -H "Authorization: token $GITHUB_ACTIONS_TOKEN" \
    -H "Accept: application/vnd.github.v3+json" \
    $URL \
    -d $REQUEST_BODY \
    --silent \
    --write-out %{http_code})

if [[ "$GITHUB_RESPONSE_CODE" -ne 204 ]] ; then
  msg "${RED}GitHub actions trigger failed: error ${GITHUB_RESPONSE_CODE}${NOFORMAT}"
  msg "${RED}Read parameters:${NOFORMAT}"
  # msg "- flag: ${flag}"
  msg "- owner: ${OWNER}"
  msg "- workflow-id: ${WORKFLOW_ID}"
  msg "- release-name: ${RELEASE_NAME}"
else
  msg "${GREEN}GitHub actions trigger successful${NOFORMAT}"
fi

# msg "${RED}Read parameters:${NOFORMAT}"
# msg "- flag: ${flag}"
# msg "- owner: ${OWNER}"
# msg "- workflow-id: ${WORKFLOW_ID}"
# msg "- release-name: ${RELEASE_NAME}"
# msg "- arguments: ${args[*]-}"
