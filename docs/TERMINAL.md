# Terminal notes (Foot / chords)

Neovim only receives keys the **terminal emulator** does not eat.

This config was tuned on **Omarchy + Foot**. On Foot, `~/.config/foot/foot.ini` passes CSI-u sequences for things like:

- `Ctrl+\`` / `Ctrl+Shift+\``  
- `Ctrl+Tab` / `Ctrl+Shift+Tab`  
- Several `Ctrl+Shift+…` editor chords  

That Foot file lives in the full-machine repo:  
https://github.com/KOUSTAV2409/dotfiles (private) under `.config/foot/`.

## If a shortcut “does nothing”

1. Try the LazyVim / Vim alternative (`Space` … or `/`, `gd`, …).  
2. Check whether your terminal binds the same chord (copy/paste, search, new tab).  
3. On Foot, free conflicting binds (`search-start=none`, etc.) and add `text-bindings` for CSI-u — see the dotfiles `foot.ini`.

## Known terminal pitfalls

| Chord | Issue |
|-------|--------|
| `Ctrl+H` | Often Backspace; window-left in LazyVim normal mode — not used for “replace” |
| `Ctrl+[` | Is Escape — never remap for outdent |
| `Ctrl+/` | May arrive as `Ctrl+_` — this config maps both for comments / terminal hide |

## Integrated terminal (inside Neovim)

Snacks bottom panel (~32% height):

- `Ctrl+\`` toggle  
- `Ctrl+Shift+\`` floating  
- Paste with `Ctrl+V` while in the terminal buffer  
