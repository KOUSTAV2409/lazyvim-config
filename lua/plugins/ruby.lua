-- Ruby: one LSP (ruby_lsp). Rubocop stays as formatter via conform — not a second LSP.
-- Completions / goto / hover remain on ruby_lsp.
--
-- Prefer ruby-lsp sitting next to PATH `ruby` (mise: `gem install ruby-lsp`).
-- Mason prepends its bin (#!/usr/bin/ruby wrapper) which breaks on Arch without bundler.

local mason_ruby_lsp = vim.fn.stdpath("data") .. "/mason/packages/ruby-lsp/bin/ruby-lsp"
local mason_gem_path = vim.fn.stdpath("data") .. "/mason/packages/ruby-lsp"

---@type table
local ruby_lsp_opts = {
  flags = { debounce_text_changes = 400 },
  root_markers = { "Gemfile", "Gemfile.lock", ".git" },
  cmd = function(dispatchers, config)
    local ruby = vim.fn.exepath("ruby")
    local sibling = ruby ~= "" and (vim.fn.fnamemodify(ruby, ":h") .. "/ruby-lsp") or ""
    local exe ---@type string[]
    local env = vim.tbl_deep_extend("force", {}, vim.fn.environ())

    -- Mason / mixed Ruby installs pollute these and break composed bundles.
    env.GEM_PATH = nil
    env.GEM_HOME = nil
    env.BUNDLE_PATH = nil
    env.RUBYLIB = nil
    env.RUBYOPT = nil

    if sibling ~= "" and vim.uv.fs_stat(sibling) then
      exe = { sibling }
    elseif ruby ~= "" and vim.uv.fs_stat(mason_ruby_lsp) then
      exe = { ruby, mason_ruby_lsp }
      env.GEM_PATH = mason_gem_path
    else
      local path_lsp = vim.fn.exepath("ruby-lsp")
      exe = { path_lsp ~= "" and path_lsp or "ruby-lsp" }
    end

    -- Ensure mise ruby bin is first on PATH for child bundle/ruby-lsp
    if ruby ~= "" then
      env.PATH = vim.fn.fnamemodify(ruby, ":h") .. ":" .. (env.PATH or "")
    end

    local opts = { env = env }
    if config and config.root_dir then
      opts.cwd = config.cmd_cwd or config.root_dir
    end
    return vim.lsp.rpc.start(exe, dispatchers, opts)
  end,
}

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ruby_lsp = ruby_lsp_opts,
        rubocop = { enabled = false },
      },
    },
  },
}
