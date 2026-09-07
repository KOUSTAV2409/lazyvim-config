-- VS Code–style web editing for LazyVim (GLOBAL — every project, every .html).
--
-- Markup:  Emmet LS + html-lsp (deduped) + Tab expand + Alt+W wrap
--          ts-autotag rename only in HTML (auto-close off — Emmet already closes)
-- <style>: cssls / html embedded CSS (Emmet HTML junk filtered)
-- <script>: otter → vtsls + DOM libs (Emmet / HTML-tag junk filtered)
--
-- One stack everywhere. No per-project toggle. jsconfig.json is optional.

local HTML_FT = { "html", "htmldjango" }
local HTML_GLOB = { "*.html", "*.htm", "*.html.erb" }

local function is_html_ft(ft)
  ft = ft or vim.bo.filetype
  return ft == "html" or ft == "htmldjango"
end

local function embedded_lang()
  local ok, parser = pcall(vim.treesitter.get_parser, 0)
  if not ok or not parser then
    return nil
  end
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1
  local lang_tree = parser:language_for_range({ row, col, row, col })
  return lang_tree and lang_tree:lang() or nil
end

local function in_style()
  -- Only inside HTML <style>, never whole .css buffers
  if not is_html_ft() then
    return false
  end
  local lang = embedded_lang()
  return lang == "css" or lang == "scss"
end

local function in_script()
  -- Only inside HTML <script>, never whole .js / .ts buffers
  if not is_html_ft() then
    return false
  end
  local lang = embedded_lang()
  return lang == "javascript" or lang == "js" or lang == "typescript"
end

local function in_embedded()
  return in_style() or in_script()
end

local function is_emmet_client(name)
  name = name or ""
  return name == "emmet_language_server"
    or name == "emmet-language-server"
    or name == "emmet_ls"
end

local function is_html_tag_completion(item)
  local label = item.label or ""
  if label:find("~", 1, true) then
    return true
  end
  local text = item.insertText
  if not text and item.textEdit then
    text = item.textEdit.newText or (item.textEdit.insert and item.textEdit.insert.newText)
  end
  text = text or ""
  if text:find("<", 1, true) then
    return true
  end
  local doc = item.documentation
  if type(doc) == "table" and type(doc.value) == "string" and doc.value:find("HTML%s*%-", 1) then
    return true
  end
  if type(doc) == "string" and doc:find("HTML%s*%-", 1) then
    return true
  end
  return false
end

local function is_otter_item(item)
  local name = item.client_name or ""
  return type(name) == "string" and name:find("otter", 1, true) ~= nil
end

-- Buffer directory as LSP root so cwd / which folder you opened nvim from
-- never changes Emmet / otter / vtsls behavior between files.
local function buffer_root(bufnr)
  bufnr = bufnr or 0
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return vim.uv.cwd()
  end
  return vim.fs.root(bufnr, {
    ".git",
    "package.json",
    "jsconfig.json",
    "tsconfig.json",
    "index.html",
  }) or vim.fs.dirname(name)
end

vim.g.lazyvim_eslint_auto_format = false
vim.g.user_emmet_mode = "i"
vim.g.user_emmet_install_global = 0
vim.g.user_emmet_complete_tag = 0
vim.g.user_emmet_expandabbr_key = "<C-e>"
vim.g.user_emmet_leader_key = "<C-y>"

--- VS Code: Enter between paired delimiters opens an indented blank line.
--- - tags:  `<section>|</section>` / `<style>|</style>`
--- - braces: `body {|}` inside `<style>` (or `<script>`)
local function cursor_neighbors()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  return line:sub(col, col), line:sub(col + 1, col + 1)
end

local function is_between_pair()
  local before, after = cursor_neighbors()
  if before == ">" and after == "<" then
    return true
  end
  local pairs = { ["("] = ")", ["["] = "]", ["{"] = "}" }
  return pairs[before] ~= nil and after == pairs[before]
end

local function is_web_indent_ft(ft)
  ft = ft or vim.bo.filetype
  return is_html_ft(ft) or ft == "css" or ft == "scss"
end

local function cr_smart_indent()
  if is_between_pair() then
    return "<CR><Esc>O"
  end
  return "<CR>"
end

