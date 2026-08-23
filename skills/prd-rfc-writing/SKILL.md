---
name: prd-rfc-writing
description: Draft PRDs and RFCs using the live PRD/RFC Template docs in the shared Drive, and publish them as Google Docs in the matching PRDs/RFCs folder.
compatibility: opencode
metadata:
  audience: engineers, product
  scope: prd-rfc-writing
  style: narrative
---

## What I do
- Draft Product Requirements Documents (PRDs) and RFCs.
- Source the structure from the actual template docs living in the shared Drive's **PRDs** and **RFCs** folders — not from a static copy — so edits to those templates are picked up automatically.
- Publish the finished document as a native Google Doc directly in the shared Drive, in the folder matching the document type — never as a local markdown file.

## When to use me
Use this skill whenever the user asks to write, draft, or start a PRD or RFC — for a new feature, a technical proposal, a process change, or similar.

## Where documents (and templates) live
- PRDs go in the shared **PRDs** Drive folder (folder ID `1gieY94qkBt6PA55zl5dsaLiayZHRwRmo`). Its `PRD Template` doc (ID `11u41Ehw8Qt_XqjTG1luwGZ9oNXn6eEiMqMrOp-iBAT0`) is the source of truth for PRD structure.
- RFCs go in the shared **RFCs** Drive folder (folder ID `10XCz6xyU9fQmMqd82SpZNy6UCHMMTner`). Its `RFC Template` doc (ID `1SIKIuA3kyHW2NiSyRWIw1DSA5VHGzssV-IICtHGgdOQ`) is the source of truth for RFC structure.
- **Before drafting, re-fetch the current template with `read_file_content` on the ID above.** Templates can change; the snapshots below are a fallback for when the live fetch fails, not the authority. If the live template's fields or sections differ from the snapshot, follow the live one and note the drift so this file can be updated.
- If a template ID 404s, search the corresponding folder for a doc titled `PRD Template` / `RFC Template` (Drive `search_files` with `parentId = '<folder id>' and title contains 'Template'`) rather than guessing.
- If either folder ID ever 404s, search for folders titled `PRDs` / `RFCs` instead of guessing a new location.
- Never place a PRD in the RFCs folder or vice versa, even as a draft — put it directly in the correct one from the start.

## Template snapshots (fallback only — prefer the live fetch above)

### PRD Template structure
```
# [PRD] <Title>

|  |  |
| :-: | :-: |
| **Summary:** <one-sentence summary of the problem> |  |
| **Created:** <date> | **Status:** WIP | In Review | Approved | Obsolete |
| **Owner:** <email> | **RFC:** <link to RFC when created> |
| **Contributors:** <email, email> |  |

<Intro paragraph, no heading — written LAST, after the rest of the doc, so it summarizes the
actual final content rather than an anticipated one.>

## Background
<Context a newcomer needs before the problem makes sense — enough to understand the problem
domain, not just what follows. Visual explanations (diagrams, screenshots) are welcome here.>

## Problem
<The core section. Distill user research into clear problem statements mapped to the personas
below. Personas are generalized versions of the actual people interviewed, not the individuals.>

### Personas
- **<Affected Persona 1>** has trouble <doing X> with this problem
- **<Affected Persona 2>** has trouble <doing Y> with this problem

## Requirements and Phases
<Summary table first — Phase title in the left column, its requirements listed in the right:>

|  | **Requirements** |
| :-: | :-: |
| **Phase 1:** <title> | <requirement> |
|  | <requirement> |
| **Phase 2:** <title> | <requirement> |

<Phases build on each other in sequential order of value (not a separate priority ranking); each
is incomplete until all its requirements are met; each should deliver end-to-end value on its own
even if no later phase ships. One phase is fine if the problem doesn't need more.>

### <Phase 1 title>
<The phase's objective, referencing the persona it serves.>

#### <Requirement 1>
<Requirements are NOT prioritized relative to each other within a phase — all are required for the
phase to be complete. A requirement of unequal priority belongs in its own phase instead. A
requirement may need one or more RFCs.>

##### Acceptance Criteria
<Written like test cases — objective enough that anyone can validate they're met before release.>
1. <criterion>

##### Considerations
<A question FOR the RFC author, not a suggestion — may be answered in the RFC or dismissed
outright. Most review comments should target these and get deflected to the RFC.>
1. <consideration>

<Repeat #### Requirement / Acceptance Criteria / Considerations per requirement, and
### Phase N per phase.>

## User Research
<The most important section — grounds the PRD in real, experienced user problems. Better research
surfaces patterns and simplifies the problem statement.>

### <Customer>
<Link the interview notes, add a short paragraph on their workflow today, and list takeaways.>
1. <problem/takeaway>

## Approvals
<Every stakeholder below must sign off before kickoff and RFC writing. Sign-off requires: the
release summary defines which acceptance criteria are in scope; Engineering and Product Management
agree on the target release; there's sufficient clarity to author the RFC; and engineering + design
have reviewed the PRD in a meeting. Mark approved names with a checkmark.>
- Project Engineering Lead:
- Product Manager:
- VP of Product:
- Sales Engineer Lead:
- Product Design Lead:
<Add other approvers as necessary.>
```

