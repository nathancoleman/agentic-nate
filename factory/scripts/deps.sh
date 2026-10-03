#!/usr/bin/env bash
# Installs everything the factory needs that is missing on this machine.
# Uses Homebrew on macOS and Linux. Set DRY_RUN=1 to only report what would change.
set -euo pipefail

NODE_MIN="${NODE_MIN:-24.11.0}"
DRY_RUN="${DRY_RUN:-0}"

log() { printf '==> %s\n' "$*"; }
warn() { printf 'warning: %s\n' "$*" >&2; }

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[dry-run] %s\n' "$*"
    return 0
  fi

  "$@"
}

# version_ge A B succeeds when version A >= version B.
version_ge() {
  [[ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -n1)" == "$2" ]]
}

ensure_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
      if [[ -x "$candidate" ]]; then
        eval "$("$candidate" shellenv)"
        break
      fi
    done
  fi

  if command -v brew >/dev/null 2>&1; then
    log "brew: $(brew --version | head -n1)"
    return
  fi

  log "brew: missing, installing Homebrew"
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[dry-run] install Homebrew from https://brew.sh\n'
    return
  fi

  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x "$candidate" ]]; then
      eval "$("$candidate" shellenv)"
      break
    fi
  done
  command -v brew >/dev/null 2>&1 || { warn "Homebrew install did not put brew on PATH"; exit 1; }
}

# brew_ensure <command> <formula> [brew install args...]
brew_ensure() {
  local cmd="$1" formula="$2"
  shift 2

  if command -v "$cmd" >/dev/null 2>&1; then
    log "$cmd: $(command -v "$cmd")"
    return
  fi

  log "$cmd: missing, installing $formula"
  run brew install "$@" "$formula"
}

ensure_node() {
  local current=""
  if command -v node >/dev/null 2>&1; then
    current="$(node --version | sed 's/^v//')"
  fi

  if [[ -n "$current" ]] && version_ge "$current" "$NODE_MIN"; then
    log "node: v$current"
    return
  fi

  if [[ -z "$current" ]]; then
    log "node: missing, installing node"
    run brew install node
  elif brew list --formula node >/dev/null 2>&1; then
    log "node: v$current is older than $NODE_MIN, upgrading"
    run brew upgrade node
  else
    log "node: v$current is older than $NODE_MIN and not managed by brew, installing brew node"
    run brew install node
  fi

  [[ "$DRY_RUN" == "1" ]] && return
  hash -r
  current="$(node --version | sed 's/^v//')"
  if ! version_ge "$current" "$NODE_MIN"; then
    warn "node on PATH ($(command -v node)) is still v$current; put $(brew --prefix)/bin ahead of it or upgrade it with your version manager"
    exit 1
  fi
}

ensure_terraform() {
  if command -v terraform >/dev/null 2>&1; then
    log "terraform: $(command -v terraform)"
    return
  fi

  log "terraform: missing, installing hashicorp/tap/terraform"
  run brew tap hashicorp/tap
  run brew install hashicorp/tap/terraform
}

ensure_claude() {
  if command -v claude >/dev/null 2>&1; then
    log "claude: $(command -v claude)"
    return
  fi

  log "claude: missing, installing Claude Code"
  if [[ "$(uname -s)" == "Darwin" ]]; then
    run brew install --cask claude-code
  elif [[ "$DRY_RUN" == "1" ]]; then
    printf '[dry-run] install Claude Code from https://claude.ai/install.sh\n'
  else
    curl -fsSL https://claude.ai/install.sh | bash
  fi
}

ensure_paperclip() {
  if command -v paperclipai >/dev/null 2>&1; then
    log "paperclipai: $(command -v paperclipai), checking for updates"
    run paperclipai update || warn "paperclipai update failed; continuing with the installed version"
    return
  fi

  log "paperclipai: missing, installing the managed Paperclip CLI"
  run npx -y paperclipai@latest install --yes
}

check_auth() {
  if [[ "$DRY_RUN" == "1" ]]; then
    return
  fi

  if ! gh auth status >/dev/null 2>&1; then
    warn "gh is not authenticated; run: gh auth login"
  fi
}

ensure_brew
brew_ensure git git
brew_ensure jq jq
brew_ensure gh gh
brew_ensure go go
ensure_terraform
ensure_node
ensure_claude
ensure_paperclip
check_auth

log "done"
if [[ "$DRY_RUN" != "1" ]]; then
  log "open a new shell if paperclipai is not on PATH yet"
fi
