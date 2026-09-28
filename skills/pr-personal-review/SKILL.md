---
name: pr-personal-review
description: Draft author-perspective comments on a PR as a pending review (not submitted) to guide reviewers toward critical change areas and clarify non-obvious logic.
compatibility: opencode
metadata:
  audience: engineers
  scope: pull-request-review-prep
  style: concise
---

## What I do
- Analyze a PR's diff in the context of its stated purpose.
- Identify the most critical change areas that are central to the PR's theme.
- Draft targeted comments on the PR highlighting these areas and explaining *why* they matter, as a pending (draft) review.
- Clarify code that could be confusing, subtle, or easily misunderstood by someone reading the diff cold.
- Leave the review in a pending/draft state for the user to check and submit themselves — never submit it automatically.

## When to use me
Use this skill after a PR is ready for review but before requesting reviewers. The goal is to reduce reviewer ramp-up time and focus attention on what matters most.

## Core operating rules
- Use `gh` CLI for all GitHub operations (fetching PR info, drafting comments).
- Read the PR title, body, and full diff to understand the theme and scope.
- Do NOT post comments on trivial or self-explanatory changes (imports, formatting, renames with obvious intent).
- Every comment must add reviewer value—either by highlighting criticality or clarifying complexity.
- Keep comments concise. Lead with the insight; skip preamble.
- Create a single PR review as a pending draft (not individual standalone comments, and not submitted) attached to specific lines/files via the GitHub API.
- Never submit the review — no `event` value, no follow-up submit call. The review must remain in `PENDING` state, visible only to its author, until the user submits it themselves.

## Comment categories
Post comments that fall into one or more of these categories:

### Removal rationale
Explain *why* something was removed or replaced, not just that it's gone. Reviewers often wonder whether a deletion is safe.
- Example: "we no longer use basic auth and so don't need `htpasswd` for nginx"

### External references
Link to external tools, services, or docs that give the reviewer context they can't get from the diff alone.
- Example: "These come from the IBM W3 SSO Provisioner [here](https://w3.ibm.com/security/sso-provisioner/applications/...) (VPN required) and have already been added as secrets in this repo"
- Example: "This uses [oauth2-proxy](https://github.com/oauth2-proxy/oauth2-proxy) to handle all of the back-and-forth with W3 for token exchange"

### Pointing to in-code documentation
When the code itself is well-documented, direct the reviewer to read those comments instead of restating them.
- Example: "Check out the comments on each stanza, tried to document this well in code"

### Security and access implications
Call out changes that affect security boundaries, access control, or secret management so reviewers don't overlook them.
- Example: "This makes `/w3/auth` unavailable to the outside world"

### Critical to theme
Changes that are the core of what the PR accomplishes. Flag these so reviewers know where to focus deepest attention.
- Example: "These are improving upon error handling and dealing with IDs now being auto-assigned UUIDs, so format is important"

### Analogous patterns
Point reviewers to existing code that follows the same pattern, so they can compare and build a mental model faster.
- Example: "This is analogous to `internal/catalog/postgres.go`, it just stores rules instead of registered agents"
- Example: "These tests are built in the same way as `internal/catalog/postgres_test.go` using `go-sqlmock`"

### Non-obvious logic
Code that does something subtle, has implicit assumptions, or could be misread.
- Example: "This nil check also covers the case where the context was cancelled before the goroutine started, since `err` would be non-nil but `resp` would still be nil."

### Important context
Decisions that require background knowledge the reviewer may not have, including recent changes in other PRs that inform this one.
- Example: "These are no longer user-controlled as they are UUIDs. The user can still use the description field to give human-friendly information."
- Example: "This is the S3-based implementation that is fully replaced by the Postgres-based implementation in this PR"

## Process
1. Fetch the PR metadata: `gh pr view <number> --json title,body,baseRefName,headRefName`
2. Fetch the full diff: `gh pr diff <number>`
3. Identify the PR's theme from the title and body.
4. Look at recent merged PRs and the surrounding codebase to understand patterns and context that reviewers may not have fresh in mind.
5. Walk the diff and select locations that are critical, subtle, or likely to confuse. Look for code that mirrors existing patterns elsewhere in the repo.
6. Draft comments—one per location. Each comment should be 1-2 informal sentences max. Keep the tone conversational and direct. Reference analogous code paths or recent changes when it helps build the reviewer's mental model.
7. Create all comments as a single pending PR review using the GitHub API. The review must:
   - Omit `event` entirely — do not pass `COMMENT`, `APPROVE`, or `REQUEST_CHANGES`. Omitting it leaves the review in `PENDING` state instead of submitting it.
   - Set the review body to `"Personal review"`.
   - Include all comments in the `comments` array of the same request (not posted individually).
   - Comments can be file-level (`path` only) or line-level (`path` + `line`) depending on what best serves the reviewer.
   - Use `gh api repos/{owner}/{repo}/pulls/{number}/reviews` with a single POST containing `body` and `comments` — no `event` field.
   - Do not call any endpoint that submits or finalizes the review (e.g. `POST .../reviews/{review_id}/events`) — creating it is the whole job.
8. Report back with a summary of how many comments were drafted, which files they target, and a reminder that the review is pending and needs to be checked and submitted by the user (in the PR's "Files changed" tab, via the "Finish your review" button).

## Constraints
- Do not suggest code changes. This is not a code review—it is author context for reviewers.
- Do not duplicate information already present in the PR body. It is fine to supplement or point to specific details the body covers at a high level.
- Do not comment on files or hunks that are outside the PR's stated scope.
- Aim for 3-8 comments on a typical PR. Fewer is fine if the PR is straightforward; more is acceptable for complex PRs, but never be noisy.
- Never submit the pending review. The user reviews the drafted comments and submits (or edits/discards) the review themselves.
