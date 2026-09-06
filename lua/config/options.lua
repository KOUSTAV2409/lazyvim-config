-- Options are automatically loaded before lazy.nvim startup.
require("config.remote_clipboard").setup()

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
vim.opt.updatetime = 250 -- faster hover / diagnostics / git blame
vim.opt.timeoutlen = 300
vim.opt.pumheight = 12 -- keep suggestion menu compact
vim.opt.smoothscroll = true

-- Force markdown layout to auto-wrap long text lines naturally
vim.g.markdown_recommended_style = 0
vim.opt.textwidth = 80
