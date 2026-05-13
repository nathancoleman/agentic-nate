---
name: pr-update-branch
description: Update a PR branch after its base branch changes, handling squash-merged commits from earlier stacked PRs.
compatibility: opencode
metadata:
  audience: engineers
  scope: branch-maintenance
  style: concise
---

## What I do
- Update a PR branch to incorporate changes from its base branch.
- Cleanly remove commits that were part of an earlier stacked PR that has since been squash-merged.

## When to use me
Use this skill when a PR's base branch has been updated (e.g., an earlier PR in a stack was squash-merged into main) and the branch needs to be brought up to date.

## The squash merge problem
When an earlier PR in a stack is squash-merged, its individual commits are collapsed into a single new commit on the base branch. The original commit hashes from that PR still exist on the current branch but have no matching hashes in the base branch. A naive `git rebase` will try to replay those commits, causing conflicts or duplicated changes.

## Process
1. Fetch latest refs: `git fetch origin`.
2. Identify the PR's base branch and check out the PR branch.
3. Determine which commits on the current branch were part of the already-merged earlier PR. Use `git log --oneline origin/<base>..HEAD` to see all commits, and compare against the earlier PR's commits (check the squash merge commit message on the base branch, which typically lists the original PR number).
4. Rebase interactively onto the updated base branch, dropping the commits that were part of the squash-merged PR:
   ```
   git rebase --onto origin/<base> <last-commit-from-merged-pr> HEAD
   ```
   This replays only the commits unique to the current PR on top of the updated base.
5. If conflicts arise, resolve them and continue.
6. Verify the branch diff against the base looks correct — it should only contain changes from the current PR, not duplicates from the merged one.
7. Force push with `--force-with-lease`.

## Constraints
- Use `--force-with-lease` for all force pushes, never `--force`.
- If the PR also needs its title/body updated after this operation, defer to the `pr-create-update` skill.
- If the earlier PR's commits cannot be confidently identified, fall back to an interactive rebase and resolve manually rather than guessing.

## Final output
- Confirm the branch was updated and which commits were dropped.
- Report any conflicts that were resolved.
- Note if the PR diff against its base looks clean.
