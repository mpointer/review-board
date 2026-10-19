---
type: llm
---

PASS if the final response lists at least two reviewers by name (for example ux-lead, skeptical-user, flow, founder-voice) and gives each an explicit vote (Approve, Approve with revision, or Reject) with a one-line reason, AND it flags that "Complete" is the wrong label at step 1 of 5.
FAIL if the response says the team approves or rejects without naming who voted, or if it approves "Complete" at 20% progress without objection, or if it edits files before presenting the votes.
