# Rebase Deduplication Rule

When rebasing a branch onto another branch, omit commits that are already present in the target branch.

Guidelines:

1. Prefer patch-equivalent deduplication during rebase (do not force reapplying cherry-picks).
2. If a rebased commit becomes empty because the target branch already contains its changes, drop it.
3. If deduplication is uncertain, inspect with `git cherry <target> <branch>` before finalizing.
4. Keep the rebased branch focused on net-new commits only.
