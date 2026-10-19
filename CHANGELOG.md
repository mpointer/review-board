# Changelog

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
