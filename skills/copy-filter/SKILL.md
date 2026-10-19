---
name: copy-filter
description: Check user-facing copy before it ships. Run this whenever someone asks whether a string, headline, subtitle, button, label, helper text, error, toast, email, or coaching line is good to go, reads well, or sounds right. Works with or without a project voice profile: the defaults are the nine-point filter (would the owner say this, can they defend it, right length, person or consultant, trust, consistency) plus the hard rules (no em dashes or en dashes, no consultant register such as leverage, robust, ensure, seamless, unlock, reader-first, never sound like an AI). Returns PASS or FAIL per string with the exact issue and a rewrite.
when_to_use: "'check this copy', 'is this good to go', 'review this headline', 'does this subtitle work', 'before it ships', 'proofread this label', any request to judge a piece of user-facing text."
argument-hint: [list of {label, string} pairs, or a file path]
allowed-tools: Read Grep Glob
---

# copy-filter

You are filtering user-facing copy: **$ARGUMENTS**

## Step 1: load the rules

Read `${CLAUDE_PROJECT_DIR}/.claude/review-board/voice.md` if it exists.
Its "Hard rules on copy" and "The pre-flight checklist" sections replace
the defaults below wherever they overlap. If it does not exist, say so
once and use the defaults.

If the argument is a file path, extract the user-facing strings from it
(labels, placeholders, helper text, buttons, headings, toasts, errors,
aria-labels with readable text, email subject lines and bodies) and label
each with where it lives so the result can cite it back.

## Step 2: the nine-point filter, on every string

1. **Would the owner actually say this in their own words?** Read it aloud.
   If it sounds like a brochure or a consultant report, fail.
2. **Can they defend every claim in a follow-up conversation?** No
   superlatives that beg "compared to what?"
3. **Is this the right length for the context?** Buttons terse; helper text
   one sentence; coaching prose can breathe.
4. **Does this repeat something already said nearby?** Reuse without
   refinement is filler.
5. **Does this sound like a person or like a consultant or an AI?** Flags:
   passive voice, "In today's," "journey," "unlock," "seamless."
6. **Does this overclaim or underclaim?** Be precise.
7. **Would this make the intended reader trust the owner more?** Calm,
   second person, action-oriented builds trust. Cliches and over-promises
   erode it.
8. **Is this consistent with every other page, section, and label?** Same
   concept, same word.
9. **Does this leak anything that helps a competitor?**

## Step 3: the hard rules, FAIL on any violation (defaults)

- **No em dashes (U+2014) or en dashes (U+2013).** Flag with the exact
  position. Commas, periods, colons, parentheses instead. The one
  exception: a standalone dash used as an empty-value glyph in a UI cell.
- **No consultant register:** leverage, robust, comprehensive, ensure,
  facilitate, seamless, empower, best-in-class, world-class, synergy.
- **No announcement phrases** ("Here's the thing," "The truth is") and **no
  paired-opposite reveals** ("This isn't X, it's Y").
- **Reader-first.** Lead with what the reader gets, not the system's
  effort. "Build your shortlist" beats "We help you build your shortlist."
- **Never sound like an AI:** no "I'll help you with," "Let me know if,"
  "Feel free to," "I understand that."
- **Second person, present tense, active voice** for direct address.
- **"Working" is the floor, not the ceiling.** Copy that merely describes
  the function correctly is not yet done.

## Step 4: report

```
## copy-filter results

### {label}
Original: "{string}"
Status: PASS / FAIL
Issues:
  - [point 5] Consultant register ("leverage")
  - [hard rule] Em dash at position 24
Rewrite: "{proposed fix, preserving meaning}"

## Summary
{N pass} / {M total}. {failures listed by label}.
```

If every string passes: "All N strings pass. No rewrites needed."

## When to skip a string

- Not user-facing: variable names, JSON keys, ARIA roles like `button`.
- From an external source surfaced as-is (a government dataset's job
  title). Note the source; do not rewrite.
- Legal or reference text (Terms, Privacy): apply only the em-dash rule.
  Plain and neutral is correct there.
- Locked copy approved verbatim in a prior review: cite where it was
  locked.

## What this skill is not

Not a grammar checker. Not a translator. Not optional for user-facing
strings.
