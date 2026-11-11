#!/usr/bin/env bash
# Runs Paperclip as a macOS login service (launchd) whose PATH includes Homebrew.
#
# launchd starts services with a bare PATH (/usr/bin:/bin:/usr/sbin:/sbin), so a
# Paperclip server started by `paperclipai service install` can't find claude or
# gh. claude_local agents inherit the server's PATH, and Paperclip's adapter
# checks look up `claude` on it, so both fail. This script installs the service,
# then points it at a small launcher that sets PATH before starting Paperclip.
#
# `paperclipai service install` and `paperclipai service restart` rewrite the
# launchd plist and drop the launcher. Re-run `make service` after either, and
# restart with `make restart` instead.
set -euo pipefail

PAPERCLIP_HOME="${PAPERCLIP_HOME:-$HOME/.paperclip}"
INSTANCE="${PAPERCLIP_INSTANCE:-default}"
LABEL="ing.paperclip.paperclipai"
PLIST="$HOME/Library/LaunchAgents/$LABEL.plist"
LAUNCHER="$PAPERCLIP_HOME/bin/paperclip-service"
DOMAIN="gui/$(id -u)"

log() { printf '==> %s\n' "$*"; }
die() { printf 'error: %s\n' "$*" >&2; exit 1; }

[[ "$(uname -s)" == "Darwin" ]] || die "the login service setup only supports macOS (launchd)"
command -v paperclipai >/dev/null 2>&1 || die "paperclipai is not on PATH; run make deps first"
command -v brew >/dev/null 2>&1 || die "brew is not on PATH; run make deps first"

wait_healthy() {
  for _ in $(seq 1 60); do
    if paperclipai service status --instance "$INSTANCE" --json 2>/dev/null | jq -e '.health.ok == true' >/dev/null; then
      return 0
    fi
    sleep 2
  done
  return 1
}

restart() {
  log "restarting $LABEL"
  launchctl kickstart -k "$DOMAIN/$LABEL"
  wait_healthy || die "Paperclip did not become healthy; see $PAPERCLIP_HOME/instances/$INSTANCE/logs/service.err.log"
  log "Paperclip is running"
}

if [[ "${1:-}" == "restart" ]]; then
  restart
  exit 0
fi

brew_prefix="$(brew --prefix)"
service_path="$brew_prefix/bin:$brew_prefix/sbin:$HOME/.local/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"

log "writing launcher $LAUNCHER"
mkdir -p "$(dirname "$LAUNCHER")"
cat >"$LAUNCHER" <<EOF
#!/bin/sh
# Written by agentic-nate factory/scripts/service.sh; launchd runs this at login.
# Sets a PATH with Homebrew tools (claude, gh) before starting Paperclip.
export PATH="$service_path"
exec "\$HOME/.local/bin/paperclipai" run --instance $INSTANCE
EOF
chmod 755 "$LAUNCHER"

if [[ ! -f "$PLIST" ]]; then
  log "registering the Paperclip login service"
  paperclipai service install --instance "$INSTANCE" --no-start-now
fi

log "pointing $LABEL at the launcher"
/usr/libexec/PlistBuddy \
  -c "Delete :ProgramArguments" \
  -c "Add :ProgramArguments array" \
  -c "Add :ProgramArguments:0 string $LAUNCHER" \
  "$PLIST"

# bootout returns before the old job finishes unloading (the plist allows a
# 300s exit timeout), and bootstrap fails with "5: Input/output error" until it
# has, so wait for the unload and retry.
launchctl bootout "$DOMAIN/$LABEL" 2>/dev/null || true
for _ in $(seq 1 60); do
  launchctl print "$DOMAIN/$LABEL" >/dev/null 2>&1 || break
  sleep 1
done
for attempt in $(seq 1 10); do
  launchctl bootstrap "$DOMAIN" "$PLIST" 2>/dev/null && break
  [[ "$attempt" -lt 10 ]] || die "launchctl bootstrap $PLIST failed"
  sleep 2
done
wait_healthy || die "Paperclip did not become healthy; see $PAPERCLIP_HOME/instances/$INSTANCE/logs/service.err.log"
log "Paperclip starts at login and is running"
