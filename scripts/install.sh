#!/usr/bin/env bash
# Install this repo as ~/.config/nvim (portable bootstrap).
# Usage: ./scripts/install.sh
set -euo pipefail

REPO_URL="${REPO_URL:-https://github.com/KOUSTAV2409/lazyvim-config.git}"
TARGET="${TARGET:-$HOME/.config/nvim}"
OMARCHY_THEME="$HOME/.local/state/omarchy/current/theme/neovim.lua"

if [[ -e "$TARGET" || -L "$TARGET" ]]; then
  bak="$TARGET.bak.$(date +%Y%m%d%H%M%S)"
  echo "Backing up $TARGET -> $bak"
  mv "$TARGET" "$bak"
fi

git clone "$REPO_URL" "$TARGET"

# theme.lua is gitignored — always create it locally after clone
rm -f "$TARGET/lua/plugins/theme.lua"
if [[ -e "$OMARCHY_THEME" ]]; then
  ln -sfn "$OMARCHY_THEME" "$TARGET/lua/plugins/theme.lua"
  echo "Omarchy theme symlink created."
else
  cp "$TARGET/lua/plugins/theme.lua.example" "$TARGET/lua/plugins/theme.lua"
  echo "Installed theme.lua.example as theme.lua (non-Omarchy)."
fi

echo
echo "Done. Launch: nvim"
echo "Docs: $TARGET/docs/SETUP.md and $TARGET/docs/LANGUAGES.md"
echo "Nvim 0.12+: use :lsp restart  (not :LspRestart)"
