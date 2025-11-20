#!/usr/bin/env bash

set -e

# -----------------------------
# Default values
# -----------------------------
RED='\033[0;31m'
LIGHT_PURPLE='\033[1;35m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

ADD_FLAGS=false
RECURSIVE=false
DEBUG=false
EXECUTE=false

spinner() {
  local msg="$1"
  local pid="$2"
  local delay=0.07
  local frames=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
  local i=0

  printf "%s " "$msg"
  while kill -0 "$pid" 2>/dev/null; do
    printf "\r%s %s" "$msg" "${frames[$((i++ % ${#frames[@]}))]}"
    sleep "$delay"
  done
  # printf "\r%s... done\n" "$msg"
}

# -----------------------------
# Parse flags
# -----------------------------
while getopts "frde" opt; do
  case "$opt" in
    f) ADD_FLAGS=true ;;
    r) RECURSIVE=true ;;
    d) DEBUG=true ;;
    e) EXECUTE=true ;;
    *)
      echo "Usage: $0 [-f] [-r] [-d] [-e] <directory>"
      exit 1
      ;; 
  esac
done

shift $((OPTIND - 1))

# -----------------------------
# Directory argument
# -----------------------------
if [ -z "$1" ]; then
  echo -e "${RED}Error: directory path not provided.${NC}"
  echo "Usage: $0 [-f] [-r] [-d] [-e] <directory>"
  exit 1
fi

DIR="$1"

if [ ! -d "$DIR" ]; then
  echo -e "${RED}Error: '$DIR' is not a directory${NC}"
  exit 1
fi

# -----------------------------
# Collect files
# -----------------------------
if $RECURSIVE; then
  CPP_FILES=$(find "$DIR" -name "*.cpp" | tr '\n' ' ')
else
  CPP_FILES=$(find "$DIR" -maxdepth 1 -name "*.cpp" | tr '\n' ' ')
fi

CPP_FILES=$(echo "$CPP_FILES" | sed 's/ *$//')

if [ -z "$CPP_FILES" ]; then
  echo -e "${RED}No .cpp files found.${RED}"
  exit 1
fi

# -----------------------------
# Build compiler command
# -----------------------------
CMD="clang++"

if $ADD_FLAGS; then
  CMD+=" -Wall -Wextra -Wpedantic -Werror"
fi

if $DEBUG; then
  CMD+=" -g"
fi

CMD+=" $CPP_FILES "

# -----------------------------
# Run compilation
# -----------------------------
echo "$CMD" | pbcopy

# eval "$CMD" && echo -e "${LIGHT_PURPLE}COMPILED AS - < a.out >${NC}" \
#   || { echo -e "${RED}COMPILATION ERROR${NC}"; exit 1; }

eval "$CMD" &
compile_pid=$!
spinner "COMPILING" "$compile_pid"
echo

if ! wait "$compile_pid"; then
  echo -e "${RED}COMPILATION ERROR${NC}"
  exit 1
fi

echo -e "${LIGHT_PURPLE}COMPILED AS - < a.out >${NC}"


if $DEBUG; then
  echo
  leaks -list -atExit -- ./a.out 2>/dev/null
elif $EXECUTE; then 
  tmp_out=$(mktemp)
  "$DIR"/a.out >"$tmp_out" 2>&1 &
  run_pid=$!

  spinner "RUNNING" "$run_pid"
  echo

  wait "$run_pid"
  status=$?

  echo 
  cat "$tmp_out"
  rm -f "$tmp_out"

  exit "$status"
fi