# LazyVim — opinionated Omarchy setup

Personal [LazyVim](https://www.lazyvim.org/) config used on [Omarchy](https://omarchy.org/) Linux.

## Who this is for

People who are **already comfortable** in normal text/code editors — the lifelong intuition of `Ctrl+C` / `Ctrl+V` / `Ctrl+Z` / `Ctrl+S` / `Ctrl+F` and friends.

Brand-new Vim often says: *forget all of that and learn a new language from zero.*  
**Why should we have to?** This config keeps those universal shortcuts first-class, stays **lightweight** (no Electron IDE RAM), and treats real Vim / `Space` (leader) as a **growth path**, not a gate.

Full opinion: [docs/PHILOSOPHY.md](docs/PHILOSOPHY.md).

## Start here

| Doc | What it is |
|-----|------------|
| [docs/PHILOSOPHY.md](docs/PHILOSOPHY.md) | Why this setup exists (opinionated) |
| [docs/SHORTCUTS.md](docs/SHORTCUTS.md) | Full shortcut reference (VS Code layer + important Vim) |
| [docs/LEARNING.md](docs/LEARNING.md) | How to learn this config — practice path |
| [docs/TERMINAL.md](docs/TERMINAL.md) | Foot / terminal notes (Ctrl+Shift chords) |
| [docs/journal/](docs/journal/) | My raw learning notes while picking up Vim |

Full machine backup (Hyprland, Foot, Omarchy themes, …):  
https://github.com/KOUSTAV2409/dotfiles *(private)*

## Install

Requires Neovim **0.11+** (LazyVim 8).

```bash
# backup any existing config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

git clone https://github.com/KOUSTAV2409/lazyvim-config.git ~/.config/nvim
nvim
```

First launch installs plugins (needs network). Wait until Lazy finishes.

### Theme (Omarchy)

On Omarchy, `lua/plugins/theme.lua` is a symlink to the active theme:

```bash
ln -sfn ~/.local/state/omarchy/current/theme/neovim.lua \
  ~/.config/nvim/lua/plugins/theme.lua
```

### Theme (any other system)

Replace the symlink with a normal colorscheme plugin, for example create `lua/plugins/theme.lua`:

```lua
return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "tokyonight",
    },
  },
}
```

Shortcuts and behavior do **not** depend on Omarchy — only the theme hot-reload does.

## What you get immediately

- VS Code–familiar keys: save, tabs, explorer, quick open, palette, LSP, multi-cursor, terminal panel  
- Prefer **`/`** for find (Ctrl+F just starts `/`)  
- **Ctrl+Shift+H** → replace in current file (replace / replace-all UI)  
- LazyVim defaults still work: press **`Space`** and wait for which-key  

Read [docs/SHORTCUTS.md](docs/SHORTCUTS.md) for the full table.  
Read [docs/LEARNING.md](docs/LEARNING.md) to learn Vim the way this config expects.

## Layout

```text
lua/config/keymaps.lua              VS Code–familiar maps + replace
lua/config/options.lua              comfort options
lua/plugins/vscode-ux.lua           mini.move + multicursor
lua/plugins/snacks-*.lua            bottom / floating terminal
lua/plugins/theme.lua               colorscheme (Omarchy symlink)
lua/plugins/omarchy-theme-hotreload.lua
docs/                               philosophy, shortcuts, learning
docs/journal/                       personal Vim notes
```

## License

Apache-2.0 (upstream LazyVim starter template).
