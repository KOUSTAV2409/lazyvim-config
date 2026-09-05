# Philosophy — why this config exists

## Who this is for

This config is for people who are **already comfortable in normal text and code editors**.

From childhood (or from years of Notepad, Word, browsers, VS Code, Cursor…), most of us built the same intuition:

- `Ctrl+C` copy  
- `Ctrl+V` paste  
- `Ctrl+X` cut  
- `Ctrl+Z` undo  
- `Ctrl+S` save  
- `Ctrl+F` find  
- `Ctrl+A` select all  
- tabs, explorer, arrows + Shift to select, and the rest of that family  

That muscle memory is not “wrong.” It is how almost every mainstream editor on Earth works.

## The question that started this

When you open brand‑new Vim / Neovim, the default story is often:

> Forget all of that. Learn a completely new language of keys from zero.

**Why should we have to?**

If the goal is a lighter, faster tool — not a personality transplant — then Neovim should **respect the intuition you already have**, and invite Vim power as an *upgrade*, not as a gate.

That thinking is why this LazyVim config exists.

## What I actually wanted

1. **Keep the universal shortcuts** — so day one feels like an editor, not a puzzle  
2. **Stay lightweight** — Neovim / LazyVim instead of a heavy Electron IDE eating RAM  
3. **Optionally go deeper** — `hjkl`, `/`, `dd`, visual + `y`/`d`/`c`, and `Space` (leader) when *you* are ready  

So this is not “VS Code clones Neovim.”  
It is: **your lifelong editor intuition first; Vim speed second; low RAM always.**

## What I discovered after living in it

The universal Ctrl keys get you productive immediately.  
Some Vim habits then become *better* than the old ways for specific jobs:

| Habit | Why it can win later |
|-------|----------------------|
| `hjkl` | Navigate without leaving home row |
| `u` | Undo is one key — still fine beside `Ctrl+Z` |
| `vw` / `vig` then `y`/`d`/`c` | Select, then act — one language |
| `dd` | Delete a line instantly |
| `/` then `n`/`N` | Find without a heavy widget (for me) |

You do **not** need to throw away `Ctrl+C` / `Ctrl+V` to earn those.  
Both layers live here on purpose.

## Design rules

1. **Universal Ctrl keys = first-class** — copy, paste, cut, undo, save, tabs, explorer, palette, terminal, LSP labels you already know.  
2. **Vim / leader = growth path** — documented in [LEARNING.md](LEARNING.md), not forced as a wall.  
3. **`/` = preferred find** — `Ctrl+F` simply starts `/` so the old reflex still works.  
4. **Replace is explicit** — `Ctrl+Shift+H` for this file; `Space` `s` `r` for the project.  
5. **Leader (`Space`) = LazyVim power menu** — press Space and wait; which-key teaches you.  
6. **No agent-sidebar requirement** — this repo is the editor.  
7. **Omarchy-friendly** — theme symlink when on Omarchy; optional elsewhere.

## What “same config” means for clones

If you clone this into `~/.config/nvim` and run `nvim`, you should get:

- The familiar Ctrl shortcuts listed in [SHORTCUTS.md](SHORTCUTS.md)  
- LazyVim’s `Space` leader groups  
- The same learning path in [LEARNING.md](LEARNING.md)  

You will **not** automatically get my whole desktop (Foot pass-through, Hyprland, themes) — that is the private `dotfiles` repo. See [TERMINAL.md](TERMINAL.md) for chord caveats.

## Tone of the learning docs

[journal/](journal/) = my raw notes while learning Vim (personal voice).  
[LEARNING.md](LEARNING.md) = the cleaned path I recommend.

**Bottom line:** if classic editor intuition is already in your hands, this config refuses the idea that you must erase it to use Neovim.
