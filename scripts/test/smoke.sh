#!/usr/bin/env bash
# Test the random scripts. Run this file from any directory.
# The script stops with an error when a test fails.
set -euo pipefail

cd "$(dirname "${BASH_SOURCE[0]}")/../.."

fail() {
  echo "FAIL: $*" >&2
  exit 1
}

for script in card dice coin; do
  bash "scripts/random/$script.sh" >/dev/null || fail "$script exited non-zero"
done

dice_output="$(bash scripts/random/dice.sh)"
[[ "$(printf '%s\n' "$dice_output" | wc -l | tr -d ' ')" == "5" ]] ||
  fail "dice output should be 5 lines"

card_output="$(bash scripts/random/card.sh)"
[[ "$card_output" == *"┌─────────┐"* ]] || fail "card frame missing"

coin_output="$(bash scripts/random/coin.sh)"
[[ "$coin_output" == "Heads" || "$coin_output" == "Tails" ]] || fail "unexpected coin result"

echo "✅ all script smoke tests passed"