### RFC Template structure
```
# [RFC] <Title>

|  |  |
| :-: | :-: |
| **Summary:** <one-sentence summary of the proposal> |  |
| **Created:** <date> | **Status:** WIP | In-Review | Approved | Obsolete |
| **Current Version:** <e.g. 1.0.4> | **Owner:** <email> |
| **Target Version:** <e.g. 1.1.0> | **Contributors:** <email> |
| **PRD:** <link to PRD if applicable> | **Other stakeholders:** <email> |
|  | **Approvers:** <email> |

<Overview paragraph, no heading — one or two paragraphs stating the RFC's goal WITHOUT diving into
the why/why-now/how; a reader should understand intent just from this paragraph.>

## Background
<At least two paragraphs, up to a full page. Test: could a newcomer to this project read this
section, follow any links, and get nearly full context on why this change is necessary? Link to
prior RFCs/discussions rather than repeating them.>

## Proposal
<Given the background, propose a solution — the "how" at overview level. Implementation detail
belongs in later sections.>

### Abandoned Ideas (Optional)
<Ideas abandoned as the RFC evolved, organized to make clear they were abandoned and why — so
future readers don't repeat the same dead end.>

## <Freeform section — Heading 2>
<From here, sections are freeform per RFC. Order them so each answers a critical question and
builds toward the next, rather than making the reader jump around. Split into Heading 3
sub-sections as needed. Common examples:>

### Implementation
<Rough API changes (internal/external), package changes, etc. — enough for reviewers to see the
subsystems and surface area affected. Writing this out often surfaces issues before code exists.>

### UX
<User-facing changes — external APIs, config formats, CLI output, backwards compatibility — so a
reviewer can tell whether the change feels consistent with the rest of the project.>

### UI
<If this affects the web UI: collaborate with a frontend engineer/designer and attach
wireframes/mockups/prototypes. Substantial UI changes may warrant their own follow-up RFC.>
```

**Do not include a "Style Notes" section in the finished document** — it's authoring guidance baked into the template for whoever fills it in, not content that belongs in a real PRD/RFC (none of the org's actual filed PRDs/RFCs carry one). Still follow its rules when formatting:
- Heading 2 for section titles (Heading 1 renders too large); Heading 3 for sub-sections; deeper nesting is rare.
- Bold the first phrase of each list item to flag its category/point.
- Body text is 11pt Arial; no color/highlight customization — italics, bold, underline only.
- Indent code samples and set them in Courier New.

## Creating the document
- Re-fetch the live template (see above) and compose the full document as Markdown text, filling every section — delete/replace the template's italicized guidance text, don't leave it in.
- File titles use this org's numbered convention rather than the template's literal `[PRD] <Title>` / `[RFC] <Title>` placeholder: `PRD-XXXX: <Title>` / `RFC-XXXX: <Title>`, zero-padded to 4 digits. Before creating, search the target folder for existing `PRD-####` / `RFC-####` titles, take the highest number, and increment by one (start at `0001` if none exist).
- Create it directly in Drive with the Drive `create_file` tool: `title` = the numbered title above, `parentId` = the correct folder ID, `textContent` = the composed Markdown, `contentMimeType` = `"text/markdown"`. Leave `disableConversionToGoogleType` unset so Drive converts it into a native Google Doc.
- After creation, share the resulting `viewUrl` with the user — don't just say "done."
- Confirm with the user before creating the Drive doc if you're at all unsure of the title, number, or target folder — this is a shared, visible artifact, not a private file.
- Update an existing PRD/RFC in place (same Doc) rather than creating a new one when the user is iterating on a document already drafted this session or previously in Drive.

## Writing style
- Ground every claim in a concrete scenario or named source (a ticket, a thread, a metric) — never assert a problem exists without grounding it.
- Explain rejected alternatives inline, with the actual reason, instead of only stating the chosen path.
- Prefer flowing paragraphs over bullet soup for reasoning; use bullets/numbered lists for acceptance criteria, considerations, personas, and requirements, per the template.
- Surface open questions as the template's own mechanisms — PRD "Considerations" (addressed to the RFC author, not the reader) and RFC "Abandoned Ideas" — rather than inventing new callout formats.

## Core operating rules
- Before drafting, gather (ask the user if not already given): the problem/evidence, affected personas, proposed phases or solution, known alternatives considered, and required approvers/stakeholders.
- Write the PRD's intro paragraph and the RFC's overview paragraph LAST, once the rest of the doc is settled — per the template's own instruction — so they summarize the actual content rather than an anticipated conclusion.
- If details are genuinely unknown, write an explicit placeholder or open question rather than inventing specifics.

## Final checks
- Verify the document has every required section from the live template fetch, in the same order, with no leftover italic guidance text.
- Verify the title follows `PRD-XXXX: <Title>` / `RFC-XXXX: <Title>` with the correct next number.
- Verify the Doc was created in the correct Drive folder (PRDs vs RFCs), and the `viewUrl` was shared with the user.
