---
name: contract
description: Produce a Communication Contract BEFORE any code is written for a new feature, UI change, module, or component. Enumerates every user-facing state, label, visual treatment, interaction state, edge case, accessibility behavior, and responsive behavior in a table the decider approves in plain English, so that no unexplained visual signal, mislabeled button, or undocumented state reaches them. Runs the required named votes before presenting. Mandatory for new surfaces.
argument-hint: [feature name or one-line description]
allowed-tools: Read Grep Glob Agent
---

# contract

You are producing a Communication Contract for: **$ARGUMENTS**

The contract defines every user-facing element before any code is written.
The decider reviews and approves the plain-English contract. Only then
does implementation begin.

## Why this exists

Each of these reached a decider and should not have: a "Complete" button
at 20% progress; a green border on selected cards with no label; a toggle
that toggled nothing visible; an "X" with no aria-label; a panel styled so
subtly nobody noticed it; a gold border with no explanation. Every one
would have been caught by writing this contract first. The contract forces
the communication to be designed before the CSS.

## Before you write

Read `${CLAUDE_PROJECT_DIR}/.claude/review-board/board.md` for the
audiences and standing rules, and the project's platform standards (a
design-system doc, a components README) so section 9 can cite them.

## Mandatory structure

All ten sections, in order. If a section does not apply, write "N/A" with
a one-sentence reason. Never skip one silently.

### 1. Trigger
When does this appear, activate, or become reachable? What action or state
surfaces it?

### 2. User-facing states table

| Element | State | Exact text shown | Visual treatment | Meaning |
|---------|-------|------------------|------------------|---------|

**Rule: every visual distinction has accompanying text.** A row with a
color, border, or icon and an empty text column fails the contract.

### 3. Interaction states
For every interactive element: default, hover, focus (keyboard), active,
disabled (what disables it, what the user sees), loading, error. Exact
text at each state where text changes.

### 4. Edge cases
Empty state. Error state and how the user recovers. Over-limit state.
Never-reached states: say why they cannot happen and what the fallback is
if they do.

### 5. Accessibility
ARIA roles and labels for every interactive element. Keyboard paths (tab
order, Enter and Space, Escape). Focus management when content appears or
disappears. Live-region announcements for dynamic content.

### 6. Responsive behavior
Desktop, tablet, phone. For tables, forms, and multi-column layouts: what
reflows, what stacks, what hides.

### 7. Audience variants
If the surface differs by audience, tier, role, or stage, specify each:
tone, content, default state. If it does not, write "Same for all" and
justify in one sentence.

### 8. Data dependencies
What upstream data this consumes. What it produces for downstream
surfaces. What happens when expected upstream data is missing or null.

### 9. Platform standards applied
Name each project standard this conforms to, by the name the project uses,
and justify any deviation.

### 10. Rules of compliance
- No color, border, or icon without a text label.
- No button label wrong for the user's position in the flow.
- No silent state changes: if something changes, the user sees a label
  explaining it.
- No surface shipped without phone behavior defined.

## Process

1. Draft the contract with real strings. "Label TBD" is not a label.
2. Run the required sign-offs BEFORE the decider sees it. A contract is a
   UX artifact: per the sign-off matrix it needs named votes from
   `review-board:ux-lead` and `review-board:flow` (run them through the
   `review` skill, or dispatch them directly), plus a `copy-filter` pass on
   every string in the states table. Present the contract WITH the votes
   attached, never instead of them.
3. Lead with the contract. Start the response with
   `# Communication Contract: <Feature>` and the ten sections. Process
   notes go after.
4. End with an explicit approval gate. Ask the decider to reply
   **Approve** to proceed, **Revise <section>** to refine, or **Start
   over**.
5. Write no code in the same response as the contract. Do not start
   implementation until the decider approves. If their reply is
   ambiguous, ask.

## Hard rules

- Tables for state enumeration. Not optional.
- Real strings, never placeholders.
- No em dashes in any string or in the contract itself.
