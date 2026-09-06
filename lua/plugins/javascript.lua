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
          settings = {
            javascript = {
              suggest = {
                completeFunctionCalls = true,
                includeCompletionsForModuleExports = true,
              },
              format = { enable = false }, -- prettier via LazyVim extra
              updateImportsOnFileMove = { enabled = "always" },
            },
            typescript = {
              suggest = { completeFunctionCalls = true },
              format = { enable = false },
              updateImportsOnFileMove = { enabled = "always" },
            },
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
