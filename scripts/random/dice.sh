#!/usr/bin/env bash
# Rolls a six-sided die and prints it as ASCII art.
set -euo pipefail

faces=(
  $'+-------+\n|       |\n|   o   |\n|       |\n+-------+'
  $'+-------+\n| o     |\n|       |\n|     o |\n+-------+'
  $'+-------+\n| o     |\n|   o   |\n|     o |\n+-------+'
  $'+-------+\n| o   o |\n|       |\n| o   o |\n+-------+'
  $'+-------+\n| o   o |\n|   o   |\n| o   o |\n+-------+'
  $'+-------+\n| o o o |\n|       |\n| o o o |\n+-------+'
)

# shortcut: $RANDOM is predictable; use `shuf -i 1-6 -n 1` for a fair roll.
printf '%b\n' "${faces[RANDOM % ${#faces[@]}]}"
