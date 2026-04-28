---
name: go-coding
description: Write idiomatic Go code with strict whitespace grouping, reliable error handling, and clear test structure.
compatibility: opencode
metadata:
  audience: engineers
  scope: go-implementation
  style: deterministic
---

## What I do
- Implement and refactor Go code using idiomatic package, API, and naming patterns.
- Keep control flow readable through intentional whitespace grouping.
- Enforce consistent error handling patterns that make failures obvious and traceable.
- Write maintainable tests with clear separation between required preconditions and behavioral assertions.

## When to use me
Use this skill when adding or changing Go code, implementing handlers/services/libraries, or writing and updating Go tests.

## Core operating rules
- Always keep a potentially failing statement and its `if err != nil` check directly adjacent.
- Always place exactly one blank line after a completed error-handling block before continuing normal control flow, unless the block ends the function.
- Always group related statements into logical blocks and separate unrelated steps with a single blank line.
- Always avoid dense, unbroken runs of statements when multiple logical phases exist in a function.
- Always avoid excessive vertical spacing; use blank lines only for clear logical boundaries.
- Always propagate `context.Context` when work may block, call external systems, or cross API boundaries.
- Always wrap propagated errors with context using `%w`, and prefer `errors.Is`/`errors.As` for classification.
- Always keep exported APIs intentionally small and behavior-focused.

## Formatting and structure
- Always keep code `gofmt`-clean.
- Always keep imports organized and minimal; use `goimports` when available.
- Always prefer small functions with single-purpose flow over long multi-purpose functions.
- Always keep names explicit enough to remove ambiguity without adding noise.

## Testing rules
- Always prefer `testify/require` and `testify/assert` when that style is already present in the repository.
- Always use `require.*` for prerequisites and invariants that must hold for the rest of the test to be valid.
- Always keep prerequisite `require.*` checks grouped with the setup/action they validate.
- Always group assertions by value under test.
- Always order test checks by subject/value flow, not by assertion family (`require` block then `assert` block).
- Always keep `assert.*` checks directly adjacent to a `require.*` check when both apply to the same value.
- Never insert a blank line between `require.*` and `assert.*` when they target the same value.
- Always insert one blank line only when transitioning to assertions for a different value or concern.
- Always use `assert.*` for non-gating behavioral or property checks.
- Always use table-driven tests when multiple inputs/outputs share one behavioral contract.

## Canonical patterns
Production error-handling flow:

```go
result, err := client.Fetch(ctx, id)
if err != nil {
	return fmt.Errorf("fetch %s: %w", id, err)
}

processed := transform(result)
return processed, nil
```

Test gating and assertion flow:

```go
v, err := doSomething()
require.NoError(t, err)

require.NotNil(t, v)
assert.Equal(t, expectedField, v.Field)
```

Same-value require+assert grouping:

```go
require.Error(t, err)
assert.Contains(t, err.Error(), "xyz")
```

Error save flow with same-value grouping:

```go
err := store.Save(ctx, entry)
require.Error(t, err)
assert.Contains(t, err.Error(), "save catalog entry")
```

Nested/related value grouping:

```go
entry, err := store.Get(ctx, id)
require.NoError(t, err)

require.NotNil(t, entry)
assert.Equal(t, id, entry.ID)

require.NotNil(t, entry.AgentCard)
assert.Equal(t, "Terraform Scanner", entry.AgentCard.Name)
```

## Validation and verification
- Always run proportionate checks for impacted code, typically `go test ./...` or targeted package tests when full-suite execution is unnecessary.
- Always add or update tests for changed behavior unless the change is strictly mechanical and risk-free.
- If a check cannot run, always report the blocker and likely risk.

## Final output
- State what behavior changed and why.
- List files changed and key implementation decisions.
- Report validation commands run, outcomes, and any remaining risk.
