# Moving eight calibrated review agents onto a plugin without losing them

Date: 2026-10-19. The plugin is
[review-board](https://github.com/mpointer/review-board). The project is a
student career-discovery product with eight review agents in its
`.claude/agents/` directory, built up over five months from real reviews
by its two founders: a founder-voice gate, an engineering gate, a
skeptical-teenager persona, an investor, and four specialists (flow,
completion, psychometrics, recommendation validity). The engineering gate
alone is 400 lines of one person's register, incident history, and
non-negotiable rules.

This is the record of moving those eight onto the generic plugin bench,
what it took to do that without losing the calibration, how the result
compared to the originals on the same work, and what two outside reviews
found afterwards.

## Why move them at all

Two reasons, and the second one turned out to matter more.

First, the eight files contained the same mechanics eight times: read the
artifact, run the checklist, find two or three things that matter, give a
verdict. The plugin carries that once. What is specific to the project is
the calibration: who the reviewer is modeled on, what they catch, which
rules they will not negotiate, how they write.

Second, a calibrated agent file is a closed world. Nothing checks it
against the project's current process. The migration forced the
project's facts into one place, a brief every seat reads first, and put
the calibration beside it where the two can be compared. That comparison
is where the real findings came from.

## The design: brief plus seats

The plugin's agents read two project files before they review anything.

`board.md` is the brief: the product, who decides, the audiences, the
facts no reviewer may contradict (no validated instrument, no usage
figures, a public-claims policy, live pricing), standing rules, and the
process rules the engineering gate enforces, each tied to the incident
that produced it.

`seats/<agent>.md` is the per-seat calibration. It carries the old agent
file's body verbatim and overrides the plugin agent's defaults wherever
they overlap. This is what made the migration lossless: the engineering
gate's 400 lines moved into `seats/engineering-risk.md` unchanged, and
the plugin's `engineering-risk` agent, reading them, behaves as that
engineer.

The old agent files became 25-line shells that read the brief and the
seat file. They stayed because cloud sessions do not load
project-enabled plugins yet, so the project needed the gates to work by
their old names there. One file defines each seat in both places.

## The comparison

Before merging, I ran the pre-migration agents (still loaded in the
session) and the plugin seats with the moved calibration on the same
surface and the same commit, one run each.

**The parent-facing marketing page.** Both reviewers said "Keep going."
Both found five things. They overlapped on one (dark-mode breakage on
inline-styled elements) and were otherwise disjoint. The original caught
a video label that said 1:37 for a 116-second asset, the single most
founder-like catch on the page. The plugin seat caught an en dash and a
paired-opposite reveal, because the brief loads those as rules rather
than taste, and a copy contradiction the original walked past. I
verified both lines. Neither review was a superset of the other.

**A commit that records when a stored salary figure is a mean.** Both
said "Ship after fixes" with the same two blockers: a backfill that only
flags one sentinel value, and read sites that still select the raw
column without the flag. They enumerated different sets of uncovered
sites, five distinct ones between them. One real divergence: the original
called the public-claims exposure risk-elevated and the plugin seat said
none, with identical seat content. That is run-to-run variance on one
judgment call, and it is the kind of split a named-vote review should
surface rather than average away.

The plugin seats added three things the originals never did, unprompted:
an evidence-backed or judgment label on every finding, a strongest
objection to their own verdict, and a declared ownership boundary that
routed the signup-structure question to the flow seat. Cost was fifteen
to thirty percent more tokens per review for reading the brief and the
seat.

## What the outside reviews found

The project runs an AI code reviewer on every PR. On the migration PR it
posted nine findings. All nine were real. In order of damage:

1. The engineering seat told its engineer to pair every schema change
   with `drizzle-kit push`, in five places. The project's own CLAUDE.md
   had forbidden that for three months in favor of a generated migration
   applied on deploy, because a manual push leaves every later deploy
   red. The old agent file had been stale since July. Nobody had noticed,
   because nothing had ever placed the seat's rule next to the current
   one. The brief did, and the reviewer caught the contradiction.
2. Four seats asserted the product had no paid users or revenue, a
   status claim frozen at the date the seats were written. The brief
   says reviewers do not know that; the seats now defer to it.
3. The flow seat said the completion specialist "has no agent file." He
   had had one for three weeks.
4. One seat routed a class of concern to a roster position that was
   never filled.
5. Three seat output contracts lacked the board-wide labels and the
   strongest-objection step, and the brief's wording ("ends with")
   contradicted the seats' verdict-word endings. Both fixed.
6. The brief overstated admin audit coverage on a ratchet that still
   carries 28 known-unaudited handlers.
7. The sign-off matrix routed user copy to a plugin skill with no
   fallback in sessions where the plugin does not load.

A second review, by the project's own operating agent, found one
outright error in the brief I wrote (I had assumed a model gateway the
project does not use), five facts the gates would otherwise get wrong
(a refund policy with an effective date, a consent model, that an
advisory panel's members are minors, a standing super-admin exception,
three process rules I had left out), and one structural point: the
plugin was sourced from a repository with no pinned ref, so a push there
could change every gate with no reviewable diff in the project.

## What changed in the plugin because of this

Version 0.3.0 adds a `seat-audit` skill that runs those checks on
demand: seat rules against the brief and CLAUDE.md, status claims,
routes to reviewers that do not exist, output contracts, matrix
fallbacks, source pinning. The brief template now names the four classes
of fact the first migration missed: what the product does not use,
policies with effective dates, consent commitments, and standing
exceptions. The README says to pin the marketplace to a tag.

## Running the audit on the thing it came from

Before releasing the skill I ran its instructions against the same
project's configuration, with the second review's items still unfixed.
It returned thirteen findings. It caught residue my own fix of the first
review had missed: the engineering seat still said schema changes "pair
with a `drizzle-kit push`" in the paragraph describing how its engineer
thinks, an admin-merge rule the project reversed in July, three roster
people who do not exist, and a "pre-launch" claim about a product with
live pricing. It also found a defect in the plugin itself: the brief
said the project has no findings ledger, and the plugin's log-finding
skill would have created one anyway. That is fixed in 0.3.1.

It missed the one outright error the project's own agent had found, the
gateway that does not exist. It verified that the providers the brief
named were installed and never checked that the gateway it also named
was absent. Check 2 now says to audit the product paragraph claim by
claim, absence as carefully as presence. One run, one miss, one fix; the
skill is a reviewer, and the rule about reviewers applies to it.

## What I would not claim

The comparison is one run per pair on two artifacts. It shows the seats
carry the calibration and that the plugin's mechanics add structure; it
does not show the plugin reviews better. The disjoint findings argue for
two passes on a trust surface, not for either reviewer alone.

The audit skill is a reviewer reading files for contradictions. It will
find the class of drift above. It will not find a rule that is wrong in
both the seat and the brief, which is what happens when CLAUDE.md itself
is stale.

And the shells are a workaround for a platform gap. When cloud sessions
load project-enabled plugins, they go.
