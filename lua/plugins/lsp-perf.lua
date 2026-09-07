-- Shared LSP performance: quieter typing across all languages.
-- Completions / hover / goto stay fully enabled.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        -- Pin LazyVim default so insert-mode typing doesn't refresh diags constantly
        update_in_insert = false,
      },
      servers = {
        -- Neovim default debounce is 150ms; bump globally (per-server can go higher)
        ["*"] = {
          flags = { debounce_text_changes = 300 },
        },
      },
    },
  },

  -- Hide chatty "loading…" progress for analysis servers that fire on every edit.
  -- Keep clangd / rust-analyzer / Mason install progress visible.
  {
    "folke/noice.nvim",
    optional = true,
    opts = function(_, opts)
      opts.routes = opts.routes or {}
      local quiet = {
        pyright = true,
        basedpyright = true,
        ruff = true,
        ruff_lsp = true,
        vtsls = true,
        eslint = true,
        tailwindcss = true,
        cssls = true,
        html = true,
        emmet_language_server = true,
        jsonls = true,
        yamlls = true,
        marksman = true,
        rubocop = true,
        ruby_lsp = true,
        taplo = true,
      }
      vim.list_extend(opts.routes, {
        {
          filter = {
            event = "lsp",
            kind = "progress",
            cond = function(message)
              local client = vim.tbl_get(message.opts, "progress", "client")
              return type(client) == "string" and quiet[client] == true
            end,
          },
          opts = { skip = true },
        },
      })
      opts.lsp = opts.lsp or {}
      opts.lsp.progress = vim.tbl_deep_extend("force", opts.lsp.progress or {}, {
        throttle = 1000,
      })
    end,
  },

  -- Don't spawn heavy CLI linters on every InsertLeave (sqlfluff / hadolint).
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      events = { "BufWritePost", "BufReadPost" },
    },
  },
}
