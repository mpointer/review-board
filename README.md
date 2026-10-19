# Review Board

A Claude Code plugin: a bench of named reviewers that return named votes,
declare what they do not own, label every finding evidence-backed or
judgment, state the strongest objection to their own answer, and never
invent a number.

Extracted from two production repositories where it has been the quality
gate on every user-facing, engineering, and strategy change since May 2026.
The product-specific parts were removed; the discipline is what ships.

## Why

"The team approves" is not a review. A review is a named person saying
Approve, Revise, or Reject, with a reason, a file and line, and the
strongest case against their own vote. Generic review agents produce
twenty nits and no verdict. These produce two or three findings that
matter, in order, and a verdict word.

Five rules every reviewer on the bench follows:

1. **Named votes.** Every verdict carries a name. No synthesized consensus.
2. **Declared ownership.** Each seat says what it owns and what it does
   NOT own, and routes the rest to the seat that does. The measurement
   gate and the justified-output gate are adversarial by design and argue
   in the open.
3. **Evidence or judgment.** Every finding is labeled **evidence-backed**
   (read in the code or copy) or **judgment** (pattern experience). The
   decider is entitled to know which they are getting.
4. **The strongest objection.** Every review ends with the best argument
   against its own verdict, stated as well as the other side would state
   it.
5. **No invented numbers.** No fabricated benchmarks, user counts,
   completion rates, reliability coefficients, or "studies show." The
   project brief says what is measured; if nothing is, the reviewer says
   nothing.

## Install

From a Claude Code session:

```
/plugin marketplace add mpointer/review-board
/plugin install review-board@review-board
```

Or from the shell: `claude plugin marketplace add mpointer/review-board`
then `claude plugin install review-board@review-board`. To try it without
installing, clone the repo and start Claude Code with
`--plugin-dir ./review-board`.

Then, once per project:

```
/review-board:setup
```

That writes `.claude/review-board/board.md` (the brief every gate reads),
`signoff-matrix.json` (which seats sign off on which kind of change), and
optionally `voice.md` (the founder's voice profile). The gates work
without them, on general standards, but they are much better with them.

## The bench

| Agent | Owns | Verdict words |
|-------|------|---------------|
| `founder-voice` | Would the person whose name is on this say it. Copy, UI, emails, decision write-ups. Reads `voice.md`. | Ship it / Keep going |
| `engineering-risk` | Production failure mode, process rules, rollback, irreversibility. | Ship it / Ship after fixes / Hold / Surface to the owner |
| `skeptical-user` | Where the hardest user to win bails. One person's reaction, in their voice. | I'd keep going / I'd bail |
| `investor` | Who pays, unit economics, distribution, moat, default-alive. | Fund it / Fund after fixes / Pass / Come back with data |
| `flow` | Multi-screen sequences, two-actor activation, the seam, empty states that wait on someone else. | Position in one line |
| `follow-through` | Completion, first-session payoff, micro-commitments, honest versus exploitative mechanics. | Position in one line |
| `measurement` | Whether a question, rubric, scale, or classifier label measures what it claims. The input side. | Position in one line |
| `justified-output` | Whether a recommendation, ranking, or score is justified by what was measured. The output side. | Defensible as built, or not |
| `adversary` | The strongest case against, competitor by name, quoting the actual copy. | Approve / Revise / Reject |
| `architecture-longview` | Will today's data model survive the next three phases. | Approve / Revise / Reject |
| `ux-lead` | Every visual element earns its place; the label comes before the CSS; mobile parity. | Approve / Revise / Reject |
| `other-side` | What happens when the artifact lands on the person receiving it. Speaks for the recipient, not the sender. | Approve / Revise / Reject, conditions BLOCKING or NON-BLOCKING |

Invoke one directly with `@agent-review-board:<name>`, or let the `review`
skill pick the seats from the sign-off matrix.

## The skills

| Skill | What it does |
|-------|--------------|
| `/review-board:review <thing>` | Picks the reviewers the matrix requires, runs them in parallel, returns the per-reviewer vote table, tally, consensus, concrete implementation requirements with file:line, and the near-splits. Waits for the decider before any edit. |
| `/review-board:focus-group <surface>` | Sends a surface to every focus-group persona in `.claude/agents/fg-*.md` and reports each reaction in their voice, the bail points that recur, and the verdict split. |
| `/review-board:persona <who, and the gap>` | Writes a new focus-group persona file in the standard structure: one person, with a contradiction, who catches a gap no other persona does. |
| `/review-board:setup` | Bootstraps `.claude/review-board/` from the templates by asking, not assuming. |
| `/review-board:copy-filter <strings>` | PASS or FAIL per user-facing string against the nine-point filter and the hard rules (no em dashes, no consultant register, reader-first, never sound like an AI), with rewrites. |
| `/review-board:contract <feature>` | A Communication Contract before any code: every state, label, visual treatment, interaction state, edge case, accessibility and responsive behavior, in tables, with named votes attached. |
| `/review-board:log-finding <sentence>` | Appends a finding to the ledger in the turn you noticed it: defect-named title, file and line, cost, provenance, status, owner. |

## Focus groups

Gates return expert verdicts. Personas return one person's reaction. A
surface can pass every gate and still lose the person it was built for, so
the plugin keeps both and never confuses them.

Personas are project-level agents (`.claude/agents/fg-<name>.md`), because
they are specific to your audience. `examples/focus-group-student-career/`
ships twelve finished ones for a student career-discovery product (a
first-generation bilingual student, a skeptical working-class father, a
counselor with a 400-student caseload, a 13-year-old at the age floor, and
so on) as a worked example of what a good roster looks like: each catches a
gap the others do not, and each has a trait that cuts against the
stereotype. Copy any into `.claude/agents/` to use them, or run
`/review-board:persona` to write your own.

## Project configuration

```
.claude/review-board/
  board.md             the brief: product, decider, audiences, facts not to
                       contradict, standing rules, process rules
  signoff-matrix.json  which seats sign off on which artifact type
  voice.md             optional: the founder's voice, from real samples
.claude/agents/
  fg-*.md              focus-group personas
docs/findings-ledger.md
```

Templates for all of these are in `templates/`. The brief matters more
than it looks: a gate told the truth about what exists and what does not
("no paying users yet," "no instrument validated on a cohort") stops
inventing. A confident wrong fact in the brief turns every gate into
expensive confusion.

## Evals and checks

`scripts/check.sh` runs the structural checks (frontmatter, declared
boundaries, evidence labels, strongest-objection step, no em dashes,
manifest and marketplace agree) and `claude plugin validate --strict`. CI
runs it on every push.

`evals/` holds three cases for `claude plugin eval .`: the review skill
must return named votes and catch a "Complete" button at step 1 of 5; the
copy filter must fail an em dash and consultant register and rewrite; the
finding logger must write a well-formed ledger entry. Evals call a model
and cost money, so they are run by hand, not in CI.

## Companion projects

The same discipline, applied to machine determinations rather than human
reviews, lives in three sibling packages: `typesafe-gates` (declared
fail-open or fail-closed policy on probabilistic gates), `ledgerchain`
(an append-only ledger for decisions), and `llm-governance-gateway`
(guardrail hooks around structured generation). Review Board is the
human-in-the-loop end of that stack.

## License

MIT.
