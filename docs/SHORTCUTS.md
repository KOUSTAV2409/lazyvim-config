# Shortcuts reference

These Ctrl shortcuts exist so people with **normal editor intuition** (`Ctrl+C` / `Ctrl+V` / …) can use Neovim without throwing away what they already know. Vim and `Space` are extras — see [PHILOSOPHY.md](PHILOSOPHY.md).

Legend: **N** normal · **I** insert · **V** visual · **T** terminal

This config adds that familiar layer on top of LazyVim. LazyVim’s own keys (especially `Space` …) still work.

---

## Clipboard & editing (VS Code layer)

| Key | Modes | Action |
|-----|-------|--------|
| `Ctrl+C` | V | Copy |
| `Ctrl+V` | N/V/I/T | Paste (system clipboard) |
| `Ctrl+X` | V | Cut |
| `Ctrl+A` | N/I/V | Select all |
| `Ctrl+Z` | N/I/V | Undo |
| `Ctrl+Y` | N/I/V | Redo |
| `Ctrl+S` | N/I/V | Save |
| `Ctrl+Shift+S` | N/I/V | Save all |
| `Ctrl+D` / `Ctrl+Shift+D` | N/I | Duplicate line |
| `Ctrl+Shift+K` | N/I/V | Delete line / selection |
| `Ctrl+/` | N/I/V | Toggle comment |
| `Ctrl+]` | N/I/V | Indent |
| `Tab` / `Shift+Tab` | V | Indent / outdent selection |
| `Alt+↑` / `Alt+↓` | N/I/V | Move line / selection |
| `Ctrl+Alt+↑` / `Ctrl+Alt+↓` | N/V | Add multi-cursor above / below |
| `Ctrl+Shift+L` | N/V | Add cursor on next match |
| `Space` `m` `c` | N | Clear multi-cursors |

---

## Files, tabs, search

| Key | Modes | Action |
|-----|-------|--------|
| `Ctrl+P` | N/I/V | Quick Open (files) |
| `Ctrl+Shift+P` | N/I/V | Command palette |
| `Ctrl+F` | N/I | Find in file → starts `/` |
| `Ctrl+Shift+F` | N/I | Find in project (Snacks grep) |
| `Ctrl+Shift+H` | N | Replace in **current file** (grug-far) |
| `Ctrl+Shift+H` | V | Replace using visual selection in file |
| `Space` `s` `r` | N/V | Search & replace (project / filtered) |
| `Ctrl+B` | N/I/V/T (+ inside explorer) | Toggle file explorer (always) |
| `Ctrl+Shift+E` | N/I/V | Focus explorer |
| `Ctrl+W` | N/I/V | Close tab (buffer) safely |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | N/I/V | Next / previous tab |
| `Ctrl+PageDown` / `Ctrl+PageUp` | N/I/V | Next / previous tab |
| `Shift+H` / `Shift+L` | N | Prev / next buffer (LazyVim) |

---

## Selection (arrow-style)

| Key | Modes | Action |
|-----|-------|--------|
| `Shift+arrows` | N/V | Start / extend selection |
| `Ctrl+Shift+Left/Right` | N/V | Select by word |
| `Ctrl+Left/Right` | I | Move by word in insert |

Prefer learning Vim selection too: `v` / `V` / `vw` / `vig` then `y` `d` `c`.

---

## LSP / code

| Key | Modes | Action |
|-----|-------|--------|
| `F12` | N | Go to definition |
| `Shift+F12` | N | References |
| `F2` | N | Rename |
| `Ctrl+.` | N/I | Code action / quick fix |
| `Ctrl+Shift+O` | N/I/V | Symbols in file |
| `Ctrl+T` | N/I/V | Symbols in workspace |
| `Ctrl+G` | N/I | Go to line |
| `Shift+Alt+F` | N/I/V | Format document |
| `gd` | N | Go to definition (LazyVim / LSP) |
| `Space` `c` `a` | N | Code action |
| `Space` `c` `r` | N | Rename |
| `Space` `c` `f` | N | Format |

---

## Terminal

| Key | Modes | Action |
|-----|-------|--------|
| `Ctrl+\`` | N/I/T | Toggle bottom terminal (~32% height) |
| `Ctrl+Shift+\`` | N/I/T | Toggle floating terminal |
| `Ctrl+/` | T | Hide terminal (LazyVim also uses this) |
| `Ctrl+V` | T | Paste into terminal |
| `Ctrl+H` | T | Focus editor above |
| `Space` `f` `t` | N | Terminal (LazyVim) |

See [TERMINAL.md](TERMINAL.md) if chords do not reach Neovim.

---

## Find & replace (the opinionated way)

| Want | Do this |
|------|---------|
| Find in file | `/pattern` then `n` / `N` (or Ctrl+F) |
| Replace next match after `/` | `cgn` → type → `Esc` → `.` repeats |
| Replace in this file (UI) | `Ctrl+Shift+H` |
| Replace in project | `Space` `s` `r` |

---

## Leader (`Space`) — learn this

Press `Space` and **wait**. which-key lists groups.

| Prefix | Group |
|--------|--------|
| `Space` `f` | file / find |
| `Space` `s` | search |
| `Space` `g` | git |
| `Space` `b` | buffers |
| `Space` `c` | code |
| `Space` `x` | diagnostics |
| `Space` `u` | UI |
| `Space` `q` | quit / session |
| `Space` `?` | buffer-local keys |

Useful examples:

| Keys | Action |
|------|--------|
| `Space` `f` `f` | Find files |
| `Space` `f` `r` | Recent files |
| `Space` `s` `g` | Grep project |
| `Space` `g` `g` | Lazygit |
| `Space` `b` `d` | Delete buffer |
| `Space` `x` `x` | Diagnostics (Trouble) |

---

## High-value Vim (stock + LazyVim)

| Key | Action |
|-----|--------|
| `hjkl` | Move |
| `w` `b` `e` | Word motions |
| `0` `^` `$` | Line start / first char / end |
| `gg` `G` | File top / bottom |
| `dd` | Delete line |
| `yy` | Yank line |
| `p` / `P` | Paste after / before |
| `i` `a` `I` `A` `o` `O` | Enter insert in different places |
| `v` `V` `Ctrl+V` | Visual / line / block *(note: Ctrl+V is remapped to paste in this config)* |
| `d` `c` `y` + motion | Delete / change / yank |
| `ci"` `di(` `yi{` | Inside quotes / parens / braces |
| `.` | Repeat last change |
| `*` | Search word under cursor |
| `s` | Flash jump (LazyVim) |
| `%` | Match `()` `{}` `[]` |

**Visual block:** use LazyVim/`Ctrl+Q` or learn another mapping if you need block select — this config prioritizes Ctrl+V paste like VS Code.

---

## Splits

| Key | Action |
|-----|--------|
| `Ctrl+\` | Vertical split (this config) |
| `Ctrl+h/j/k/l` | Move between windows (LazyVim) |
| `Space` `w` … | Window helpers (which-key) |
