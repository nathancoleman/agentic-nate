---
name: diagramming
description: Create clear technical diagrams as hand-drawn Excalidraw visuals, captured as images, with mandatory sequence and architecture views.
compatibility: opencode
metadata:
  audience: engineers
  scope: diagrams
  style: structured
---

## What I do
- Produce technical diagrams using the Excalidraw MCP tool (`mcp__Excalidraw__create_view`), not Mermaid code blocks.
- Provide both a sequence diagram and an architecture diagram for every diagramming request.
- Keep diagrams concise, readable, and aligned to the implementation context.
- Capture each rendered diagram as an image and embed the image (not source code) in documentation.
- Update diagrams when system behavior or structure changes.

## When to use me
Use this skill when documenting flows, APIs, services, integrations, deployments, or system structure — anywhere a diagram will ship in docs, a README, a PR description, or a design doc.

## Core operating rules
- Call `mcp__Excalidraw__read_me` once per conversation before the first `create_view` call, to load the element format and color palette.
- Build diagrams with `mcp__Excalidraw__create_view` elements (rectangles, arrows, labels, lifelines) rather than Mermaid syntax.
- Always include exactly two primary diagrams per request:
  - A sequence view (actor columns with dashed lifelines and labeled arrows) for runtime interactions.
  - An architecture view (boxes/zones with labeled connectors) for component/service structure.
- Label participants/components with clear, domain-specific names.
- Keep edge labels short and meaningful; avoid overlength labels on short arrows.
- Prefer left-to-right flow for architecture views when it improves readability.
- If details are unknown, use explicit placeholders rather than guessing.
- Follow the Excalidraw skill's own sizing/camera/color guidance (4:3 camera ratios, minimum font sizes, consistent palette) so the captured image is legible.

## Diagram quality requirements
- Sequence diagrams must show the main success path and key alternate/error path when relevant.
- Architecture diagrams must show boundaries (client, app, data, external systems) when applicable.
- Include protocols/interfaces on important edges (HTTP, gRPC, queue, DB, etc.) when known.
- Keep node count manageable; split into focused diagrams if a single view gets crowded.
- End each diagram on a full-diagram `cameraUpdate` so the capture frames the whole thing, not a mid-build close-up.

## Capturing diagrams for documentation
- After `create_view` renders the diagram, capture it as a static image (screenshot or export) rather than pasting Excalidraw element JSON or Mermaid source into docs.
- Save captured images alongside the documentation they support (e.g. a repo's `docs/images/` or `docs/diagrams/` folder) using a descriptive filename (e.g. `auth-sequence.png`, `ingest-architecture.png`).
- Embed images in Markdown with descriptive alt text summarizing the diagram's content, e.g. `![Sequence diagram: client requests an OAuth token from the auth service](docs/images/auth-sequence.png)` — alt text matters for accessibility and for readers whose renderer doesn't load images.
- Never commit raw Excalidraw element JSON or screenshots of unfinished/mid-animation frames into documentation.

## Output format
- Start with a one-paragraph context summary.
- Render one Excalidraw sequence diagram via `create_view`, then capture it as an image.
- Render one Excalidraw architecture diagram via `create_view`, then capture it as an image.
- Embed both captured images in the final documentation output.
- End with brief assumptions and open questions.

## Final checks
- Verify both required diagram views were rendered and captured as images.
- Verify captured images are referenced in docs with descriptive alt text, not left as loose files.
- Verify names and flows match the described system behavior.
