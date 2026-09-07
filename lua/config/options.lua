-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

-- Neovim 0.12 enables document_color by default; it re-requests on nearly every
-- textDocument/didChange and makes pyright/vtsls look constantly "loading".
-- Must run early in options.lua — user autocmds load on VeryLazy and VimEnter
-- can miss the common `nvim` → `:edit` flow. CSS/Tailwind swatches still come
-- from mini-hipatterns + the Tailwind language server.
if vim.lsp.document_color then
  pcall(vim.lsp.document_color.enable, false)
end

vim.opt.relativenumber = false
vim.g.autoformat = false -- format on demand (Shift+Alt+F), like VS Code default
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"

-- VS Code–like editing comfort
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.confirm = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 300 -- CursorHold / words / blame; slightly quieter than 250
vim.opt.timeoutlen = 300
vim.opt.pumheight = 12 -- keep suggestion menu compact
vim.opt.smoothscroll = true

-- Force markdown layout to auto-wrap long text lines naturally
vim.g.markdown_recommended_style = 0
vim.opt.textwidth = 80
