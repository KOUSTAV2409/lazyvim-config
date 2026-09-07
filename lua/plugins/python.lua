-- Python DX: keep pyright for types, ruff for lint/format, quieter while typing.
-- LazyVim extra lang.python already enables both; this tunes them.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          -- Batch keystrokes before notifying the server (Neovim 0.12 can otherwise
          -- flush didChange very aggressively via document_color / semantic tokens).
          flags = {
            debounce_text_changes = 500,
          },
          settings = {
            pyright = {
              -- Ruff owns import organization / many lint fixes
              disableOrganizeImports = true,
            },
            python = {
              analysis = {
                -- Only open buffers — not the whole repo on every edit
                diagnosticMode = "openFilesOnly",
                typeCheckingMode = "standard",
                autoImportCompletions = true,
                useLibraryCodeForTypes = true,
                autoSearchPaths = true,
              },
            },
          },
        },
        ruff = {
          flags = {
            debounce_text_changes = 300,
          },
        },
      },
    },
  },

  -- Hide pyright/ruff "loading…" progress spam (analysis on every edit).
  -- Keep progress for clangd / rust-analyzer / first-start Mason work.
  {
    "folke/noice.nvim",
    optional = true,
    opts = function(_, opts)
      opts.routes = opts.routes or {}
      vim.list_extend(opts.routes, {
        {
          filter = {
            event = "lsp",
            kind = "progress",
            cond = function(message)
              local client = vim.tbl_get(message.opts, "progress", "client")
              return client == "pyright"
                or client == "basedpyright"
                or client == "ruff"
                or client == "ruff_lsp"
            end,
          },
          opts = { skip = true },
        },
      })
      opts.lsp = opts.lsp or {}
      opts.lsp.progress = vim.tbl_deep_extend("force", opts.lsp.progress or {}, {
        throttle = 1000, -- quieter for servers we still show
      })
    end,
  },
}
