# Philosophy — why this config exists

This setup is **opinionated**. It is not trying to recreate Cursor or VS Code inside Neovim. It is trying to keep what was good about those editors without their cost.

## The problem

VS Code and Cursor feel great: familiar keys, nice UI, agents. On a machine that is not swimming in RAM, they are heavy. I wanted:

1. **Lightweight** — Neovim / LazyVim instead of an Electron IDE  
2. **Familiar enough** — some Ctrl+ shortcuts so I am not blocked on day one  
3. **Actually faster long-term** — Vim motions and LazyVim’s `Space` leader  

## What I believe after using this

These Vim habits beat most of the VS Code chrome for me:

| Habit | Why it wins |
|-------|-------------|
| `hjkl` | Navigation without leaving home row |
| `u` / `Ctrl-R` | Undo / redo without chord gymnastics |
| `vw`, `vig`, visual + `y`/`d`/`c` | Select then act — one language |
| `dd` | Delete line instantly in normal mode |
| `/` then `n`/`N` | Find is faster than a find widget for me |

So this config **keeps** a VS Code layer for comfort, but **documents and encourages** the Vim path as the real power.

## Design rules

1. **Ctrl keys = comfort / migration** — save, tabs, explorer, palette, terminal, LSP labels you already know.  
2. **`/` = find** — Ctrl+F only jumps into `/`. I do not want a heavy find UI as the default.  
3. **Replace is separate** — Ctrl+Shift+H opens replace-in-file (grug-far). Project replace is `Space` `s` `r`.  
4. **Leader (`Space`) = LazyVim power menu** — learn this; which-key teaches you.  
5. **No agent sidebar goal** — AI tools can live elsewhere. This repo is the editor.  
6. **Omarchy-friendly** — theme symlink / hot-reload when on Omarchy; optional elsewhere.

## What “same config” means for clones

If you clone this repo into `~/.config/nvim` and run `nvim`, you should get:

- The same custom keymaps and plugins listed in [SHORTCUTS.md](SHORTCUTS.md)  
- LazyVim’s leader groups and defaults  
- The same learning path in [LEARNING.md](LEARNING.md)  

You will **not** automatically get:

- My Foot terminal key pass-through (see [TERMINAL.md](TERMINAL.md))  
- Omarchy desktop / Hyprland (see the private `dotfiles` repo)  
- Every language server until Mason/Lazy extras install for your languages  

## Tone of the learning docs

[journal/](journal/) holds **my** notes while learning — informal, incomplete, personal.  
[LEARNING.md](LEARNING.md) is the cleaned path I recommend others follow with this config.

Use both. The journal is the opinion. The learning guide is the curriculum.
