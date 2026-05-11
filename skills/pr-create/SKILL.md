---
name: pr-create
description: Create, format, and maintain pull requests — sizing, stacking, metadata, and keeping PR descriptions current.
compatibility: opencode
metadata:
  audience: engineers
  scope: pr-creation-and-maintenance
  style: adaptive
---

## What I do
- Plan, prepare, and open reviewer-friendly pull requests.
- Keep PRs right-sized and split oversized work into a coherent stack when needed.
- Ensure commit and PR sequencing tells a clear story from first change to final integration.
- Keep PR metadata current as changes evolve.
## When to use me
Use this skill when creating or updating a pull request, or restructuring large work into stacked pull requests. For addressing review comments and requested changes, use the `pr-feedback` skill instead.

## Core operating rules
- Use the GitHub CLI (`gh`) for PR operations (`gh pr create`, `gh pr edit`, `gh pr view`, `gh pr status`).
- Rely on the existing `gh` authentication context; do not add separate authentication steps unless `gh` reports an auth error.
- Always open newly created PRs in the browser immediately after creation (`gh pr view --web` or equivalent).
- If a Jira ticket is tied to the work, put a Jira link at the very top of the PR body using this exact format: `[AGX-10](https://hashicorp.atlassian.net/browse/AGX-10)` (replace key consistently in both places).
- Aim for PR size under 400 changed lines.
- Slightly above 400 is acceptable when the change remains easy to review.
- When multiple valid implementation paths exist, prefer the one that minimizes the net PR diff while still fully addressing the request.
- If a PR becomes significantly larger, split into a stack of targeted pull requests.
- Prefer targeted commits that each represent one logical step.
- In a stack, each PR must also be targeted and represent a clear step in the overall story.

## Stacked PR requirements
- Build the stack in dependency order so each PR can be reviewed with minimal context switching.
- Create every stacked PR after the first in draft mode initially (`gh pr create --draft`).
- Every PR after the first must add this note at the very top of the PR body:

```md
> [!NOTE]
> This PR is part of a stack. Please review #<previous-pr-number> first.
```

- Replace `<previous-pr-number>` with the immediately preceding PR in the stack.
- When a Jira ticket is tied to the work, the Jira link stays first and the stack note goes immediately below it.
- Keep this note accurate if PR numbers, ordering, or dependencies change.
- If stacked PR titles use a Jira key prefix in brackets (for example, `[PROJ-123]`), every later PR in that stack must keep the same bracketed Jira prefix as the earlier PRs.
- When creating a later PR in a stack, infer the Jira prefix from the prior PR title and reuse it exactly (including bracket format).
- On updates, check whether the referenced prior PR has merged; if it has, remove the top-of-body stack warning from the current PR.

## Adaptive PR formatting
- First, infer repository conventions from existing PRs, commit history, or contribution docs.
- If conventions are clear, match them.
- If conventions are unclear, use a concise default structure that covers purpose, change scope, validation, and risks.
- Avoid rigid templates when they do not match the repo's normal style.
- Write PR summaries that communicate the larger theme or motivation behind the changes, not a file-by-file changelog. Explain *why* the PR exists, what problem it solves, and how the approach works at a high level. Avoid enumerating individual changes unless a specific item is surprising or carries risk.
- Use an informal summary style — write in plain language as if explaining the PR to a teammate, not generating a changelog. Do NOT use bullet-point lists of every file or function touched. A short paragraph or two is ideal.
- Do not include internal state transitions or intermediate steps that are not present in the final PR diff.
- During review-driven iterations, favor precise edits over broad refactors unless a refactor is required for correctness, safety, or maintainability.

## Update behavior on every push
- Whenever updates are pushed to a PR, re-check whether the title and body still match the current diff and intent.
- Update the title and body whenever appropriate to prevent stale reviewer context.
- When editing the PR body, preserve any existing screenshots or images (markdown image syntax or HTML `<img>` tags) in place. Do not remove, reorder, or rewrite image references.
- Re-validate the Jira link at the top of the PR body (when applicable) and keep the key/URL aligned.
- For stacked PRs, re-validate dependency references and top-of-body stack notes after each update.
- For stacked PRs with bracketed Jira prefixes in titles, re-validate prefix consistency across the full stack after each update.

## Validation and readiness checks
- Confirm branch and base branch are correct.
- Review full branch delta, not only the latest commit.
- Run relevant checks (tests, lint, type checks, build) when available and proportionate.
- If checks are skipped or blocked, state that explicitly with reason and impact.

## Final output
- Provide the PR URL.
- Provide a short readiness summary with: scope, validations run, notable risks, and stack position (if applicable).
