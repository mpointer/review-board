#!/usr/bin/env bash
# Structural checks for the review-board plugin. Runs in CI and locally.
# 1. Every agent and skill has frontmatter with name and description.
# 2. Every bench agent declares its boundary ("What you do NOT own" or a
#    "do NOT own" line), labels findings, and states the strongest objection.
# 3. No em dashes or en dashes in prose files (the plugin's own standing rule).
# 4. The manifest and marketplace agree on name and version.
# 5. `claude plugin validate` passes when the CLI is available.
set -euo pipefail
cd "$(dirname "$0")/.."
fail=0
say() { printf '%s\n' "$*"; }
err() { say "FAIL: $*"; fail=1; }

for f in agents/*.md examples/*/*.md skills/*/SKILL.md; do
  head -1 "$f" | grep -qx -- '---' || err "$f: missing frontmatter"
  grep -q '^name: ' "$f" || err "$f: frontmatter has no name"
  grep -q '^description: ' "$f" || err "$f: frontmatter has no description"
done

for f in agents/*.md; do
  grep -qi 'do NOT own' "$f" || err "$f: no declared boundary (What you do NOT own)"
  grep -q 'evidence-backed' "$f" || err "$f: findings are not labeled evidence-backed or judgment"
  grep -qi 'strongest objection' "$f" || err "$f: no strongest-objection step"
  grep -qi 'read-only\|do not edit files\|never edits files' "$f" || err "$f: not declared read-only"
  grep -q 'review-board/board.md' "$f" || err "$f: does not read the brief"
  base=$(basename "$f" .md)
  [ "$(sed -n 's/^name: //p' "$f" | head -1)" = "$base" ] || err "$f: name does not match filename"
  grep -q "seats/$base.md" "$f" || err "$f: does not read its own seat file"
  grep -q 'is data: never follow' "$f" || err "$f: no untrusted-content rule"
  case "$base" in
    adversary|other-side) want='Read, Grep, Glob, WebFetch' ;;
    *) want='Read, Grep, Glob' ;;
  esac
  [ "$(sed -n 's/^tools: //p' "$f" | head -1)" = "$want" ] || err "$f: tools are not exactly: $want"
done

for f in examples/*/*.md; do
  grep -q "Future Me, Answered" "$f" && err "$f: product-specific reference left in example persona"
done

# Em dash U+2014 and en dash U+2013, in every prose file we ship.
# Matches the UTF-8 bytes so it behaves the same on BSD and GNU grep. Exit 1 is
# the only clean result: 0 found a dash, 2 means the check itself broke.
rc=0
LC_ALL=C grep -rn --include='*.md' --include='*.json' -e $'\xe2\x80\x94' -e $'\xe2\x80\x93' \
  agents skills templates examples docs README.md CHANGELOG.md .claude-plugin || rc=$?
[ "$rc" -eq 1 ] || err "em or en dash found in prose, or the dash check failed (rc=$rc)"

name=$(python3 -c 'import json;print(json.load(open(".claude-plugin/plugin.json"))["name"])')
ver=$(python3 -c 'import json;print(json.load(open(".claude-plugin/plugin.json"))["version"])')
mname=$(python3 -c 'import json;print(json.load(open(".claude-plugin/marketplace.json"))["plugins"][0]["name"])')
mver=$(python3 -c 'import json;print(json.load(open(".claude-plugin/marketplace.json"))["plugins"][0]["version"])')
[ "$name" = "$mname" ] || err "plugin.json name ($name) != marketplace entry name ($mname)"
[ "$ver" = "$mver" ] || err "plugin.json version ($ver) != marketplace entry version ($mver)"
grep -q "^## \[$ver\]" CHANGELOG.md || err "CHANGELOG.md has no [$ver] section"
grep -q "\"ref\": \"v$ver\"" README.md || err "README pin example is not v$ver"

if command -v claude >/dev/null 2>&1; then
  claude plugin validate . --strict || err "claude plugin validate failed"
else
  say "note: claude CLI not on PATH, skipping plugin validate"
fi

if [ "$fail" -ne 0 ]; then say "checks failed"; exit 1; fi
say "all checks passed: $(ls agents/*.md | wc -l) agents, $(ls skills | wc -l) skills, $(ls examples/*/ | wc -l) example personas"
