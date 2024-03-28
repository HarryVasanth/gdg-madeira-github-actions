#!/usr/bin/env bash
# Flips a coin.
set -euo pipefail

sides=(Heads Tails)

# shortcut: $RANDOM is predictable; use `shuf -i 0-1 -n 1` for a fair flip.
echo "${sides[RANDOM % ${#sides[@]}]}"
