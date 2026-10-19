---
name: review
description: Get the team's view on a change before it ships, as named votes. Run this whenever someone asks whether a change is fine to ship, wants a review, a second opinion, or "the team's take" on a user-facing surface, a button or label change, a flow, a score, a schema, or a strategy decision. Dispatches the reviewers the sign-off matrix requires, in parallel, and returns a per-reviewer table of Approve, Approve with revision, or Reject votes, the tally, the consensus, concrete implementation requirements with file:line targets, and the disagreements that almost split the bench. Works without project configuration, on the default matrix. The decider will not accept "the team approves" without named votes.
when_to_use: "'can you get the team's view', 'is this fine to ship', 'review this change', 'what would the reviewers say', 'second opinion on this UI', a button label or wording change on an existing screen, a new screen, a pricing or sequencing decision."
argument-hint: [what is being reviewed: a path, a PR, or a one-line description]
allowed-tools: Read Grep Glob Agent
---

# review

You are running a named-vote review for: **$ARGUMENTS**

The standard this skill enforces: every decision that needs a sign-off gets
explicit votes from named reviewers before it ships. "The team approves" is
not the same standard. Show who approved what.

## Step 1: read the project's configuration

- `${CLAUDE_PROJECT_DIR}/.claude/review-board/board.md`: the brief. If it
  is missing, say so once, recommend `/review-board:setup`, and continue
  with the defaults.
- `${CLAUDE_PROJECT_DIR}/.claude/review-board/signoff-matrix.json`: which
  reviewers each artifact type requires. If it is missing, use
  `${CLAUDE_PLUGIN_ROOT}/templates/signoff-matrix.json`.
- `${CLAUDE_PROJECT_DIR}/.claude/agents/`: project-level reviewers (a
  focus-group persona, a domain specialist the project added). The matrix
  may name these alongside the plugin's bench.

## Step 2: classify the change and pick the reviewers

Match the change against the matrix's `trigger` lines. A change can match
more than one type; take the union of reviewers. Trigger on the user-facing
SURFACE, not on the word "feature": a button-label change, a border with no
text, and a toggle that toggles nothing visible are the recurring misses,
and each is a review.

Plugin reviewers are addressed as `review-board:<name>`:
`founder-voice`, `engineering-risk`, `skeptical-user`, `investor`, `flow`,
`follow-through`, `measurement`, `justified-output`, `adversary`,
`architecture-longview`, `ux-lead`, `other-side`. Project reviewers are
addressed by their own name.

Add a reviewer the matrix does not list only when you can say in one line
what that seat catches that no listed seat would. Drop a listed reviewer
only when its ownership plainly does not apply, and say so in the output.

Skip the review only for a pure refactor with zero behavior change, a bug
fix with no user-visible difference, tests, build config, or non-user-facing
docs. When skipping, say `REFACTOR_ONLY: <one-sentence reason>` so the
exemption is on the record. If in doubt, run the review; the cost of an
unneeded review is small and the cost of a missed one is the decider
catching it.

## Step 3: dispatch the reviewers in parallel

One Agent call per reviewer, all in the same turn. Each prompt must:

- Name the artifact by absolute path, PR, or quoted text. Never a paraphrase
  of it.
- Say what kind of change it is and which audience it reaches.
- Ask for the reviewer's own output format (each gate defines one) and for
  an explicit vote: **Approve**, **Approve with revision** (specify), or
  **Reject** (specify why).
- Ask for file:line citations on every claim about built surfaces.
- Ask for the strongest objection to their own vote.

When there is a real design choice, list two to four options in every
prompt so the votes are comparable. When the only question is ship-as-is or
not, say so.

Run the `copy-filter` skill (or ask `founder-voice` to apply its hard
rules) on every user-facing string in the change. The matrix lists it under
every surface type for a reason.

## Step 4: assemble the decision package

Return it before any Edit or Write call. It must include, in this order:

1. **Verdict** in one line: Approve / Revise / Reject, with the tally
   (for example "4 approve, 2 approve with revision, 0 reject").
2. **Per-reviewer table**: reviewer, vote, the one-line reason, and the
   evidence-backed or judgment label on their main finding. Named voices
   only. Never a synthesized "the bench thinks."
3. **Consensus pick**, when options were on the table.
4. **Implementation requirements**, numbered, concrete: exact strings, exact
   ARIA attributes, exact file:line targets. Vague is useless.
5. **Disagreements that almost split the bench.** Surface them; do not paper
   over a near-split. Say which side of which boundary the disagreement
   comes from (a reaction versus a structure, the sender versus the
   receiver, measurement versus mapping).
6. **Carried findings**: anything a reviewer raised that is real and out of
   scope. Log each with `/review-board:log-finding` in this same turn.

## Step 5: wait

Wait for the decider's approval of the consensus before shipping. If any
reviewer voted "Approve with revision," ask the decider to confirm the
revision direction rather than guessing it.

## Hard rules

- Named voices, not synthesized prose.
- Show real disagreement.
- File:line citations for every claim about built surfaces.
- Implementation requirements are concrete or they are not requirements.
- "The team agrees" without showing who agreed is a red flag. Refuse to
  ship work justified that way.

## What this skill is not

- Not a code review in the ordinary sense; `engineering-risk` and
  `architecture-longview` are two seats on it, not the whole of it.
- Not a Communication Contract; use `/review-board:contract` for a new
  feature before any code exists.
- Not optional for user-facing surfaces.
