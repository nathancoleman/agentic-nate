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
- For PRs tracked by the `gh stack` extension, sync the whole stack at once with `gh stack sync` instead of rebasing branch-by-branch.
- For standalone PRs, rebase each one onto the latest version of its base branch directly.
- Resolve merge conflicts.
- Identify recent changes merged into main that affect the PR and make appropriate adjustments (e.g., updated imports, renamed functions, changed APIs, new patterns).
- Push the updated branches.

## When to use me
Use this skill when you want to bring all open PRs up to date with their base branches, especially after significant changes have been merged.

## Process
1. Fetch latest refs: `git fetch origin`.
2. List my open PRs: `gh pr list --author @me --state open --json number,headRefName,baseRefName,title`.
3. Group PRs into stacks vs. standalone: check out each branch and run `gh stack view` — branches it reports together belong to one stack. Process each distinct stack once, as a unit; process standalone PRs individually.
4. For each stack (once per stack, not once per branch):
   a. Check out any branch belonging to the stack.
   b. Run `gh stack sync` — it fetches, fast-forwards trunk, cascade-rebases every branch in the stack onto its updated parent, and pushes atomically.
   c. If it reports a rebase conflict, it restores all branches to their prior state. Run `gh stack rebase` to resolve interactively (fix conflicts, `git add`, `gh stack rebase --continue`), then `gh stack sync` again to push and sync PR state.
   d. Review recent commits on the base branch to identify changes that may require adjustments in each stack branch (renamed symbols, changed interfaces, new patterns, updated dependencies).
   e. Make any necessary adjustments on top, run available checks (tests, lint, build), and push with `gh stack push` rather than a raw `git push` so the whole stack stays consistent.
5. For each standalone PR, in order:
   a. Check out the PR branch: `gh pr checkout <number>`.
   b. Rebase onto the latest base branch: `git rebase origin/<baseRefName>`.
   c. If conflicts arise, resolve them and continue the rebase.
   d. Review the PR's changes relative to its base and adjust for upstream changes as in step 4d/4e.
   e. Run available checks (tests, lint, build) to verify nothing is broken.
   f. Force push the updated branch: `git push --force-with-lease`.
6. After processing everything, return to the original branch.

## Constraints
- Use `--force-with-lease` for all force pushes on standalone PRs, never `--force`. (`gh stack sync`/`gh stack push` already push stack branches safely on their own.)
- Do not modify the PR title or body — that is the responsibility of the `pr-create-update` skill.
- If a stack sync or a standalone rebase cannot be cleanly completed and conflicts are too complex to resolve confidently, abort (`gh stack rebase --abort`, or restore the standalone branch) and report it in the summary rather than leaving it half-rebased.

## Final output
- List each PR or stack processed with its number(s), title, and outcome (synced, rebased, adjusted, skipped).
- Note any PRs or stacks that were skipped and why.
- Note any adjustments made due to upstream changes.
- Flag any PRs that have pending review feedback or requested changes that need to be addressed.
