---
name: diagramming
description: Create clear technical diagrams using MermaidJS with mandatory sequence and architecture views.
compatibility: opencode
metadata:
  audience: engineers
  scope: diagrams
  style: structured
---

## What I do
- Produce technical diagrams exclusively in MermaidJS syntax.
- Provide both a sequence diagram and an architecture diagram for every diagramming request.
- Keep diagrams concise, readable, and aligned to the implementation context.
- Update diagrams when system behavior or structure changes.

## When to use me
Use this skill when documenting flows, APIs, services, integrations, deployments, or system structure.

## Core operating rules
- Always use MermaidJS code blocks for all diagrams.
- Always include exactly two primary diagram types in outputs:
  - Sequence diagram (`sequenceDiagram`) for runtime interactions.
  - Architecture diagram (`flowchart` or `graph`) for component/service structure.
- Label participants/components with clear, domain-specific names.
- Keep edge labels short and meaningful.
- Prefer left-to-right architecture layout when it improves readability.
- If details are unknown, use explicit placeholders rather than guessing.

## Diagram quality requirements
- Sequence diagrams must show main success path and key alternate/error path when relevant.
- Architecture diagrams must show boundaries (client, app, data, external systems) when applicable.
- Include protocols/interfaces on important edges (HTTP, gRPC, queue, DB, etc.) when known.
- Keep node count manageable; split into focused diagrams if a single view gets crowded.

## Output format
- Start with a one-paragraph context summary.
- Include one Mermaid sequence diagram block.
- Include one Mermaid architecture diagram block.
- End with brief assumptions and open questions.

## Final checks
- Verify both required diagram types are present.
- Verify Mermaid syntax is valid and renderable.
- Verify names and flows match the described system behavior.
