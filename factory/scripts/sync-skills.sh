#!/usr/bin/env bash
# Copies the repo's skills/ into factory/skills so they are part of the package
# Paperclip imports. The copies are gitignored; skills/ stays the single source.
# Package-local skills (tracked in factory/skills, e.g. org-conventions) are left alone.
set -euo pipefail

FACTORY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
REPO_DIR="$(cd "$FACTORY_DIR/.." && pwd)"

mkdir -p "$FACTORY_DIR/skills"

# Drop copies whose repo skill no longer exists. Only gitignored directories are
# copies; anything git tracks or could track is package-local.
for dest in "$FACTORY_DIR"/skills/*/; do
  slug="$(basename "$dest")"
  if git -C "$REPO_DIR" check-ignore -q "factory/skills/$slug" && [[ ! -d "$REPO_DIR/skills/$slug" ]]; then
    rm -rf "$dest"
    echo "removed stale skill: $slug"
  fi
done

for src in "$REPO_DIR"/skills/*/; do
  slug="$(basename "$src")"
  [[ -f "$src/SKILL.md" ]] || continue

  rm -rf "$FACTORY_DIR/skills/$slug"
  cp -R "$src" "$FACTORY_DIR/skills/$slug"
done

echo "copied skills from $REPO_DIR/skills"
