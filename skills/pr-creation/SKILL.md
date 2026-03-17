---
name: pr-creation
description: Create high-quality pull requests with clear reviewer context, right-sized scope, and adaptive formatting that matches repository conventions.
compatibility: opencode
metadata:
  audience: engineers
  scope: pull-requests
  style: adaptive
---

## What I do
- Plan, prepare, and open reviewer-friendly pull requests.
- Keep PRs right-sized and split oversized work into a coherent stack when needed.
- Ensure commit and PR sequencing tells a clear story from first change to final integration.
- Keep PR metadata current as changes evolve.

## When to use me
Use this skill when creating a new pull request, updating an existing pull request, or restructuring large work into stacked pull requests.

## Core operating rules
- Use the GitHub CLI (`gh`) for PR operations (`gh pr create`, `gh pr edit`, `gh pr view`, `gh pr status`).
- Rely on the existing `gh` authentication context; do not add separate authentication steps unless `gh` reports an auth error.
- Always open newly created PRs in the browser immediately after creation (`gh pr view --web` or equivalent).
- Aim for PR size under 400 changed lines.
- Slightly above 400 is acceptable when the change remains easy to review.
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
- Keep this note accurate if PR numbers, ordering, or dependencies change.
- On updates, check whether the referenced prior PR has merged; if it has, remove the top-of-body stack warning from the current PR.

## Adaptive PR formatting
- First, infer repository conventions from existing PRs, commit history, or contribution docs.
- If conventions are clear, match them.
- If conventions are unclear, use a concise default structure that covers purpose, change scope, validation, and risks.
- Avoid rigid templates when they do not match the repo's normal style.

## Update behavior on every push
- Whenever updates are pushed to a PR, re-check whether the title and body still match the current diff and intent.
- Update the title and body whenever appropriate to prevent stale reviewer context.
- For stacked PRs, re-validate dependency references and top-of-body stack notes after each update.

## Validation and readiness checks
- Confirm branch and base branch are correct.
- Review full branch delta, not only the latest commit.
- Run relevant checks (tests, lint, type checks, build) when available and proportionate.
- If checks are skipped or blocked, state that explicitly with reason and impact.

## Final output
- Provide the PR URL.
- Provide a short readiness summary with: scope, validations run, notable risks, and stack position (if applicable).
