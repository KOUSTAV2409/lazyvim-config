-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

vim.opt.relativenumber = false
vim.g.autoformat = false
vim.opt.mouse = "a" -- Full mouse tracking enabled
vim.opt.clipboard = "unnamedplus" -- Sync system clipboard immediately

-- VS Code–like editing comfort
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cursorline = true
vim.opt.confirm = true -- prompt instead of failing on quit with unsaved buffers
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Force markdown layout to auto-wrap long text lines naturally
vim.g.markdown_recommended_style = 0
vim.opt.textwidth = 80
