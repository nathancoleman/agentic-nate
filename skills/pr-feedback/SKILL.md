---
name: pr-feedback
description: Triage and address pull request feedback, respond clearly, and close resolved review conversations.
compatibility: opencode
metadata:
  audience: engineers
  scope: pull-request-feedback
  style: adaptive
---

## What I do
- Process PR review feedback into actionable items.
- Apply fixes, post reviewer replies, and keep context current.
- Resolve GitHub review conversations once feedback is addressed.
- Leave unresolved only the threads that still need reviewer input or follow-up.

## When to use me
Use this skill when a PR has review comments, requested changes, or open conversation threads that need to be addressed and closed out.

## Core operating rules
- Use the GitHub CLI (`gh`) for PR and review-thread operations.
- Treat each review thread as a mini work item: understand ask, implement, reply, then resolve when complete.
- If code changed in response to a thread, post a reply describing what changed before resolving.
- Do not resolve a thread if the reviewer asked an open question that still needs confirmation.
- Do not resolve a thread if work is intentionally deferred; reply with rationale and next step instead.
- If any addressed feedback came from Copilot, always re-request a review from Copilot before handoff.

## Conversation resolution policy
- Resolve a conversation only when both are true:
  - The requested change is implemented (or a clear non-code resolution is agreed).
  - A reply is posted on the thread with a concise outcome.
- If you already pushed the fix but have not replied yet, reply first, then resolve.
- Before handoff, re-check for unresolved threads and close any that now satisfy the rule above.

## Suggested workflow
- Gather open review threads and group them by file or theme.
- Implement changes in logical batches and run proportional validation.
- Reply to each addressed thread with what changed and where.
- Resolve addressed threads.
- If Copilot authored any addressed feedback, re-request Copilot review after updates are pushed.
- Post a final PR update summarizing what was changed and what remains open.

## GitHub CLI guidance
- Prefer `gh pr view`, `gh pr comment`, and `gh api graphql` for thread-level operations.
- For thread resolution, use the GraphQL `resolveReviewThread` mutation via `gh api graphql`.
- Re-request Copilot review with `gh pr edit --add-reviewer "github-copilot[bot]"` after resolving Copilot feedback.
- For auditability, verify no actionable unresolved threads remain before final handoff.

## Final output
- Report which feedback items were addressed.
- Report which conversation threads were resolved and why.
- State whether Copilot feedback was involved and confirm Copilot review was re-requested.
- Call out any intentionally open threads with required follow-up.
