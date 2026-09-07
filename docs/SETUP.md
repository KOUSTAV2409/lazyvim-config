# Fresh machine setup

Goal: on a new Linux boot or laptop, clone this repo and get the **same** LazyVim “god-tier” setup (JS/TS, Python, Ruby/Rails, C/C++, Lua, HTML/CSS/Tailwind, SQLite, …).

## Requirements

| Tool | Why |
|------|-----|
| Neovim **0.11+** (0.12+ fine) | LazyVim 8 / current LazyVim |
| `git`, `curl`, network | clone + Mason installs |
| A C compiler (optional) | treesitter parsers |
| Language runtimes as needed | `node`/`npm` for JS tools, `python`, `ruby` + `gem install ruby-lsp`, `rustup`, `clang`, `sqlite` CLI for projects — Mason installs **editor tools**, not always the language itself |

`lua/plugins/theme.lua` is **not** in the repo (gitignored). You create it after clone (Omarchy symlink or copy `theme.lua.example`).

### Omarchy (this config’s home)

If you use [Omarchy](https://omarchy.org/), Neovim is usually already current. Theme symlink is required (see below).

### Other distros

Install Neovim from your package manager or [neovim.io](https://neovim.io/). Then clone as below.

## One-shot install

```bash
# 1) Backup anything existing
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
mv ~/.local/share/nvim ~/.local/share/nvim.bak 2>/dev/null   # optional: wipe old plugins

# 2) Clone THIS repo as your Neovim config
git clone https://github.com/KOUSTAV2409/lazyvim-config.git ~/.config/nvim

# 3) Theme (required — not shipped in git)
# Omarchy:
ln -sfn ~/.local/state/omarchy/current/theme/neovim.lua \
  ~/.config/nvim/lua/plugins/theme.lua

# Non-Omarchy: copy the example theme
# cp ~/.config/nvim/lua/plugins/theme.lua.example ~/.config/nvim/lua/plugins/theme.lua

# 4) Launch once (needs network) — Lazy + Mason install everything
nvim
```

Or run `./scripts/install.sh` from a clone (backs up, clones into `~/.config/nvim`, creates theme).

Wait until Lazy finishes. Open `:Mason` and confirm tools are installed (or just open a `.py` / `.rs` / `.html` file and let servers install).

## Recommended workflow (single source of truth)

Keep **one** clone you edit and push:

```bash
# Develop from the Projects copy (or any path you like)
git clone https://github.com/KOUSTAV2409/lazyvim-config.git ~/Projects/lazyvim-config

# Point Neovim at it
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null
ln -s ~/Projects/lazyvim-config ~/.config/nvim

# Omarchy theme (symlink target is machine-local)
ln -sfn ~/.local/state/omarchy/current/theme/neovim.lua \
  ~/Projects/lazyvim-config/lua/plugins/theme.lua
```

Then:

```bash
cd ~/Projects/lazyvim-config
# edit configs…
git add -A && git commit -m "…" && git push
```

On another machine: `git pull` inside the clone (or re-clone) and restart Neovim.

## After install checklist

1. `:Lazy` — plugins green / installed  
2. `:Mason` — language servers / formatters present  
3. Open sample files and smoke-test:

| File | Expect |
|------|--------|
| `foo.html` | Emmet: type `!` then **Tab** → HTML5 boilerplate |
| `foo.js` / `foo.ts` | `if` snippet + Tab; `()` `{}` pair; vtsls diagnostics |
| `foo.py` | pyright + ruff |
| `foo.rb` / `foo.html.erb` | ruby_lsp + ERB tools |
| `foo.c` / `foo.cpp` | clangd |
| `foo.lua` | lua_ls (core) |
| `foo.sql` | dadbod + sqlfluff (sqlite dialect) — `<leader>D` for UI |
| Tailwind classes in HTML | completions + color hints (hipatterns) |

4. Format on demand: **Shift+Alt+F** (autoformat on save is off by design — see `options.lua`)

## Updating on this machine

```bash
cd ~/.config/nvim   # or ~/Projects/lazyvim-config if symlinked
git pull
nvim                 # let Lazy sync; :Lazy sync if needed
```

## Dual-clone warning

Do **not** keep two divergent copies (`~/.config/nvim` and `~/Projects/lazyvim-config`) both with their own `.git` and different commits. Pick **one** SSoT and symlink the other path.

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| Huge diagnostic counts on a tiny/fixed file | Stale LSP cascade — run **`:lsp restart`** (Neovim **0.12+**). On 0.11.x use `:LspRestart`. Or `:bd` and reopen the file. |
| Pyright / vtsls “loading” on every keystroke | Fixed via `lsp-perf.lua` + language tunings. Restart Neovim after pull. Prefer real project roots (`pyproject.toml`, `package.json`, …). |
| Ruby `cannot load such file -- bundler` / ruby_lsp quits | Run `gem install ruby-lsp` (mise/PATH Ruby). Config prefers that binary over Mason’s system-ruby wrapper. For apps, use a `Gemfile`. Then `:lsp restart`. |
| Want full clangd index / tidy | Uncomment flags in `lua/plugins/clangd.lua` |
| `E492: Not an editor command: LspRestart` | You’re on Neovim 0.12+ — use **`:lsp restart`** instead. |
| Ruby `Invalid byte sequence in utf-8` but file looks fine | Buffer has bad bytes; disk may be clean. **`:e!`** to reload, or rewrite/save as UTF-8 (`:set fileencoding=utf-8`). |
| No colorscheme / theme errors | Create `lua/plugins/theme.lua` (symlink or copy example) — it is not in git. |
| Mason still installing / packages aborted | Quit all Neovim instances, reopen once, wait for Mason to finish. |

## Related docs

- [LANGUAGES.md](LANGUAGES.md) — what each language gets (extras, LSPs, keys)
- [SHORTCUTS.md](SHORTCUTS.md) — keymaps
- [PHILOSOPHY.md](PHILOSOPHY.md) — why VS Code chords stay
- [CREDITS.md](CREDITS.md) — upstream credit
