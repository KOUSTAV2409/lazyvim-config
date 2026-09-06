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
| [docs/SETUP.md](docs/SETUP.md) | **New machine / boot** — clone, theme, Mason, SSoT symlink |
| [docs/LANGUAGES.md](docs/LANGUAGES.md) | **Out-of-the-box languages** — JS/TS, Python, Ruby/Rails, C/C++, Lua, HTML/CSS/Tailwind, SQLite, … |
| [docs/PHILOSOPHY.md](docs/PHILOSOPHY.md) | Why this setup exists (opinionated) |
| [docs/SHORTCUTS.md](docs/SHORTCUTS.md) | Full shortcut reference (VS Code layer + Emmet + Vim) |
| [docs/LEARNING.md](docs/LEARNING.md) | How to learn this config — practice path |
| [docs/TERMINAL.md](docs/TERMINAL.md) | Foot / terminal notes (Ctrl+Shift chords) |
| [docs/CREDITS.md](docs/CREDITS.md) | Gratitude to open source — this is config, not my invention |
| [docs/journal/](docs/journal/) | My raw learning notes while picking up Vim |

Full machine backup (Hyprland, Foot, Omarchy themes, …):  
https://github.com/KOUSTAV2409/dotfiles *(private)*

## Install (portable)

Requires Neovim **0.11+** (LazyVim extras schema 8).

```bash
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
git clone https://github.com/KOUSTAV2409/lazyvim-config.git ~/.config/nvim

# Omarchy theme symlink (required on Omarchy)
ln -sfn ~/.local/state/omarchy/current/theme/neovim.lua \
  ~/.config/nvim/lua/plugins/theme.lua

# Other distros: cp ~/.config/nvim/lua/plugins/theme.lua.example \
#                  ~/.config/nvim/lua/plugins/theme.lua

nvim   # first launch: Lazy + Mason (needs network)
```

**Detailed steps, symlink-as-SSoT, and smoke tests:** [docs/SETUP.md](docs/SETUP.md).

### Theme (any other system)

Use `lua/plugins/theme.lua.example` (tokyonight) or any LazyVim colorscheme. Shortcuts do **not** depend on Omarchy — only theme hot-reload does.

## What you get immediately

### Editor UX
- VS Code–familiar keys: save, tabs, explorer, quick open, palette, LSP, multi-cursor, terminal panel  
- Prefer **`/`** for find (Ctrl+F just starts `/`)  
- **Ctrl+Shift+H** → replace in current file  
- LazyVim defaults still work: press **`Space`** and wait for which-key  
- Format **on demand** (Shift+Alt+F) — not on every save  

### Languages (god-tier generalist)

| Stack | Ready via |
|-------|-----------|
| JS / TS | `lang.typescript` (vtsls) + `javascript.lua` |
| HTML / CSS / Emmet / JS-in-HTML | `web.lua` (html-lsp, cssls, emmet, otter) |
| Tailwind | `lang.tailwind` + hipatterns |
| Python | `lang.python` (pyright + ruff) |
| Ruby / Rails / ERB | `lang.ruby` |
| C / C++ (+ CMake) | `lang.clangd` + `lang.cmake` |
| Rust | `lang.rust` (needs `rustup` on the OS) |
| Lua | core LazyVim (`lua_ls` + stylua) |
| SQL / SQLite | `lang.sql` + sqlite dialect in `languages.lua` |
| Docker / YAML / TOML / Markdown / JSON | matching `lang.*` extras |
| DAP + tests + shell/dotfiles + HTTP client | `dap.*`, `test.core`, `util.dot`, `util.rest` |

Full matrix and keys: [docs/LANGUAGES.md](docs/LANGUAGES.md).

## Layout

```text
lazyvim.json                        LazyVim extras (languages + DX)
lazy-lock.json                      Pinned plugin commits
lua/config/keymaps.lua              VS Code–familiar maps + replace
lua/config/options.lua              comfort options (no format-on-save)
lua/plugins/web.lua                 HTML/CSS/Emmet/otter (global)
lua/plugins/javascript.lua          standalone JS/TS DX
lua/plugins/languages.lua           treesitter + mason + sqlfluff sqlite
lua/plugins/vscode-ux.lua           mini.move + multicursor + sticky scroll
lua/plugins/snacks-*.lua            bottom / floating terminal
lua/plugins/theme.lua               colorscheme (Omarchy symlink)
lua/plugins/theme.lua.example       non-Omarchy starter theme
lua/plugins/omarchy-theme-hotreload.lua
docs/SETUP.md                       new machine bootstrap
docs/LANGUAGES.md                   language matrix
docs/                               philosophy, shortcuts, learning, credits
docs/journal/                       personal Vim notes
site/                               GitHub Pages landing
```

## Keeping machines in sync

1. Edit **one** clone (recommended: `~/Projects/lazyvim-config` with `~/.config/nvim` → symlink).  
2. `git commit` && `git push`.  
3. On the other machine: `git pull` && restart `nvim`.  

Do not maintain two divergent clones. See [docs/SETUP.md](docs/SETUP.md).

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
| otter.nvim, emmet-vim, mini.nvim, multicursor.nvim, grug-far, Neo-tree | Web DX and sharp tools |
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
