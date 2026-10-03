---
schema: agentcompanies/v1
kind: company
name: Nathan Coleman
slug: nathan-coleman
description: Nathan Coleman's software factory — an architect plans large efforts into demo-able stages, a developer ships them one stage at a time, and a reviewer checks every PR against the house skills.
version: 0.1.0
authors:
  - name: Nathan Coleman
goals:
  - Turn large efforts into an approved, in-repo roadmap of demo-able stages before any code is written.
  - Ship one demo-able stage at a time, pausing for a human test before starting the next.
  - Hold every PR to the standards in the agentic-nate skills.
  - Build backend services in Go with Terraform-managed infrastructure, adapting to the conventions of the GitHub org being worked in.
---

# Nathan Coleman

Nathan Coleman's software factory: a three-agent engineering team driven by explicit human gates.

For background on Nathan Coleman's work and projects, see https://nathancoleman.dev.

## Flow

1. **Architect** takes a large effort and writes a development roadmap markdown file in the target repo: an ordered list of demo-able stages, each listing the PR titles it contains. It opens a PR for the roadmap and requests a Paperclip board approval.
2. Once the board approves and the roadmap PR is merged, the architect creates one issue per stage for the **developer**, each blocked on the previous stage.
3. **Developer** implements a single stage, opening the PRs named in the roadmap with the in-repo coding and PR skills.
4. **Reviewer** reviews each stage's PRs; the developer resolves feedback.
5. The stage goes to the board for manual testing. The next stage starts only after the board approves.

## Stack

Go is the preferred language for backend services and Terraform the preferred infrastructure-as-code tool. Every agent first identifies the GitHub org it is working in (`org-conventions` skill) and adapts: existing repos keep their stack, and the org's PR templates, required checks, shared workflows, and Terraform modules take precedence over factory defaults.

## Gates

- Roadmap approval (Paperclip board approval, linked to the roadmap PR) — before any implementation.
- Code review (reviewer) — on every stage.
- Stage test approval (board) — before the next stage starts.

Skills come from the `skills/` directory of https://github.com/nathancoleman/agentic-nate.
