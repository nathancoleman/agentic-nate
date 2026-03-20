---
name: github-actions-workflows
description: Design, update, and harden GitHub Actions workflows with secure defaults and reliable CI behavior.
compatibility: opencode
metadata:
  audience: engineers
  scope: ci-cd-workflows
  style: deterministic
---

## What I do
- Create and modify GitHub Actions workflow files.
- Improve workflow reliability, performance, and safety.
- Enforce secure supply chain practices for action dependencies.
- Validate workflow structure and trigger behavior against repository needs.

## When to use me
Use this skill when adding a new workflow, updating an existing workflow, debugging CI execution behavior, or tightening workflow security.

## Core operating rules
- Define workflows under `.github/workflows/` with clear names and focused responsibilities.
- Keep jobs and steps readable, with explicit conditions and minimal hidden behavior.
- Use least-privilege permissions at workflow and job level.
- Prefer deterministic behavior over convenience defaults.
- For every consumed GitHub Action (`uses:`), pin to a full commit SHA hash; never use moving tags (for example `@v4`, `@v1`, `@main`) as the effective reference.

## Action pinning policy
- Every third-party or first-party action reference must use `owner/repo/path@<40-char-commit-sha>`.
- It is acceptable to annotate the pinned hash with a comment indicating the corresponding release tag for readability.
- When upgrading an action, update the pinned SHA intentionally and verify changelog or release notes.
- If a requested change includes unpinned actions, treat pinning as mandatory remediation, not optional cleanup.

## Security and hardening defaults
- Set explicit `permissions:` and avoid broad write scopes unless required.
- Avoid exposing secrets to untrusted contexts (for example `pull_request` from forks).
- Use trusted inputs and quote shell variables where appropriate.
- Prefer official setup actions and cache approaches that do not leak credentials.
- Keep artifact retention and token usage scoped to the minimum needed.

## Authoring checklist
- Confirm trigger design (`push`, `pull_request`, `workflow_dispatch`, schedule) matches intent.
- Confirm concurrency and cancellation behavior for noisy branches.
- Confirm matrix strategy is necessary and bounded.
- Confirm timeout and retry strategy where failures are expensive.
- Confirm all `uses:` entries are SHA-pinned.

## Validation and review
- Validate YAML syntax and basic schema expectations.
- Check for unpinned `uses:` references before handoff.
- Summarize workflow intent, trigger paths, and any permission changes.
- Call out operational risks (runtime cost, secret exposure, flaky steps) and mitigations.

## Quick audit snippet
Use this before handoff to find likely unpinned `uses:` entries in workflow files:

```bash
rg -n '^\s*uses:\s*[^#\n]+@(?![a-fA-F0-9]{40}\b)' .github/workflows/*.yml .github/workflows/*.yaml
```

- Any match is a blocker until converted to a full 40-character commit SHA.
- Re-run after fixes and confirm zero matches.

## Final output
- List created or modified workflow files.
- Confirm all consumed actions are pinned to commit SHAs.
- Note any follow-up upgrades or hardening work that remains.
