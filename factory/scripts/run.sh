#!/usr/bin/env bash
# Starts Paperclip and makes sure the factory company is imported, then keeps the
# server in the foreground until Ctrl-C.
set -euo pipefail

FACTORY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPANY_NAME="${COMPANY_NAME:-Nathan Coleman}"
PAPERCLIP_HOME="${PAPERCLIP_HOME:-$HOME/.paperclip}"
INSTANCE="${PAPERCLIP_INSTANCE:-default}"
CONFIG="$PAPERCLIP_HOME/instances/$INSTANCE/config.json"
LOG_FILE="${LOG_FILE:-$PAPERCLIP_HOME/instances/$INSTANCE/logs/factory-run.log}"

log() { printf '==> %s\n' "$*"; }

pc() {
  if command -v paperclipai >/dev/null 2>&1; then
    paperclipai "$@"
  else
    npx -y paperclipai@latest "$@"
  fi
}

if [[ ! -f "$CONFIG" ]]; then
  log "no Paperclip instance found, onboarding"
  pc onboard --yes
fi

port="$(jq -r '.server.port // 3100' "$CONFIG")"
host="$(jq -r '.server.host // "127.0.0.1"' "$CONFIG")"
base_url="http://$host:$port"

server_pid=""
if curl -fsS "$base_url/api/health" >/dev/null 2>&1; then
  log "Paperclip is already running at $base_url"
else
  mkdir -p "$(dirname "$LOG_FILE")"
  log "starting Paperclip (logs: $LOG_FILE)"
  pc run >"$LOG_FILE" 2>&1 &
  server_pid=$!
  trap '[[ -n "$server_pid" ]] && kill "$server_pid" 2>/dev/null; wait "$server_pid" 2>/dev/null' INT TERM EXIT

  for _ in $(seq 1 120); do
    if curl -fsS "$base_url/api/health" >/dev/null 2>&1; then
      break
    fi
    if ! kill -0 "$server_pid" 2>/dev/null; then
      echo "Paperclip exited during startup; last log lines:" >&2
      tail -n 30 "$LOG_FILE" >&2
      exit 1
    fi
    sleep 1
  done
  curl -fsS "$base_url/api/health" >/dev/null 2>&1 || { echo "Paperclip did not become healthy at $base_url" >&2; exit 1; }
fi

company_id="$(pc company list --json --api-base "$base_url" 2>/dev/null \
  | jq -r --arg name "$COMPANY_NAME" '(if type == "array" then . else (.companies // .items // []) end) | map(select(.name == $name)) | first | .id // empty')"

if [[ -z "$company_id" ]]; then
  log "importing the factory as \"$COMPANY_NAME\""
  pc company import "$FACTORY_DIR" --target new --yes --api-base "$base_url"
else
  log "\"$COMPANY_NAME\" already imported ($company_id); run 'make sync COMPANY_ID=$company_id' to apply local changes"
fi

log "factory is running at $base_url"
if [[ -n "$server_pid" ]]; then
  log "press Ctrl-C to stop"
  tail -n 0 -f "$LOG_FILE" &
  tail_pid=$!
  trap 'kill "$tail_pid" 2>/dev/null; kill "$server_pid" 2>/dev/null; wait "$server_pid" 2>/dev/null' INT TERM EXIT
  wait "$server_pid"
fi
