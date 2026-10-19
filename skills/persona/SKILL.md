---
name: persona
description: Create a focus-group persona as a project-level subagent file at .claude/agents/fg-<name>.md, in the standard structure the focus-group skill expects. Use when the project needs a new voice in its focus group: a specific user, buyer, or bystander whose reaction the team cannot otherwise get. Asks for the gap this person catches that no existing persona does, then writes one real person, not a demographic.
argument-hint: [who this person is, in a sentence, and the gap they catch]
allowed-tools: Read Grep Glob Write
---

# persona

You are creating a focus-group persona for: **$ARGUMENTS**

## What a persona is

One specific person, written so that a model can read a surface as them and
report where they lean in and where they check out. A persona is not a
demographic segment, not a user story, and not a stereotype. The test of a
good one is that they catch a gap no other persona on the roster catches,
and that they have at least one trait that cuts against the obvious read
of them.

Read `${CLAUDE_PLUGIN_ROOT}/templates/persona.md` for the structure, and
`${CLAUDE_PLUGIN_ROOT}/examples/focus-group-student-career/fg-greg.md` for
a finished example.

## Step 1: check the roster

List `${CLAUDE_PROJECT_DIR}/.claude/agents/fg-*.md` and read each
description. If the person being asked for overlaps an existing persona,
say so and ask whether to sharpen that one instead. Two personas who catch
the same gap halve the value of both.

## Step 2: get what you need

From `${CLAUDE_PROJECT_DIR}/.claude/review-board/board.md` if it exists,
and from the request. You need:

- **The gap.** In one sentence: what this person catches that nobody on the
  roster does. If the request did not say, ask; do not guess.
- **Who they are.** Age or career stage, situation, what they want from the
  product, what they have already tried in this category and what it did
  to them. Specific place, specific circumstance.
- **The contradiction.** The trait that cuts against the stereotype. The
  skeptical dad who is not anti-education; the high achiever who is
  quietly furious; the counselor who loves the kids and is done with
  pilots.
- **Lean-in and check-out.** Three or four each, concrete, tied to this
  person's situation rather than generic UX complaints.
- **Voice.** Register, sentence length, what they would never say. The
  review must sound like them, not like an adult's idea of them and not
  like a brand.

## Step 3: write the file

Write `${CLAUDE_PROJECT_DIR}/.claude/agents/fg-<short-name>.md` following
the template exactly. Frontmatter:

```yaml
---
name: fg-<short-name>
description: Focus-group participant. Pressure-test <which surfaces> against <Name>, <one-line who>. Use to catch <the gap>. Read-only, never edits files.
tools: Read, Grep, Glob
model: inherit
---
```

The body keeps the template's sections in order: who they are, what they
bring to the focus group, what makes them lean in, what makes them check
out, their voice, how to run the review, their output. The output section
must end with a two-way verdict line in their own words (for example "I'd
keep going" or "I'd close it").

## Hard rules

- One person, not a segment. If the draft could describe a thousand
  people, it is not done.
- The gap is stated in the description, so the focus-group skill can route
  on it.
- No fabricated statistics about the persona's group. A persona has a
  life, not a citation.
- The persona reacts and reports. They never edit files and never
  redesign; the template's "What you refuse to do" stays in.
- No em dashes anywhere in the file. No emojis.
- Say one line to the decider when the file is written, with the path, and
  offer to run `/review-board:focus-group` on something.
