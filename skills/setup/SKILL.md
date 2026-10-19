---
name: setup
description: Bootstrap the review board for this project. Creates .claude/review-board/ with the brief (board.md), the sign-off matrix, and optionally a voice profile for the founder-voice gate, by asking the decider a short set of questions and writing the files from the plugin's templates. Run once per project, and again when the product, the audiences, or the standing rules change. Every gate reads these files before it reviews anything.
argument-hint: [optional: "brief", "matrix", or "voice" to regenerate one file]
allowed-tools: Read Grep Glob Write AskUserQuestion
---

# setup

You are setting up the review board for this project. Scope: **$ARGUMENTS**
(empty means all three files).

The gates are only as good as the brief they read. A confident wrong fact
in `board.md` turns every review into expensive confusion, so this skill
asks rather than assumes, and writes short, true files rather than long,
plausible ones.

## Step 1: look before asking

- If `${CLAUDE_PROJECT_DIR}/.claude/review-board/` already exists, read
  what is there and offer to update rather than overwrite. Never overwrite
  a `voice.md` that has a calibration log without asking.
- Read the project's `CLAUDE.md`, README, and any roster or team doc you
  can find. Pull candidate answers from them and present them for
  confirmation instead of asking cold.

## Step 2: the brief (`board.md`)

Template: `${CLAUDE_PLUGIN_ROOT}/templates/board.md`. Fill every section.
Ask, in as few questions as the project docs leave open:

1. The product in one paragraph, including what does NOT exist yet.
2. Who decides, and who owns which kind of call if more than one person.
3. The audiences: primary user, buyer if different, anyone else who sees
   the output. One line each.
4. Facts reviewers must not contradict. Push on this one: user counts,
   revenue, validation claims, locked prices. The gates are told never to
   invent these, so the brief has to say what is true.
5. Standing rules on every surface (em dashes, emojis, claims policy).
6. Process rules the engineering gate enforces, each with the incident
   that produced it when there is one.
7. Where things live: findings ledger, voice profile, matrix.

## Step 3: the sign-off matrix (`signoff-matrix.json`)

Template: `${CLAUDE_PLUGIN_ROOT}/templates/signoff-matrix.json`. Start from
the template's artifact types. Then:

- Add any project-level reviewers (`.claude/agents/*.md`) to the types they
  belong on, by name.
- Remove a type the product plainly does not have (a product with no
  scores or assessments drops `assessment-or-score`), and say so.
- Keep the `recurring_bite_categories`. They are the misses every product
  has.

## Step 4: the voice profile (`voice.md`), optional

Template: `${CLAUDE_PLUGIN_ROOT}/templates/voice.md`. Only worth writing
if the decider will give you real samples of their writing: emails, memos,
reviews they have written, things they have flagged. A voice profile
written from imagination is worse than none, because the `founder-voice`
gate will enforce it with confidence.

If samples exist, read them and draft the profile from them, quoting real
flags they have made. Start the calibration log with the date and the
sample set. If no samples exist, write the file with the defaults section
only and a calibration log entry that says "uncalibrated, defaults only."

## Step 5: seat calibrations, from existing agents

If `${CLAUDE_PROJECT_DIR}/.claude/agents/` already holds review agents
that map onto bench seats (a founder gate, an engineering gate, a
skeptical-user persona, an investor, a flow or completion or measurement
specialist), offer to move each one's body into
`${CLAUDE_PROJECT_DIR}/.claude/review-board/seats/<bench-agent>.md`, in
the shape of `${CLAUDE_PLUGIN_ROOT}/templates/seat.md`. Keep every
incident, quote, boundary, and calibration log entry; drop only the
agent frontmatter and the generic "how to run a review" mechanics the
plugin agent already carries. Never delete the original agent file in
this step; say what the project can do with it (thin shell that points at
the seat file, or removal once the plugin is enabled everywhere the
project runs).

## Step 6: the findings ledger, if missing

If the brief names a ledger path and the file does not exist, create it
from `${CLAUDE_PLUGIN_ROOT}/templates/findings-ledger.md`.

## Step 7: report

One short block: the files written, with paths; the facts you were unsure
about and wrote as questions in the file (search for `TODO`); and the one
sentence on how to run the first review (`/review-board:review <thing>`).

## Hard rules

- Ask before overwriting. Never destroy a calibration log.
- Write what is true, not what sounds complete. A `TODO` beats a guess.
- No em dashes or emojis in the generated files.
