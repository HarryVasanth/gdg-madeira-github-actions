#!/usr/bin/env bash
# Print Heads or Tails.
set -euo pipefail

sides=(Heads Tails)

# shortcut: $RANDOM is predictable. Use `shuf -i 0-1 -n 1` for a fair flip.
echo "${sides[RANDOM % ${#sides[@]}]}"
