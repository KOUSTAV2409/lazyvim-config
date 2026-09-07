-- Python DX: keep pyright for types, ruff for lint/format, quieter while typing.
-- LazyVim extra lang.python already enables both; this tunes them.
-- Shared Noice progress filters live in lsp-perf.lua.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
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
}
