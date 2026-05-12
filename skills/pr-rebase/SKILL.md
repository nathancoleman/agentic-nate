---
name: pr-rebase
description: Rebase all open PRs onto latest main and adjust code for recent upstream changes.
compatibility: opencode
metadata:
  audience: engineers
  scope: pr-maintenance
  style: concise
---

## What I do
- Find all of my open PRs in the current repository.
- Rebase each one onto the latest version of its base branch.
- Resolve merge conflicts.
- Identify recent changes merged into main that affect the PR and make appropriate adjustments (e.g., updated imports, renamed functions, changed APIs, new patterns).
- Push the updated branches.

## When to use me
Use this skill when you want to bring all open PRs up to date with their base branches, especially after significant changes have been merged.

## Process
1. Fetch latest refs: `git fetch origin`.
2. List my open PRs: `gh pr list --author @me --state open --json number,headRefName,baseRefName,title`.
3. Order PRs so that stacked PRs are processed base-first (if PR A's branch is the base of PR B, process A before B).
4. For each PR, in order:
   a. Check out the PR branch: `gh pr checkout <number>`.
   b. Rebase onto the latest base branch: `git rebase origin/<baseRefName>`.
   c. If conflicts arise, resolve them and continue the rebase.
   d. After rebasing, review the PR's changes relative to its base.
   e. Review recent commits on the base branch to identify changes that may require adjustments in the PR (renamed symbols, changed interfaces, new patterns, updated dependencies).
   f. Make any necessary adjustments to keep the PR consistent with the current state of main.
   g. Run available checks (tests, lint, build) to verify nothing is broken.
   h. Force push the updated branch: `git push --force-with-lease`.
4. After processing all PRs, return to the original branch.

## Constraints
- Use `--force-with-lease` for all force pushes, never `--force`.
- Do not modify the PR title or body — that is the responsibility of the `pr-create-update` skill.
- If a PR cannot be cleanly rebased and conflicts are too complex to resolve confidently, skip it and report it in the summary.
- Process stacked PRs in dependency order (base of stack first).

## Final output
- List each PR processed with its number, title, and outcome (rebased, adjusted, skipped).
- Note any PRs that were skipped and why.
- Note any adjustments made due to upstream changes.
