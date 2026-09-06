-- Cross-language polish that LazyVim extras don't cover alone.
-- HTML/CSS/Emmet live in web.lua; JS/TS DX in javascript.lua.
-- Lua is core LazyVim (lua_ls + stylua) — no extra required.

return {
  -- Treesitter parsers for the full generalist stack
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "c",
        "cpp",
        "css",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "ruby",
        "rust",
        "scss",
        "sql",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "yaml",
      },
    },
  },

  -- SQLite-friendly SQL lint/format (dadbod UI comes from lang.sql extra)
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        sqlfluff = {
          args = { "lint", "--format=json", "--dialect=sqlite" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        sqlfluff = {
          args = { "fix", "--dialect=sqlite", "-" },
        },
      },
    },
  },

  -- Always have common tools even before opening a matching file once
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- web (also in web.lua; listed here so lock/docs stay honest)
        "html-lsp",
        "css-lsp",
        "emmet-language-server",
        "prettier",
        "eslint-lsp",
        "vtsls",
        "json-lsp",
        "tailwindcss-language-server",
        -- python
        "pyright",
        "ruff",
        -- ruby / rails views
        "ruby-lsp",
        "rubocop",
        "erb-formatter",
        "erb-lint",
        -- c / c++
        "clangd",
        "codelldb",
        -- sql
        "sqlfluff",
        -- docker (lang.docker extra)
        "dockerfile-language-server",
        "docker-compose-language-service",
        "hadolint",
        -- shell / config
        "shellcheck",
        "shfmt",
        "yaml-language-server",
        "taplo",
        "marksman",
      },
    },
  },
}
