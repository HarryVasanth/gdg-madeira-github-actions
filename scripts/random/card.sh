#!/usr/bin/env bash
# Print one random playing card as ASCII art.
set -euo pipefail

suits=("♠" "♥" "♦" "♣")
ranks=(A 2 3 4 5 6 7 8 9 10 J Q K)

# shortcut: $RANDOM is predictable. Use `shuf -i 0-51 -n 1` when the draw must be fair.
suit=${suits[RANDOM % ${#suits[@]}]}
rank=${ranks[RANDOM % ${#ranks[@]}]}

printf '┌─────────┐\n'
printf '│%-2s       │\n' "$rank"
printf '│         │\n'
printf '│    %s    │\n' "$suit"
printf '│         │\n'
printf '│       %-2s│\n' "$rank"
printf '└─────────┘\n'
