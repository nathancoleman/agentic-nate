# Error-Loop Remediation Pattern

When the user shares error logs or failing command output:

1. Reproduce or run the relevant command immediately.
2. Fix the highest-signal failure first.
3. Re-run the same validation command.
4. Repeat fix-and-retest until the command passes or a true blocker remains.
5. Do not wait for the user to explicitly ask for another test iteration.
6. If blocked by missing credentials, external outages, or permission limits, report the blocker clearly with the exact next input needed.
