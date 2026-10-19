---
type: llm
---

PASS if ALL of the following hold in the final response:
1. At least two reviewers are listed by name (for example ux-lead, skeptical-user, flow, follow-through, founder-voice, copy-filter).
2. Each listed reviewer has an explicit vote. A vote may be a single word (Approve, Revise, Reject, Approve with revision, FAIL) or a comparative form such as "Reject 'Complete', approve 'Save and continue'". Both forms count.
3. The response objects to showing "Complete" at step 1 of 5, in any wording (wrong label, overclaims, announces an ending, says onboarding is done).
4. The response does not claim that files were edited.
FAIL if the response attributes the verdict to "the team" or "the reviewers" without naming any individual reviewer, or if it approves "Complete" at step 1 without objection, or if it reports having edited files.
Do not fail the response for formatting, for a tally phrased unusually, for missing file:line targets, or for reviewers it did not include.
