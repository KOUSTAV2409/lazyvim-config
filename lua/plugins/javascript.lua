-- Standalone JavaScript / TypeScript DX (VS Code–ish).
-- Pairs, indent-between-braces, snippets, and sensible defaults.
-- Complements LazyVim lang.typescript (vtsls) — works in any folder.

local JS_FT = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
}

local function is_js_ft(ft)
  ft = ft or vim.bo.filetype
  return vim.tbl_contains(JS_FT, ft)
end

--- VS Code: Enter between () / {} / [] opens a newline and indents.
local function cr_between_brackets()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2]
  local before = line:sub(col, col)
  local after = line:sub(col + 1, col + 1)
  local pairs = { ["("] = ")", ["["] = "]", ["{"] = "}" }
  if pairs[before] and after == pairs[before] then
    return "<CR><Esc>O"
  end
  return "<CR>"
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        vtsls = {
          single_file_support = true,
          flags = { debounce_text_changes = 500 },
          settings = {
            javascript = {
              suggest = {
                completeFunctionCalls = true,
                includeCompletionsForModuleExports = true,
              },
              format = { enable = false }, -- prettier via LazyVim extra
              updateImportsOnFileMove = { enabled = "always" },
              -- Quiet typing cost; toggle LazyVim <leader>uh if you want inlays back
              inlayHints = {
                parameterNames = { enabled = "none" },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = false },
              },
              tsserver = { maxTsServerMemory = 2048 },
            },
            typescript = {
              suggest = { completeFunctionCalls = true },
              format = { enable = false },
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = {
                parameterNames = { enabled = "none" },
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = false },
                functionLikeReturnTypes = { enabled = false },
                enumMemberValues = { enabled = false },
              },
              tsserver = { maxTsServerMemory = 2048 },
            },
          },
        },
        -- Lint on save, not on every keystroke (still get diagnostics after :w)
        eslint = {
          flags = { debounce_text_changes = 500 },
          settings = {
            run = "onSave",
            workingDirectories = { mode = "auto" },
          },
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "javascript", "typescript", "tsx" },
      indent = { enable = true },
    },
  },

  -- Buffer defaults + Enter-between-brackets for every JS/TS file
  {
    "nvim-mini/mini.pairs",
    optional = true,
    opts = function(_, opts)
      vim.api.nvim_create_autocmd("FileType", {
        pattern = JS_FT,
        callback = function(ev)
          vim.bo[ev.buf].expandtab = true
          vim.bo[ev.buf].shiftwidth = 2
          vim.bo[ev.buf].tabstop = 2
          vim.bo[ev.buf].softtabstop = 2
          vim.bo[ev.buf].indentexpr = "v:lua.LazyVim.treesitter.indentexpr()"

          vim.keymap.set("i", "<CR>", cr_between_brackets, {
            buffer = ev.buf,
            expr = true,
            desc = "Indent between brackets",
          })
        end,
      })
      return opts
    end,
  },

  {
    "saghen/blink.cmp",
    optional = true,
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.providers = opts.sources.providers or {}

      -- Prefer snippets (if / for / function) so Tab expands like VS Code
      local snippets = opts.sources.providers.snippets or {}
      local prev_transform = snippets.transform_items
      snippets.transform_items = function(ctx, items)
        if prev_transform then
          items = prev_transform(ctx, items)
        end
        if is_js_ft() then
          for _, item in ipairs(items) do
            item.score_offset = (item.score_offset or 0) + 5
          end
        end
        return items
      end
      opts.sources.providers.snippets = snippets
    end,
  },
}
