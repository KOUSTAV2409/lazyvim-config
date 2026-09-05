# LazyVim — Omarchy + VS Code muscle memory

Personal [LazyVim](https://www.lazyvim.org/) config for [Omarchy](https://omarchy.org/) Linux.
Keeps Neovim light, while mapping familiar VS Code chords where they still help.
Vim motions and `<leader>` (`Space`) are the long-term speed path.

## Highlights

- **VS Code–style keys** for save, tabs, explorer, palette, LSP, multi-cursor
- **Native `/` find** (preferred); **Ctrl+Shift+H** for replace in current file
- **Bottom terminal panel** (`Ctrl+\``) + floating terminal (`Ctrl+Shift+\``)
- **Omarchy theme hot-reload** via `lua/plugins/theme.lua` symlink
- Snacks picker (LazyVim 8 default) — not Telescope

## Install

```bash
# backup any existing config
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

git clone https://github.com/KOUSTAV2409/lazyvim-config.git ~/.config/nvim
nvim
```

On Omarchy, `lua/plugins/theme.lua` should point at the active theme:

```text
~/.config/nvim/lua/plugins/theme.lua
  → ~/.local/state/omarchy/current/theme/neovim.lua
```

If that symlink is missing after clone:

```bash
ln -sfn ~/.local/state/omarchy/current/theme/neovim.lua \
  ~/.config/nvim/lua/plugins/theme.lua
```

## Everyday VS Code–ish keys

| Key | Action |
|-----|--------|
| `Ctrl+P` | Quick Open |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+F` | Find (`/` under the hood) |
| `Ctrl+Shift+F` | Find in project |
| `Ctrl+Shift+H` | Replace in current file |
| `Ctrl+B` | Toggle explorer |
| `Ctrl+\`` | Toggle terminal panel |
| `Ctrl+Shift+\`` | Floating terminal |
| `F12` / `F2` / `Ctrl+.` | Definition / rename / code action |
| `Alt+↑/↓` | Move line |
| `Ctrl+Alt+↑/↓` | Multi-cursor |

## Learn Vim + Space (leader)

Press `Space` and wait — which-key shows every group.

| Space + | Group |
|---------|--------|
| `f` | file / find |
| `s` | search (incl. `sr` project replace) |
| `g` | git / lazygit |
| `b` | buffers |
| `c` | code / LSP |
| `x` | diagnostics |
| `u` | UI toggles |
| `q` | quit / session |

High-ROI motions to practice next:

- `w` `b` `e` — words
- `f`/`t` + char — jump on line
- `ci"` `di(` — change/delete inside
- `.` — repeat last change
- `*` then `n` — word under cursor
- `s` — Flash jump (LazyVim)

**Practice rule:** three new keys a day until automatic.

## Layout

```text
lua/config/keymaps.lua     VS Code–familiar maps + replace
lua/config/options.lua     comfort options
lua/plugins/vscode-ux.lua  mini.move + multicursor
lua/plugins/snacks-*.lua   terminal panel
lua/plugins/theme.lua      Omarchy theme (symlink)
```

## Foot tip

This config pairs with Foot CSI-u pass-through for `Ctrl+\`` and Ctrl+Shift chords.
See `~/.config/foot/foot.ini` on the Omarchy machine (not in this repo).

## License

Apache-2.0 (upstream LazyVim starter).
