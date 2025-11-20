#!/usr/bin/env bash

set -e

# -----------------------------
# Default values
# -----------------------------
RED='\033[0;31m'
LIGHT_PURPLE='\033[1;35m'
NC='\033[0m'
ADD_FLAGS=false
RECURSIVE=false
DEBUG=false

# -----------------------------
# Parse flags
# -----------------------------
while getopts "frd" opt; do
  case "$opt" in
    f) ADD_FLAGS=true ;;
    r) RECURSIVE=true ;;
    d) DEBUG=true ;;
    *)
      echo "Usage: $0 [-f] [-r] [-d] <directory>"
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
  echo "Usage: $0 [-f] [-r] [-d] <directory>"
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
eval "$CMD" && echo -e "${LIGHT_PURPLE}COMPILED AS <a.out>${NC}" \
  || { echo -e "${RED}COMPILATION ERROR${NC}"; exit 1; }

if $DEBUG; then
  echo "INPUT:"
  echo
  leaks -list -atExit -- ./a.out 2>/dev/null
fi