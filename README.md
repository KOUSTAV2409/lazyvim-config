# LazyVim — opinionated Omarchy setup

Personal [LazyVim](https://www.lazyvim.org/) config used on [Omarchy](https://omarchy.org/) Linux.

**Site:** [koustav2409.github.io/lazyvim-config](https://koustav2409.github.io/lazyvim-config/)

**I did not create these tools.** This is only my personal collection of opinionated config files — a start. The credit belongs to the open source community (Neovim, LazyVim, plugins, Omarchy, and everyone upstream). See [docs/CREDITS.md](docs/CREDITS.md). After you clone it, **change anything you want.**

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
| [docs/CREDITS.md](docs/CREDITS.md) | Gratitude to open source — this is config, not my invention |
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
docs/                               philosophy, shortcuts, learning, credits
docs/journal/                       personal Vim notes
```

## Credits & gratitude

I did **not** invent Neovim, LazyVim, or the plugins in this repo.

This repository is only my **personal, opinionated collection of config files** — a starting point. The real work belongs to the open source community that builds and maintains the tools underneath.

### Thank you

In particular (non-exhaustive — LazyVim pulls in many more):

| Project | Gratitude for |
|---------|----------------|
| [Neovim](https://neovim.io/) | The editor itself |
| [LazyVim](https://www.lazyvim.org/) / [folke](https://github.com/folke) | The distribution, Snacks, which-key, Flash, and so much of the modern Lua ecosystem |
| [lazy.nvim](https://github.com/folke/lazy.nvim) | Plugin management |
| [Omarchy](https://omarchy.org/) / DHH & contributors | The Linux environment this config grew up in |
| Treesitter, LSP, Mason, and every language server | Intelligence without an Electron IDE |
| mini.nvim, multicursor.nvim, grug-far, Neo-tree, and other plugins used here | Small sharp tools |
| Foot and other terminal projects | Making Ctrl chords reach the editor |
| Vim’s lineage and tutors | Motions that still teach people decades later |

If you maintain something this config depends on: **thank you.** I am standing on your work.

### What this repo is (and is not)

| This is | This is not |
|---------|-------------|
| A personal config dump + learning notes | A new editor or framework |
| An opinionated **start** | A product you must follow |
| Glue and keymaps I like | Credit for inventing the stack |

**Change anything.** Delete maps, swap themes, add plugins, reject my opinions. After you clone it, it is yours.

More detail: [docs/CREDITS.md](docs/CREDITS.md).

## License & credit

Apache-2.0 for this starter layout (upstream LazyVim template).  
Plugins keep their own licenses. I am not the author of those tools — only of these configs and notes.