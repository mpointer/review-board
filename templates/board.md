# Review board brief

Every reviewer on the bench reads this file before reviewing anything. Keep
it short and keep it true. A confident wrong fact here turns every gate into
expensive confusion.

## The product

One paragraph. What it is, who it is for, what stage it is at. Say what does
NOT exist yet as plainly as what does.

## Who decides

The person or people whose call it is. Reviewers are advisory; they flag and
recommend, and the names here decide. If there is more than one decider, say
who owns which kind of call (voice, engineering, money).

## The audiences

The people who will actually encounter the work, one line each. The
`skeptical-user` gate reads the hardest one to win over as its persona
unless a focus-group persona is named instead.

- Primary user:
- Buyer, if different from the user:
- Anyone else who sees the output (a counselor, a recruiter, a regulator):

## Facts reviewers must not contradict

Things a reviewer could plausibly get wrong and must not. Four classes,
each with an example; the first migration onto this plugin missed one of
each class and an outside review caught them.

- **What exists and what does not.** "There are no paying users yet.
  Never state or estimate a count." "No instrument has been validated on
  a real cohort." Also what the product does NOT use: a reviewer who
  assumes a gateway, a vendor, or a data source that is not there reasons
  about data flow from a fiction. Check `package.json` before writing
  this section.
- **Policies with effective dates.** "A 30-day refund for unused paid
  stages took effect 2026-10-19; there is no money-back guarantee." A
  reviewer that proposes copy contradicting the Terms is worse than one
  that says nothing.
- **Consent and privacy commitments.** "The advisory panel's members are
  minors: no names in any artifact." "A teenager approves before a parent
  sees their work." These bind every seat, not only the privacy one.
- **Standing exceptions.** "Super admins can do everything." A seat that
  flags an intended bypass as a defect wastes the decider's time and its
  own credibility.

## Standing rules

Rules that apply to every surface, every time. Examples:

- No em dashes or en dashes in prose. No emojis in product or partner copy.
- Every public claim traces to a named person with consent on file, a shipped
  feature, or a cited measurement. No fourth category.
- Second person, present tense, active voice for direct address.

## Process rules the engineering gate enforces

Branch, schema, secrets, and deploy rules, each tied to the incident that
produced it when there is one. Examples:

- Branch from `staging`, never `main`.
- A schema change ships with its migration in the same PR.
- Never run `vercel env pull` directly; use the wrapper.

## Where things live

Paths the gates will need: the findings ledger, the voice profile, the
sign-off matrix, the pricing source of truth, the copy that is already locked.

- Findings ledger: `docs/findings-ledger.md`
- Voice profile: `.claude/review-board/voice.md`
- Sign-off matrix: `.claude/review-board/signoff-matrix.json`
