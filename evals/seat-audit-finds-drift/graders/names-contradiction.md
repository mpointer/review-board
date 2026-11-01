---
type: llm
---

PASS if the response reports that seats/engineering-risk.md tells the engineer to run db-push against production while board.md forbids it, and labels the finding evidence-backed.
FAIL if the response misses this contradiction, or claims either file says something it does not.
Do not fail the response for extra findings about missing files.
