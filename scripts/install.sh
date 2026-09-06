#!/usr/bin/env bash
# Install this repo as ~/.config/nvim (portable bootstrap).
# Usage: ./scripts/install.sh
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/KOUSTAV2409/lazyvim-config.git}"
TARGET="${TARGET:-$HOME/.config/nvim}"

if [[ -e "$TARGET" || -L "$TARGET" ]]; then
  bak="$TARGET.bak.$(date +%Y%m%d%H%M%S)"
  echo "Backing up $TARGET -> $bak"
  mv "$TARGET" "$bak"
fi

git clone "$REPO_URL" "$TARGET"

if [[ -e "$HOME/.local/state/omarchy/current/theme/neovim.lua" ]]; then
  ln -sfn "$HOME/.local/state/omarchy/current/theme/neovim.lua" \
    "$TARGET/lua/plugins/theme.lua"
  echo "Omarchy theme symlink created."
elif [[ ! -e "$TARGET/lua/plugins/theme.lua" ]]; then
  cp "$TARGET/lua/plugins/theme.lua.example" "$TARGET/lua/plugins/theme.lua"
  echo "Installed theme.lua.example as theme.lua (non-Omarchy)."
fi

echo
echo "Done. Launch: nvim"
echo "Docs: $TARGET/docs/SETUP.md and $TARGET/docs/LANGUAGES.md"
