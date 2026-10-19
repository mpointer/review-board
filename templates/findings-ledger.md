# Findings ledger

A finding is something verified in the code or the copy, not a suspicion.
Entries are never deleted. A fixed one stays, with `FIXED` on it, so the
count stays honest and nobody re-finds it.

Each entry: `F-NNN`, a title that names the defect (not the area), the file
and line, what it costs (who hits it, when, what they see), provenance (who
found it, when, verified or suspected), a status and an owner.

Statuses: `OPEN`, `FIXED (#PR)`, `ACCEPTED (reason)`, `SUPERSEDED (by F-NNN)`.

Citing code: an unqualified `file:line` means the default branch. A citation
from an unmerged branch carries a `Verified against:` line naming the
branch, the PR, and the commit SHA, plus what re-verification is owed on
merge.

---

## 2026-01-01, example sweep

### F-001: example entry, replace me

- **Where:** `src/example.ts:42`
- **Cost:** Who hits it, when, and what they see.
- **Provenance:** Found by <name> on <date>. Verified.
- **Status:** OPEN. Owner: <name>.
