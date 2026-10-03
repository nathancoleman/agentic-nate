---
slug: org-conventions
name: org-conventions
description: Detect the GitHub org a repo belongs to and adapt stack, tooling, and process to that org's conventions, defaulting to Go and Terraform for backend services.
---

# Org conventions

The factory works across several GitHub orgs. Before planning, writing, or reviewing code, work out which org you are operating in and adapt to it. The org's established conventions win over the factory defaults.

## 1. Identify the org

From inside the target repo:

```bash
gh repo view --json owner,nameWithOwner,primaryLanguage,repositoryTopics
```

`owner.login` is the org. Record it in your issue comment (for the Architect, in the roadmap) so the choice is visible to the board.

## 2. Gather the org's conventions

Check these sources in order and stop digging once the picture is clear:

1. **The target repo itself**: `README`, `CONTRIBUTING`, `CLAUDE.md`/`AGENTS.md`, `.github/` (workflows, PR templates, CODEOWNERS), `Makefile`, linters, and the language and IaC already in use.
2. **The org's shared config**: the `<org>/.github` repo (default PR templates, contributing guides, reusable workflows), if it exists.
   ```bash
   gh repo view <org>/.github --json name 2>/dev/null && gh api repos/<org>/.github/contents
   ```
3. **Sibling repos**: the languages and tooling the org uses for comparable services.
   ```bash
   gh repo list <org> --limit 50 --no-archived --json name,primaryLanguage,repositoryTopics,pushedAt
   ```
   Open one or two recently active, comparable repos to see layout, module structure, CI, and Terraform layout.

## 3. Choose the stack

- **Default for new backend services**: Go for service code and Terraform for infrastructure, unless the org has clearly standardized on something else.
- **Existing repos**: always follow the language, frameworks, and IaC tool the repo already uses. Do not introduce Go or Terraform into a repo that uses something else unless the effort explicitly calls for it.
- **New repos in an org with a different established stack**: match the org's stack, and call out the deviation from the Go/Terraform default in the roadmap so the board can overrule it.
- Frontends, scripts, and tooling follow whatever the repo or org already uses.

## 4. Adapt the process

- Follow the org's PR template, branch naming, commit style, required checks, and CODEOWNERS over the factory defaults.
- Reuse the org's shared workflows and Terraform modules instead of writing new ones.
- If the org's conventions conflict with an in-repo skill (for example `go-coding` style vs. an org-wide linter config), the org's enforced tooling wins. Note the conflict in the issue.

## 5. Record what you found

Summarize the detected org, the chosen stack, and any conventions that change how work is done in a short **Org context** section: at the top of the roadmap for the Architect, and in the first issue comment for the Developer and Reviewer. Later stages reuse that summary instead of re-deriving it.
