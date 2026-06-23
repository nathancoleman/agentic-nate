---
name: pr-feedback
description: Triage and resolve PR review feedback with clear replies, scoped changes, and proper thread resolution.
compatibility: opencode
metadata:
  audience: engineers
  scope: pr-review-feedback
  style: adaptive
---

## What I do
- Triage review feedback into actionable items.
- Implement requested changes while respecting the PR's stated scope.
- Reply to review threads with clear outcomes and resolve them when complete.
- Re-request reviews from automated reviewers (e.g., Copilot) after addressing their feedback.

## When to use me
Use this skill when addressing review comments, resolving conversations, or iterating on a PR based on reviewer feedback.

## Core operating rules
- Use the GitHub CLI (`gh`) for PR operations.
- Rely on the existing `gh` authentication context; do not add separate authentication steps unless `gh` reports an auth error.
- Treat each review thread as a mini work item: understand ask, implement, reply, then resolve when complete.
- If code changed in response to a thread, post a reply describing what changed before resolving.
- Do not resolve a thread with an open reviewer question or intentionally deferred work; reply with rationale and next step instead.
- If any addressed feedback came from Copilot, always re-request a review from Copilot before handoff.
- During review-driven iterations, favor precise edits over broad refactors unless a refactor is required for correctness, safety, or maintainability.

## Feedback triage and conversation resolution
- Gather open review threads and group them by file or theme.
- Skip any thread where the PR author (the user) left the most recent comment. A trailing comment from the author means the ball is in the reviewer's court—do not reply again or take further action on that thread.
- Before acting on any feedback, evaluate whether it falls within the PR's stated scope (title, body, and the intent of the existing diff).
- If feedback requests changes that are clearly outside the PR's scope (e.g., unrelated refactors, feature requests, or fixes to pre-existing issues not introduced by this PR):
  - Do NOT implement the out-of-scope change.
  - Reply to the thread politely explaining that the suggestion is out of scope for this PR, and suggest it be tracked separately (e.g., as a new issue or follow-up PR).
  - Do not resolve the thread—leave it for the reviewer to acknowledge.
- Implement changes in logical batches and run proportional validation.
- Resolve a conversation only when both are true:
  - The requested change is implemented (or a clear non-code resolution is agreed).
  - A reply is posted on the thread with a concise outcome.
- If you already pushed the fix but have not replied yet, reply first, then resolve.
- Before handoff, re-check for unresolved threads and close any that now satisfy the rule above.
- For thread resolution, use GraphQL `resolveReviewThread` via `gh api graphql`.
- Re-request Copilot review with `gh pr edit --add-reviewer "github-copilot[bot]"` after resolving Copilot feedback.

## Copilot review loop
- After re-requesting Copilot review, poll for the new review to appear (check via `gh api repos/{owner}/{repo}/pulls/{number}/reviews`).
- Once the new review lands, check for any new Copilot comments.
- If Copilot left new comments, address them, push fixes, resolve threads, and re-request Copilot review again.
- Repeat this cycle until Copilot leaves no comments.

## Validation
- Run relevant checks (tests, lint, type checks, build) when available and proportionate.
- If checks are skipped or blocked, state that explicitly with reason and impact.

## Final output
- Provide the PR URL.
- Report which feedback items were addressed.
- Report which conversation threads were resolved and why.
- State whether Copilot feedback was involved and confirm Copilot review was re-requested.
- Call out any intentionally open threads with required follow-up.
