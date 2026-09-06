# Languages & stacks (out of the box)

This config targets a **generalist** setup: web, scripting, systems, and databases — without opening a project-specific IDE.

Sources of support:

1. **LazyVim extras** — `lazyvim.json`  
2. **Custom plugins** — `lua/plugins/web.lua`, `javascript.lua`, `languages.lua`  
3. **Core LazyVim** — Lua, treesitter, Mason, blink.cmp, conform, etc.

Autoformat **on save is off** (`vim.g.autoformat = false`). Format with **Shift+Alt+F** (or LazyVim’s format keymap).

---

## Quick matrix

| You write | Extra / module | LSP / intelligence | Format / lint | Notes |
|-----------|----------------|--------------------|---------------|-------|
| **JavaScript / TypeScript** | `lang.typescript` + `javascript.lua` | **vtsls** | Prettier + ESLint | Snippets (`if`→Tab), brace Enter-indent, pairs |
| **HTML** | `web.lua` (no LazyVim html extra) | **html-lsp**, Emmet | Prettier | `!` then Tab → HTML5; **Alt+W** wrap |
| **CSS / SCSS** | `web.lua` + prettier | **cssls** (+ html embedded) | Prettier | Emmet filtered inside HTML `<style>` junk tags |
| **JS/CSS inside HTML** | `web.lua` (**otter.nvim**) | otter → vtsls / css | — | `:OtterActivate` if needed |
| **Tailwind** | `lang.tailwind` + `mini-hipatterns` | tailwindcss LS | — | Class completions + color hints |
| **JSON** | `lang.json` | jsonls + SchemaStore | Prettier | |
| **YAML / TOML** | `lang.yaml` / `lang.toml` | yamlls / taplo | — | |
| **Markdown** | `lang.markdown` | marksman | markdownlint tools | |
| **Python** | `lang.python` | **pyright** + **ruff** | Ruff | `<leader>cv` venv picker; DAP via `dap.core` |
| **Ruby / Rails / ERB** | `lang.ruby` | **ruby_lsp** | rubocop + erb-formatter/lint | Root: `Gemfile`; views: `eruby` |
| **C / C++** | `lang.clangd` (+ `lang.cmake`) | **clangd** | clang-format via clangd ecosystem | `<leader>ch` source/header; DAP **codelldb** |
| **Rust** | `lang.rust` | rust-analyzer (system PATH) | rustfmt via RA | Install `rustup` on the machine |
| **Lua** | **core** (+ `dap.nlua`) | **lua_ls** | **stylua** | No extra required |
| **SQL / SQLite** | `lang.sql` + `languages.lua` | dadbod + completion | **sqlfluff** dialect **sqlite** | `<leader>D` dadbod UI |
| **Docker** | `lang.docker` | dockerls + compose LS | hadolint | |
| **Shell / Hypr / dotfiles** | `util.dot` | bashls | shellcheck + shfmt | Omarchy-friendly |
| **HTTP APIs** | `util.rest` | kulala | — | Rest client buffers |

Debugging / tests unlocked by: `dap.core`, `dap.nlua`, `test.core`.

---

## Web stack (custom — important)

LazyVim has **no** `lang.html` / `lang.css` extra. This repo’s `lua/plugins/web.lua` is the HTML/CSS/Emmet/otter layer and applies **globally** (every project).

| Action | How |
|--------|-----|
| HTML5 boilerplate | In `.html`, type `!` then **Tab** (or accept Emmet menu) |
| Emmet abbreviation | e.g. `div>ul>li*3` then **Tab** (markup only) |
| Wrap with tag | **Alt+W** |
| Emmet expand (legacy) | **Ctrl+E** |
| JS IntelliSense in `<script>` | otter.nvim (auto); `:OtterActivate` to force |
| CSS in `<style>` | html/cssls/otter — Emmet HTML tags filtered out |

`javascript.lua` fixes standalone `.js`/`.ts` (snippets + Enter between `{}`).

---

## Python

- Extra: `lazyvim.plugins.extras.lang.python`  
- LSP: pyright (types) + ruff (lint/format)  
- Debug: open a file, use LazyVim DAP keys once `dap.core` is installed  
- Tests: neotest when `test.core` is enabled  

Optional project markers: `pyproject.toml`, `requirements.txt`, …

---

## Ruby & Rails

- Extra: `lang.ruby` (there is **no** separate Rails extra)  
- `ruby_lsp` understands Rails apps with a `Gemfile`  
- ERB: `erb-formatter`, `erb-lint` via Mason  
- Pair with `lang.sql`, `lang.tailwind`, prettier for full-stack Rails apps  

---

## C / C++

- Extra: `lang.clangd`  
- Best results with `compile_commands.json` (CMake: `lang.cmake` helps)  
- Debug: codelldb  

---

## Lua

Core LazyVim: `lua_ls` + `stylua`. For debugging Neovim Lua: `dap.nlua`.

---

## SQLite / SQL

- Extra: `lang.sql` → vim-dadbod + UI + completion  
- Open UI: **`<leader>D`**  
- Configure DBs (example in a project `.lazy.lua` or your own plugin):

```lua
vim.g.dbs = {
  dev = "sqlite:" .. vim.fn.expand("~/myapp/db.sqlite3"),
}
```

- sqlfluff dialect forced to **sqlite** in `languages.lua` (override per-project if you need postgres/mysql)

---

## Mason tools (ensured)

See `lua/plugins/languages.lua` and `lua/plugins/web.lua` `ensure_installed` lists. First launch may take several minutes.

Rust-analyzer is **not** Mason-first — install via `rustup component add rust-analyzer`.

---

## Adding another language later

1. Browse LazyVim extras: https://www.lazyvim.org/extras  
2. Enable with `:LazyExtras` **or** add the import string to `lazyvim.json`  
3. `git commit` + `git push` so other machines `git pull` the same extras  
4. Avoid duplicate conflicting formatters (e.g. don’t enable Black alongside Ruff)

---

## Explicitly not enabled (on purpose)

| Extra | Why skipped by default |
|-------|-------------------------|
| `lang.typescript.biome` / `oxc` | Conflicts with prettier/eslint toolchain |
| `formatting.black` | Ruff already formats Python |
| `lang.vue` / `svelte` / `astro` / `angular` | Enable when you actually use them |
| `lang.go` / Java / etc. | Add on demand to keep Mason lean |

---

## Sanity: “works in every folder”

| Concern | How this config handles it |
|---------|----------------------------|
| No `package.json` | vtsls `single_file_support`; otter DOM preambles for HTML scripts |
| No `jsconfig.json` | Optional — not required for DOM completions in HTML |
| HTML `<script>` vs `.js` file | Filters only apply inside HTML; `.js` gets full snippets |
| Dual git clones out of sync | Use one SSoT + symlink — see [SETUP.md](SETUP.md) |
