-- VS Code–style web editing for LazyVim (GLOBAL — every project, every .html).
--
-- Markup:  html-lsp + Emmet (`!` / `div>` → Tab) + Alt+W wrap
-- <style>: cssls / html embedded CSS / otter CSS (Emmet HTML junk filtered)
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
    },
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

      local snippets = opts.sources.providers.snippets or {}
      local prev_snip = snippets.enabled
      snippets.enabled = function(ctx)
        if in_embedded() then
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

        return items
      end
      opts.sources.providers.lsp = lsp
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
        enable_close = true,
        enable_rename = true,
        enable_close_on_slash = false,
      },
    },
  },
}