return {
  -- Always install web tools (not only when a project happens to have opened them once)
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "html-lsp",
        "css-lsp",
        "emmet-language-server",
        "prettier",
        "eslint-lsp",
        "vtsls",
        "json-lsp",
        "tailwindcss-language-server",
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "css", "scss", "javascript", "html" },
      indent = { enable = true },
    },
  },

  -- VS Code-style Enter between tags / braces for HTML (+ standalone CSS)
  {
    "nvim-mini/mini.pairs",
    optional = true,
    opts = function(_, opts)
      local function setup_cr(bufnr)
        vim.bo[bufnr].expandtab = true
        vim.bo[bufnr].shiftwidth = 2
        vim.bo[bufnr].tabstop = 2
        vim.bo[bufnr].softtabstop = 2
        vim.bo[bufnr].indentexpr = "v:lua.LazyVim.treesitter.indentexpr()"

        vim.keymap.set("i", "<CR>", cr_smart_indent, {
          buffer = bufnr,
          expr = true,
          desc = "Indent between tags/braces",
        })
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = HTML_FT,
        callback = function(ev)
          setup_cr(ev.buf)
        end,
      })

      -- Standalone .css / .scss: Enter between {|} same as inside <style>
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "css", "scss" },
        callback = function(ev)
          setup_cr(ev.buf)
        end,
      })
      return opts
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        html = {
          flags = { debounce_text_changes = 400 },
          filetypes = vim.list_extend(vim.deepcopy(HTML_FT), { "templ" }),
          init_options = {
            provideFormatter = false,
            -- CSS embedded in html-lsp; JS in <script> owned by otter→vtsls (avoid double work)
            embeddedLanguages = { css = true, javascript = false },
            configurationSection = { "html", "css" },
          },
          settings = {
            css = {
              validate = true,
              lint = { validProperties = {} },
              completion = {
                triggerPropertyValueCompletion = true,
                completePropertyWithSemicolon = true,
              },
            },
            html = { suggest = { html5 = true } },
          },
          capabilities = {
            textDocument = {
              completion = { completionItem = { snippetSupport = true } },
            },
          },
        },
        cssls = {
          flags = { debounce_text_changes = 400 },
          init_options = { provideFormatter = false },
          capabilities = {
            textDocument = {
              completion = { completionItem = { snippetSupport = true } },
            },
          },
        },
        -- Works with or without tsconfig/jsconfig (otter .js buffers too)
        vtsls = {
          single_file_support = true,
          flags = { debounce_text_changes = 500 },
        },
        tailwindcss = {
          flags = { debounce_text_changes = 400 },
        },
        -- Emmet for markup + standalone CSS. Filtered out inside <style>/<script>.
        emmet_language_server = {
          flags = { debounce_text_changes = 300 },
          filetypes = {
            "html",
            "htmldjango",
            "javascriptreact",
            "typescriptreact",
            "vue",
            "svelte",
            "astro",
            "css",
            "scss",
          },
          init_options = {
            showAbbreviationSuggestions = true,
            showExpandedAbbreviation = "inMarkupAndStylesheetFilesOnly",
            showSuggestionsAsSnippets = true,
          },
        },
      },
    },
  },

  -- Embedded JS/CSS IntelliSense (VS Code virtual-document approach)
  {
    "jmbuhr/otter.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "neovim/nvim-lspconfig",
    },
    ft = HTML_FT,
    opts = {
      lsp = {
        root_dir = function(_, bufnr)
          return buffer_root(bufnr)
        end,
      },
      buffers = {
        set_filetype = true,
        preambles = {
          -- DOM types for <script> even without a project jsconfig.json
          javascript = {
            '/// <reference lib="dom" />',
            '/// <reference lib="esnext" />',
          },
        },
      },
      handle_leading_whitespace = true,
      verbose = { no_code_found = false },
    },
    config = function(_, opts)
      local otter = require("otter")
      otter.setup(opts)

      -- Activate once per buffer. Re-calling otter.activate rebuilds rafts and
      -- re-attaches vtsls — that felt like constant "loading" on every InsertEnter.
      local activated = {} ---@type table<number, boolean>

      local function activate(bufnr, force)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        if activated[bufnr] and not force then
          return
        end
        if not is_html_ft(vim.bo[bufnr].filetype) then
          return
        end
        if not pcall(vim.treesitter.get_parser, bufnr) then
          return
        end
        -- JS only: html-lsp already covers embedded CSS
        local ok = false
        vim.api.nvim_buf_call(bufnr, function()
          ok = pcall(otter.activate, { "javascript" }, true, true)
        end)
        if ok then
          activated[bufnr] = true
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = HTML_FT,
        callback = function(ev)
          local buf = ev.buf
          vim.defer_fn(function()
            activate(buf)
          end, 200)
          vim.defer_fn(function()
            if not activated[buf] then
              activate(buf)
            end
          end, 1000)
        end,
      })

      vim.api.nvim_create_autocmd("InsertEnter", {
        pattern = HTML_GLOB,
        callback = function(ev)
          if not activated[ev.buf] then
            activate(ev.buf)
          end
        end,
      })

      vim.api.nvim_create_autocmd({ "BufDelete", "BufWipeout" }, {
        callback = function(ev)
          activated[ev.buf] = nil
        end,
      })

      vim.api.nvim_create_user_command("OtterActivate", function()
        activate(0, true)
        vim.notify("Otter activated (JS in HTML)", vim.log.levels.INFO)
      end, { desc = "Activate otter JS IntelliSense for this HTML buffer" })
    end,
  },

  {
    "mattn/emmet-vim",
    -- Load for every HTML buffer (not optional / not project-gated)
    ft = HTML_FT,
    config = function()
      local group = vim.api.nvim_create_augroup("UserEmmetHtml", { clear = true })

      local function install_emmet(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        if not vim.api.nvim_buf_is_valid(bufnr) then
          return
        end
        if not is_html_ft(vim.bo[bufnr].filetype) then
          return
        end
        vim.api.nvim_buf_call(bufnr, function()
          pcall(vim.cmd, "EmmetInstall")
          vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
        end)
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = HTML_FT,
        callback = function(ev)
          install_emmet(ev.buf)
        end,
      })

      -- Install immediately for the buffer that triggered the lazy load
      install_emmet(0)

      -- VS Code: typing `!` opens Emmet boilerplate suggestion (any HTML buffer)
      vim.api.nvim_create_autocmd("InsertCharPre", {
        group = group,
        pattern = HTML_GLOB,
        callback = function()
          if vim.v.char ~= "!" or in_embedded() or not is_html_ft() then
            return
          end
          vim.schedule(function()
            local ok, blink = pcall(require, "blink.cmp")
            if ok then
              blink.show({ providers = { "lsp" } })
            end
          end)
        end,
      })
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.keymap = opts.keymap or {}

      opts.keymap["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active({ direction = 1 }) then
            return nil
          end
          if cmp.is_menu_visible() then
            local item = cmp.get_selected_item()
            if in_script() and item and is_html_tag_completion(item) then
              cmp.hide()
              return nil
            end
            return cmp.select_and_accept()
          end
          -- Emmet Tab expand in HTML markup (same in every project)
          if not in_embedded() and is_html_ft() then
            pcall(function()
              require("lazy").load({ plugins = { "emmet-vim" } })
            end)
            local ok, expandable = pcall(vim.fn["emmet#isExpandable"])
            if ok and expandable ~= 0 then
              vim.fn["emmet#expandAbbr"](0, "")
              return true
            end
          end
        end,
        LazyVim.cmp.map({ "snippet_forward", "ai_nes", "ai_accept" }),
        "fallback",
      }
      opts.keymap["<S-Tab>"] = { "snippet_backward", "fallback" }

      opts.completion = opts.completion or {}
      opts.completion.list = opts.completion.list or {}
      opts.completion.list.selection = { preselect = true, auto_insert = false }
      opts.completion.accept = opts.completion.accept or {}
      opts.completion.accept.auto_brackets = {
        enabled = true,
        blocked_filetypes = { "html", "htmldjango", "xml", "css", "scss" },
      }
      opts.completion.trigger = opts.completion.trigger or {}
      opts.completion.trigger.show_on_trigger_character = true
      -- After accepting Emmet (`<section>$0</section>`), do not reopen the menu
      -- while the snippet is still active (that caused sticky `</section>` / `a~` spam).
      opts.completion.trigger.show_in_snippet = false
      opts.completion.trigger.show_on_accept_on_trigger_character = false
      -- Typing `{` (mini.pairs → `{|}`) must not pop CSS property spam; type a
      -- letter first, or <C-Space>. Keeps Enter free for the indent gap.
      local prev_blocked = opts.completion.trigger.show_on_blocked_trigger_characters
      opts.completion.trigger.show_on_blocked_trigger_characters = function()
        if is_web_indent_ft() then
          return { " ", "\n", "\t", "{", "}", "(", ")", "[", "]", ">", "<" }
        end
        if type(prev_blocked) == "function" then
          return prev_blocked()
        end
        return prev_blocked or { " ", "\n", "\t" }
      end

      opts.completion.menu = opts.completion.menu or {}
      local prev_auto_show = opts.completion.menu.auto_show
      opts.completion.menu.auto_show = function(ctx, items)
        -- Empty `{|}` / `>|</`: no menu — Enter should open a gap, not accept `border`.
        if is_web_indent_ft() and is_between_pair() then
          return false
        end
        if is_html_ft() and not in_embedded() then
          local ok, blink = pcall(require, "blink.cmp")
          if ok and blink.snippet_active({ direction = 1 }) then
            return false
          end
        end
        if type(prev_auto_show) == "function" then
          return prev_auto_show(ctx, items)
        end
        return prev_auto_show ~= false
      end

      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}

      -- Provider id is "omni" (not "omnifunc") — invalid id crashes blink entirely
      opts.sources.providers.omni = opts.sources.providers.omni or {}
      opts.sources.providers.omni.enabled = false

      local buffer = opts.sources.providers.buffer or {}
      local prev_buf = buffer.enabled
      buffer.enabled = function(ctx)
        if in_embedded() then
          return false
        end
        if type(prev_buf) == "function" then
          return prev_buf(ctx)
        end
        return prev_buf ~= false
      end
      opts.sources.providers.buffer = buffer

      -- Emmet owns HTML abbreviations. friendly-snippets (`a~`, `dateDMY~`, …)
      -- only fight Emmet/html-lsp and keep the menu sticky after Enter.
      local snippets = opts.sources.providers.snippets or {}
      local prev_snip = snippets.enabled
      snippets.enabled = function(ctx)
        if is_html_ft() then
          return false
        end
        if type(prev_snip) == "function" then
          return prev_snip(ctx)
        end
        return prev_snip ~= false
      end
      opts.sources.providers.snippets = snippets

      local lsp = opts.sources.providers.lsp or {}
      local prev_transform = lsp.transform_items
      lsp.transform_items = function(ctx, items)
        if prev_transform then
          items = prev_transform(ctx, items)
        end

        if in_script() then
          local filtered = vim.tbl_filter(function(item)
            if is_html_tag_completion(item) or is_emmet_client(item.client_name) then
              return false
            end
            return true
          end, items)
          for _, item in ipairs(filtered) do
            if is_otter_item(item) then
              item.score_offset = (item.score_offset or 0) + 20
            elseif item.client_name == "html" then
              item.score_offset = (item.score_offset or 0) - 10
            end
          end
          return filtered
        end

        if in_style() then
          return vim.tbl_filter(function(item)
            if is_html_tag_completion(item) or is_emmet_client(item.client_name) then
              return false
            end
            local name = item.client_name
            if not name then
              return true
            end
            return name == "html"
              or name == "cssls"
              or name == "tailwindcss"
              or is_otter_item(item)
          end, items)
        end

        -- Markup: prefer Emmet for tag expand; drop html-lsp duplicates of the
        -- same abbreviation so Enter accepts one clean `<tag>$0</tag>` snippet.
        if is_html_ft() and not in_embedded() then
          local has_emmet = false
          for _, item in ipairs(items) do
            if is_emmet_client(item.client_name) then
              has_emmet = true
              break
            end
          end
          if has_emmet then
            return vim.tbl_filter(function(item)
              if item.client_name == "html" and is_html_tag_completion(item) then
                return false
              end
              return true
            end, items)
          end
        end

        return items
      end
      opts.sources.providers.lsp = lsp

      -- Enter: between `{|}` / `>|</` → indent gap (VS Code habit).
      -- Otherwise accept once and hide. Tab still accepts when the menu is open.
      opts.keymap["<CR>"] = {
        function(cmp)
          if not cmp.is_menu_visible() then
            return
          end
          if is_web_indent_ft() and is_between_pair() then
            cmp.hide()
            return -- fallback → cr_smart_indent
          end
          cmp.select_and_accept()
          vim.schedule(function()
            pcall(function()
              require("blink.cmp").hide()
            end)
          end)
          return true
        end,
        "fallback",
      }
    end,
  },

  {
    "olrtg/nvim-emmet",
    ft = { "html", "htmldjango", "css", "javascriptreact", "typescriptreact", "vue", "svelte", "astro" },
    config = function()
      vim.keymap.set({ "n", "v", "i" }, "<A-w>", function()
        if in_script() then
          return
        end
        require("nvim-emmet").wrap_with_abbreviation()
      end, { desc = "Emmet: Wrap with Abbreviation" })
    end,
  },

  {
    "windwp/nvim-ts-autotag",
    opts = {
      opts = {
        -- Keep rename; auto-close fights Emmet/html snippets (`</section></section>`).
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
      per_filetype = {
        html = { enable_close = false },
        htmldjango = { enable_close = false },
      },
    },
  },
}
