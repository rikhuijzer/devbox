#!/usr/bin/env bash

set -e

echo "$HOME/git/last_nvim_write.txt" | entr -s "printf \"  ----------\n\" && $@"
