#!/usr/bin/env bash
# Gives agents in an existing Paperclip company the repo's skills, by agent name.
#
# Imports this repo's skills into the company from GitHub (so Paperclip can
# offer updates when main changes), then adds each agent's skills from
# agent-skills.json. Skills are added, never removed, so Paperclip's built-in
# skills and anything assigned in the UI stay. Agents not in this company are
# skipped.
#
# Usage: agent-skills.sh <company-id>
set -euo pipefail

FACTORY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MAPPING="${MAPPING:-$FACTORY_DIR/agent-skills.json}"
SKILLS_SOURCE="${SKILLS_SOURCE:-https://github.com/nathancoleman/agentic-nate}"
DRY_RUN="${DRY_RUN:-0}"

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

company_id="${1:-}"
[[ -n "$company_id" ]] || die "usage: $0 <company-id>"
command -v paperclipai >/dev/null 2>&1 || die "paperclipai is not on PATH; run make deps first"
jq -e 'type == "object"' "$MAPPING" >/dev/null || die "$MAPPING must be a JSON object of agent name to skill names"

if [[ "$DRY_RUN" == "1" ]]; then
  printf '[dry-run] import skills from %s\n' "$SKILLS_SOURCE"
else
  log "importing skills from $SKILLS_SOURCE"
  paperclipai skill import -C "$company_id" --json --payload-json "$(jq -nc --arg s "$SKILLS_SOURCE" '{source: $s}')" \
    | jq -r '"    " + ((.imported // []) | length | tostring) + " skills imported" + (if (.warnings // []) | length > 0 then ", warnings: " + ((.warnings) | map(tostring) | join("; ")) else "" end)'
fi

# The skills the mapping needs must exist in the company before agents can use them.
available="$(paperclipai skill list --company-id "$company_id" --json | jq -c '[.[].name]')"
missing="$(jq -r --argjson have "$available" '[.[][]] | unique | map(select(. as $s | $have | index($s) | not)) | join(", ")' "$MAPPING")"
if [[ -n "$missing" && "$DRY_RUN" != "1" ]]; then
  die "not in the company's skill library: $missing"
fi

agents="$(paperclipai agent list --company-id "$company_id" --json)"
jq -r 'keys[]' "$MAPPING" | while read -r name; do
  agent_id="$(jq -r --arg n "$name" 'map(select(.name == $n)) | first | .id // empty' <<<"$agents")"
  if [[ -z "$agent_id" ]]; then
    log "$name: no agent with this name, skipping"
    continue
  fi

  skills="$(jq -r --arg n "$name" '.[$n] | join(",")' "$MAPPING")"
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[dry-run] %s: add %s\n' "$name" "$skills"
    continue
  fi

  log "$name: adding $skills"
  paperclipai agent skills:sync "$agent_id" --mode add --desired-skills "$skills" --json \
    | jq -r '"    now " + ((.desiredSkills | length) | tostring) + " skills"'
done
