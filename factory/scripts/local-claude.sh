#!/usr/bin/env bash
# Switches existing Paperclip agents to the claude_local adapter with the CLI engine.
#
# Paperclip's default "Claude Code" harness in the UI is its sandboxed runner
# (paperclip_runner), which gives each run a private HOME and strips the
# environment, so agents can't use this machine's gh login. claude_local runs
# the claude CLI directly as you. The CLI engine uses the claude on PATH; the
# default ACP engine bundles its own, older Claude Code, which can be too old
# for the newest models.
#
# The Paperclip UI has no option for claude_local, and saving an agent's
# harness there switches it back to the runner. Re-run this after doing that.
#
# Usage: local-claude.sh <company-id> [agent-name...]   (no names = every agent)
set -euo pipefail

DRY_RUN="${DRY_RUN:-0}"

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

company_id="${1:-}"
[[ -n "$company_id" ]] || die "usage: $0 <company-id> [agent-name...]"
shift
command -v paperclipai >/dev/null 2>&1 || die "paperclipai is not on PATH; run make deps first"

agents="$(paperclipai agent list --company-id "$company_id" --json)"
if [[ $# -gt 0 ]]; then
  names="$(printf '%s\n' "$@" | jq -R . | jq -s .)"
  agents="$(jq --argjson names "$names" '[.[] | select(.name as $n | $names | index($n))]' <<<"$agents")"
  found="$(jq length <<<"$agents")"
  [[ "$found" -eq $# ]] || die "found $found of $# agents; names are case-sensitive: $(paperclipai agent list --company-id "$company_id" --json | jq -r '[.[].name] | join(", ")')"
fi

jq -r '.[].id' <<<"$agents" | while read -r agent_id; do
  agent="$(paperclipai agent get "$agent_id" --json)"
  name="$(jq -r .name <<<"$agent")"

  # Keep the agent's model and managed instructions; replace everything else.
  payload="$(jq -c '{
    adapterType: "claude_local",
    adapterConfig: ({
      engine: "cli",
      command: "claude",
      model: (.adapterConfig.model // "claude-opus-5-5"),
      graceSec: (.adapterConfig.graceSec // 15),
      timeoutSec: (.adapterConfig.timeoutSec // 0),
      dangerouslySkipPermissions: true
    } + (.adapterConfig | with_entries(select(.key | startswith("instructions")))))
  }' <<<"$agent")"

  if [[ "$(jq -r '.adapterType + "/" + (.adapterConfig.engine // "")' <<<"$agent")" == "claude_local/cli" ]]; then
    log "$name: already on claude_local (cli)"
    continue
  fi

  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[dry-run] %s: %s\n' "$name" "$payload"
    continue
  fi

  log "$name: switching to claude_local (cli)"
  paperclipai agent update "$agent_id" --json --payload-json "$payload" | jq -r '"    now " + .adapterType + " (" + .adapterConfig.engine + ")"'
done
