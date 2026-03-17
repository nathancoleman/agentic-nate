---
name: error-debugging
description: Diagnose and resolve software errors quickly with reproducible evidence, focused fixes, and clear verification.
compatibility: opencode
metadata:
  audience: engineers
  scope: debugging
  style: adaptive
---

## What I do
- Investigate runtime, build, test, and integration errors end to end.
- Reproduce failures reliably before proposing changes.
- Isolate root causes with the smallest useful set of observations.
- Implement targeted fixes and confirm the issue is resolved without regressions.

## When to use me
Use this skill when a command fails unexpectedly, tests are flaky, logs show unexplained errors, or behavior diverges from expected output.

## Core operating rules
- Reproduce first, fix second.
- Prefer deterministic repro steps over one-off observations.
- Start with the narrowest failing surface, then expand only as needed.
- Change one variable at a time when investigating cause.
- Favor minimal, high-confidence fixes over broad refactors during incident response.
- After each fix, re-run the original failing scenario whenever possible.
- If the same error or a new error appears, debug and fix it, then re-run again.
- Repeat this diagnose -> fix -> re-run loop until the scenario completes successfully.

## Debugging workflow
- Capture failure context: exact command, environment, inputs, and full error output.
- Classify error source: syntax, type, dependency, config, runtime, data, network, permissions, or external service.
- Form 1-3 root-cause hypotheses and rank by likelihood and blast radius.
- Validate hypotheses with quick, decisive checks that can falsify assumptions.
- Apply the smallest fix that addresses confirmed cause.
- Re-run the original failing path plus nearby validations to catch regressions.
- Continue iterating until no errors remain in the target scenario or a hard blocker is identified.

## Evidence and instrumentation
- Keep logs and traces tied to a specific repro step.
- Add temporary instrumentation only when existing signals are insufficient.
- Remove or minimize temporary debug code before finalizing.
- Preserve useful diagnostics that improve future triage (clear errors, guards, assertions).

## Fix quality requirements
- Ensure the fix addresses root cause, not only symptoms.
- Keep behavior changes explicit and scoped.
- Add or update tests when feasible to lock in the fix.
- If no automated test is practical, document a reliable manual verification path.

## Validation and readiness checks
- Re-run the original failing command and confirm success.
- Run proportionate checks (tests, lint, type checks, build) for impacted areas.
- Confirm no obvious side effects in adjacent code paths.
- If any validation is skipped or blocked, state why and potential impact.

## Escalation and handoff
- If blocked by missing credentials, external outage, or non-reproducible behavior, provide a concrete next-best action.
- Document current hypothesis, evidence gathered, and exact blocker.
- When handing off, include a short timeline of what was tried and what changed.

## Final output
- Provide the root cause in one clear sentence.
- Provide the fix summary with files changed and why.
- Provide verification results: commands run, outcomes, and remaining risks.
