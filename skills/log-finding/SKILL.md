---
name: log-finding
description: Append a finding to the project's findings ledger (docs/findings-ledger.md by default). Use the moment you notice something that needs fixing but is not what you are doing right now, and before you continue the current work. Covers defects found in passing, deferred decisions, stale docs, missing coverage, and anything a reviewer flagged that is not being fixed in the current change. Ten seconds now, or it is gone.
argument-hint: [what you found, in one sentence]
allowed-tools: Read Edit Write Bash
---

# log-finding

Append one entry to the findings ledger. Small, fast, done in the same
turn you noticed the thing: **$ARGUMENTS**

## Why this exists

Findings get scattered across commit messages, PR bodies, review output,
and chat, and the ones that survive only in conversation are lost when the
session ends. The failure mode is not "we lack a place to write it down."
It is **noticing something and continuing past it**, because the current
task has momentum and the finding feels like a detour.

## Where the ledger is

`${CLAUDE_PROJECT_DIR}/.claude/review-board/board.md` names it under "Where
things live." Default: `${CLAUDE_PROJECT_DIR}/docs/findings-ledger.md`. If
it does not exist, create it from
`${CLAUDE_PLUGIN_ROOT}/templates/findings-ledger.md` and remove the example
entry.

## When to use it

The trigger is a thought, not a task type:

- "That is wrong, but it is not what I am fixing."
- "Someone should look at that."
- "That will bite us later."
- "I will mention it in the PR body." (You will. That is not enough.)
- A reviewer raised something real and it is out of scope for this change.
- You found a second bug while fixing the first.
- You deferred a decision, and the reason matters.
- You fixed something and noticed the same class elsewhere. The sibling
  instance is the one that gets forgotten.

## When NOT to use it

- You can fix it right now, in under a minute, in scope. Just fix it.
- It is a preference, not a defect. Something has to be wrong, missing, or
  misleading.
- It is already in the ledger. Read the file first. A duplicate inflates
  the count and hides the real backlog.
- It is speculative and you have not looked. Either verify it, or say
  plainly in the entry that it is unverified and what would confirm it.
  Never log a guess as a fact.

## The entry

Every entry carries five things. One missing makes it useless to whoever
picks it up cold.

1. **A title that names the defect**, not the area. "Button.tsx tap target
   is 36px" beats "button issues."
2. **The file and line**, when there is one.
3. **What it costs**, concretely: who hits it, when, what they see.
4. **Provenance**: who found it, when, verified or suspected. If a named
   reviewer raised it, say which; their reasoning is the fastest way back
   into the problem.
5. **Status and owner**: `OPEN`, `FIXED (#PR)`, `ACCEPTED (reason)`, or
   `SUPERSEDED (by F-NNN)`. An entry with no owner is a wish.

Entries are a flat `F-NNN` sequence under dated section headings for the
sweep or review that found them. No priority bands: a band is a judgement
that goes stale, a status is a fact you can re-check. Severity lives in
the cost line.

## Citing code: say which tree

An unqualified `file:line` means the default branch. A citation from an
unmerged branch carries a `Verified against:` line with the branch, the
PR, and the commit SHA, plus what re-verification is owed on merge. Line
numbers on an open branch move; one that moved seventeen lines before
merge sent a reader to the wrong check.

## Process

1. Read the ledger. Check for a duplicate.
2. Append with the next `F-NNN`, under the dated section for this review
   or sweep. Start a new dated section if there is not one.
3. Say one line to the decider that you logged it, with the `F-NNN`. Do
   not stop the current work, do not write a paragraph, do not ask
   whether to log it.

## The rule this enforces

Log it in the turn you notice it. Not at the end of the task, not in the
PR body, not "when I circle back." A finding deferred to later is a
finding lost.
