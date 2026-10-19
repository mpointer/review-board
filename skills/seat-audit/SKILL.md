---
name: seat-audit
description: Audit the project's review-board configuration for drift. Reads the brief, every seat file, the sign-off matrix, and the voice profile, and reports contradictions a reviewer would otherwise inherit: a seat rule that disagrees with the brief's process rules, a status claim the brief says reviewers do not know, a route to a reviewer that does not exist, an output contract missing the board-wide steps, a matrix reviewer with no cloud fallback, and a plugin source with no pinned version. Run after setup, after moving agents into seat files, and whenever CLAUDE.md or the process changes.
when_to_use: "'audit the review board', 'check the seat files', 'is the brief still true', 'did the gates drift', after a migration of agents into seats, after a process or policy change in CLAUDE.md."
argument-hint: [optional: a seat name to audit alone]
allowed-tools: Read Grep Glob
---

# seat-audit

You are auditing the review-board configuration under
`${CLAUDE_PROJECT_DIR}/.claude/review-board/` for: **$ARGUMENTS** (empty
means everything).

Calibration drifts. A seat file is written once from real reviews, the
process changes, and the seat keeps enforcing the old rule with full
confidence. The first project migrated onto this plugin shipped a seat
that told its engineer to run a command the project's own CLAUDE.md had
forbidden for three months. Nine such findings came from one outside
review. This skill is that review, run on demand, before a reviewer
inherits the drift.

## What to read

1. `board.md`, the brief. It is the reference for every check below.
2. Every `seats/*.md`.
3. `signoff-matrix.json`.
4. `voice.md` and the profile it points at, if any.
5. `${CLAUDE_PROJECT_DIR}/CLAUDE.md` and any process doc the brief names.
   The brief can itself be stale; where CLAUDE.md and the brief disagree,
   that is a finding against the brief.
6. `${CLAUDE_PROJECT_DIR}/.claude/agents/*.md`, for the set of reviewers
   that actually exist.
7. `${CLAUDE_PROJECT_DIR}/.claude/settings.json`, for how the plugin is
   sourced.

## The checks

Run each one against every seat. Quote the offending line with its file
and line number. Label each finding **evidence-backed** (two lines that
contradict each other, both quoted) or **judgment** (a line that looks
stale but has no contradicting source you can quote).

1. **Process rules that disagree.** Every imperative in a seat file about
   branches, migrations, secrets, deploys, approvals, or tooling is
   checked against the brief's "Process rules" section and against
   CLAUDE.md. A seat that says "run X" where the brief says "never run X"
   is the most damaging drift there is, because the seat wins where they
   overlap. Also flag a rule stated in CLAUDE.md that neither the brief
   nor the relevant seat carries.
2. **Status claims.** Any assertion about users, revenue, validation,
   cohorts, launch state, or a feature's existence. The brief's "Facts
   reviewers must not contradict" section owns these. A seat may say
   "defer to the brief" or "nothing was known at calibration"; it may not
   assert a current state. Check the brief's own claims against the code
   where you can (a package that is or is not in `package.json`, a route
   that does or does not exist).
3. **Routes to nowhere.** Every reviewer, seat, person, or file a seat
   routes work to. A plugin seat must exist in the bench; a project
   reviewer must exist under `.claude/agents/`; a roster person must be
   named in the brief or the roster; a file path must exist. "Seat X has
   no agent file" is a finding when the file exists.
4. **Output contracts.** Every seat's output section carries the
   board-wide requirements the brief states, in the order the brief
   states them: evidence or judgment labels on findings, the strongest
   objection, the seat's own verdict words. A seat missing one, or a brief
   whose wording contradicts the seats' ordering, is a finding.
5. **Boundaries.** Each seat's "what you do NOT own" names seats that
   exist, and no two seats both claim to own the same thing without
   saying they are adversarial by design.
6. **Matrix.** Every reviewer named in `signoff-matrix.json` resolves to a
   plugin seat, a project agent, or a plugin skill, and every plugin-only
   name has an alias for environments where the plugin does not load.
   Every artifact type the brief's audiences imply has a row.
7. **Source pinning.** If `.claude/settings.json` sources the plugin from
   a git marketplace with no `#ref`, say so: a push to that repository
   changes every gate with no reviewable diff in this project. Recommend
   pinning to a tag.
8. **Calibration logs.** A seat with no calibration log, or a log whose
   last entry predates a process rule the seat restates, is a draft and
   should say so.
9. **Standing rules.** Em dashes, emojis, and anything else the brief's
   standing rules forbid, inside the configuration files themselves.

## What you return

1. **One line**: the count of findings by severity, and whether any seat
   would currently enforce a rule the project has reversed.
2. **Findings**, most damaging first. For each: file and line, the quoted
   text, the quoted source it contradicts (or "no contradicting source;
   judgment"), and the one-sentence fix.
3. **What is fine**, briefly: the checks that passed, so the reader knows
   they ran.
4. **The strongest objection to this audit**: usually that the seat text
   is the calibrated voice of a real person and the fix should preserve
   the voice while correcting the rule. Say how.

Do not edit anything. The findings go to the decider, who fixes the seat
files or asks you to. Never log a finding you did not read in a file.
