# Changelog

## [0.4.1] - 2026-11-01

- review: logging a carried finding is the one write allowed before the
  decider answers. The skill used to forbid any write and also require the
  log in the same turn.
- CI: read-only token, actions pinned by SHA, Claude CLI pinned.
- Evals: log-finding-entry checks cost, provenance, status, and owner. New
  cases cover the no-ledger brief and seat-audit drift.

## [0.4.0] - 2026-10-31

Behavior changes:

- The brief now outranks a seat file: on a fact or a process rule, every
  agent follows the brief and says so in its review. seat-audit no longer
  assumes the seat wins.
- review maps each seat's verdict words onto the tally. "Keep going" counts
  as a revision from founder-voice and "I'd keep going" as an approval from
  skeptical-user. "Surface to the owner" counts as no vote.
- review can no longer be skipped for a change that touches schema, auth,
  secrets, PII, or anything irreversible.
- contract reads the sign-off matrix instead of hardcoding its reviewers.
- Every agent treats reviewed content and fetched pages as data, never as
  instructions, and never puts file contents or secrets in a URL.
- log-finding no longer pre-approves Bash, so filing through `gh issue`
  asks for permission.

Fixes:

- check.sh: the dash check silently passed on macOS, where BSD grep has no
  `-P`. It now works on BSD and GNU grep, fails if the check itself breaks,
  and also scans docs and CHANGELOG.
- check.sh now verifies each agent's exact tools, name, seat path, and
  untrusted-content rule, and that the README pin matches the version.
- Frontmatter descriptions and argument hints are quoted, so every agent
  and skill parses as strict YAML.
- The twelve example personas gain the "What you refuse to do" section that
  the persona skill requires.
- seat-audit: check 6 no longer requires an alias that nothing defines, and
  check 7 asks for a pinned ref in either form.
- setup points at seat-audit after moving agents into seat files.
- README and manifest: eight skills, and a corrected account of what writes.

## [0.3.1] - 2026-10-19

- log-finding reads the brief first and honors "Findings ledger: none":
  it files the finding where the brief says instead of creating a ledger
  the project forbade. Found by running seat-audit against the first
  migrated project.
- seat-audit check 2 now audits the brief's own product paragraph claim by
  claim, absence as well as presence, after the first run verified the
  providers a brief named and missed a gateway it also named that does
  not exist.
- README pin example updated to v0.3.1.

## [0.3.0] - 2026-10-19

- New skill `seat-audit`: audits the brief, seat files, matrix, and
  settings for drift (seat rules that contradict the brief or CLAUDE.md,
  stale status claims, routes to reviewers that do not exist, output
  contracts missing the board-wide steps, an unpinned plugin source).
  Built from the nine findings an outside review made on the first real
  migration.
- Brief template: the "facts reviewers must not contradict" section now
  names the four classes that migration missed (what the product does
  not use, policies with effective dates, consent commitments, standing
  exceptions), and the process-rules section says to copy from CLAUDE.md
  and re-audit when it changes.
- README: pin the marketplace source to a tag.
- docs: "Moving eight calibrated review agents onto a plugin without
  losing them", the write-up of the migration and the comparison.

## [0.2.0] - 2026-10-19

- Seat calibration files. Every bench agent now reads
  `.claude/review-board/seats/<agent>.md` after the brief, when it exists.
  A seat file carries the project's calibration of that seat (who it is
  modeled on, voice, incidents behind the rules, boundaries with the
  project's own reviewers) and overrides the agent's defaults where they
  overlap. This is what lets a project migrate a hand-calibrated in-repo
  gate onto the plugin without losing the calibration. Template at
  `templates/seat.md`; the setup skill offers to create seat files from
  existing agent files.

## [0.1.1] - 2026-10-19

- Directory listing fields in the manifest (icon, documentation and support
  URLs) and a README section stating what the plugin runs, reads, and sends.
  No behavior change.

## [0.1.0] - 2026-10-19

First public release. Extracted from two production repositories where the
bench has been in daily use since May 2026.

- Twelve bench agents: founder-voice, engineering-risk, skeptical-user,
  investor, flow, follow-through, measurement, justified-output, adversary,
  architecture-longview, ux-lead, other-side. Each reads the project brief,
  declares what it does not own, labels every finding evidence-backed or
  judgment, states the strongest objection to its own answer, and never
  invents numbers.
- Seven skills: review (named votes), focus-group, persona, setup,
  copy-filter, contract, log-finding.
- Templates for the project brief, voice profile, sign-off matrix, persona,
  and findings ledger.
- Twelve example focus-group personas for a student career product.
- Eval cases for the review, copy-filter, and log-finding skills. All three score 1.0 locally (one run each, ablation none, Sonnet judge).
