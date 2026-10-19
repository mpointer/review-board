---
name: focus-group
description: Run a focus group. Sends a surface (a page, a flow, a piece of copy, a pricing screen) to every focus-group persona the project has defined under .claude/agents/fg-*.md, or a named subset, in parallel, and returns each persona's reaction in their own voice, the bail points that recur across personas, the places where personas disagree, and the verdict split. Use when the question is "how do the real people we built this for react," as distinct from an expert gate's verdict.
argument-hint: [surface to test, then optionally "with <persona>, <persona>"]
allowed-tools: Read Grep Glob Agent
---

# focus-group

You are running a focus group on: **$ARGUMENTS**

A focus group is not a review board. A gate returns an expert verdict with
a declared boundary. A persona returns one person's reaction. Both are
useful, and they are not interchangeable: a surface can pass every gate and
still lose the person it was built for.

## Step 1: find the roster

Personas live in `${CLAUDE_PROJECT_DIR}/.claude/agents/fg-*.md`. List them.
Read each one's frontmatter description so you know who they are and what
gap they catch.

If the request names personas ("with Greg and Rosa"), use those. Otherwise
use every persona whose description says they encounter this kind of
surface (a student-facing screen goes to the student personas, a pricing
page goes to the buyer personas, a counselor dashboard goes to the
counselor personas). Say who you included and who you left out, and why.

If there are no personas, stop and say so. Offer
`/review-board:persona` to create them, and if the project is a student
career product, point at `${CLAUDE_PLUGIN_ROOT}/examples/focus-group-student-career/`
as a starting roster. Do not improvise personas inline; a persona that
exists only in one prompt cannot be re-run, compared, or calibrated.

## Step 2: dispatch every persona in parallel

One Agent call per persona, all in the same turn, using the persona's
agent name. Each prompt:

- Names the surface by absolute path or quotes it in full.
- Asks the persona to read it as themselves, fast, the way they actually
  would, and to use their own output format (every persona file defines
  one: what worked, where I got lost or left, the verdict line).
- Asks for the exact screen, line, or word at each bail point, quoted.
- Does not tell the persona what the team hopes to hear.

## Step 3: assemble the report

1. **The split**, in one line: how many would keep going, how many would
   close it, by name.
2. **Per-persona reactions**, each in that persona's voice, kept short:
   their one or two lines of credit, their numbered bail points with the
   quoted line, their verdict.
3. **Recurring bail points**: any screen, line, or assumption that two or
   more personas hit independently. These are the findings that matter
   most, because they are not one person's taste.
4. **Where personas disagree**: a line that worked for one and lost
   another. Say what that tells you about the audience, not which persona
   is right.
5. **Who this is for**: the honest answer to "is this surface built for the
   user or for whoever bought it," drawn from the personas who said so.
6. **What to change first**: two or three things, each tied to the personas
   it would keep.

## Hard rules

- Personas react; they do not design. If a persona's file strays into
  redesign, report the reaction and leave the redesign to the gates.
- Quote the line. A bail point with no quoted text is an impression.
- No invented personas, no invented numbers. The report counts personas,
  never users.
- No em dashes in the report.
