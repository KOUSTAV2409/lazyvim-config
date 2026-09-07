-- Ruby: one LSP (ruby_lsp). Rubocop stays as formatter via conform — not a second LSP.
-- Completions / goto / hover remain on ruby_lsp.

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = {
          flags = { debounce_text_changes = 400 },
        },
        -- LazyVim lang.ruby enables rubocop as LSP when formatter=rubocop.
        -- That doubles RAM + progress spam; format still works via conform.
        rubocop = { enabled = false },
      },
    },
  },
}
