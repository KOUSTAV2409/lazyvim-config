-- C/C++: keep clangd completions, drop background-index + clang-tidy by default
-- (those are the big RAM/CPU costs on every save/edit in large trees).
-- Re-enable the commented flags for full god-tier analysis when needed.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          flags = { debounce_text_changes = 500 },
          cmd = {
            "clangd",
            -- "--background-index", -- enable for large projects when you want full index
            -- "--clang-tidy",       -- enable when you want tidy on edit (heavy)
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            usePlaceholders = true,
            completeUnimported = true,
            clangdFileStatus = false,
          },
        },
      },
    },
  },
}
