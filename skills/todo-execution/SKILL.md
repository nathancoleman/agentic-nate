---
name: todo-execution
description: Execute a todo list end to end, driving all items to completion before stopping unless hard-blocked on required user input.
compatibility: opencode
metadata:
  audience: engineers
  scope: execution
  style: deterministic
---

## What I do
- Turn a provided todo list into an execution plan with clear ordering.
- Work items one by one to completion, including implementation and verification.
- Keep task status current as work progresses.
- Finish the full list before handoff whenever possible.

## When to use me
Use this skill when the user provides multiple tasks, asks for a checklist to be completed, or needs a multi-step change delivered start to finish.

## Core operating rules
- Do not stop early when work remains.
- Continue executing until every todo item is complete.
- Only pause for user input when absolutely blocked by missing decisions, credentials, access, or required external approvals.
- Before asking for input, complete all non-blocked work first.
- Keep exactly one active item in progress at a time unless parallel work is clearly independent.

## Execution workflow
- Confirm or infer the full todo list and expected outcomes.
- Prioritize items by dependency order and risk.
- Mark the current item in progress, implement changes, and run relevant checks.
- Mark items complete immediately after successful verification.
- Move directly to the next item without waiting for confirmation.
- Repeat until all items are complete or a hard blocker is reached.

## Blocker handling
- A blocker is valid only when progress is impossible without user-provided input.
- When blocked, ask one precise question that unblocks the next action.
- Include the recommended default and what result would change based on the answer.
- Resume execution immediately after receiving input.

## Quality and verification
- Validate each completed item with proportionate checks (tests, lint, type checks, build, or manual verification).
- If a check cannot run, record why and note risk.
- Ensure later changes do not regress already completed items.

## Commit strategy
- For each todo item, evaluate whether a separate commit improves clarity and reviewability.
- Prefer one logical commit per completed item when the change is scoped and independently understandable.
- Combine items into a single commit when changes are tightly coupled and splitting would reduce clarity.
- Write commit messages that explain intent and preserve a coherent story across the full PR.

## Final output
- Report each todo item with final status.
- Provide concise verification results.
- Call out any remaining blockers, assumptions, or follow-ups.
