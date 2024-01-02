#!/usr/bin/env bash

set -e

if [[ "$#" -eq 0 ]]; then
  echo "Usage: $0 <command>"
  exit 1
fi

echo "$HOME/git/last_nvim_write.txt" | entr -s "printf \"  ----------\n\" && $@"
