#!/usr/bin/env bash
set -euo pipefail
mkdir -p .claude/review-board
cat > .claude/review-board/board.md <<'B'
# Brief

## Where things live

Findings ledger: none. Findings go to Linear, and the decider files them.
B
