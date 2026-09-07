-- Rust: keep rust-analyzer completions; tone down LazyVim's allFeatures default.
-- Install analyzer on the OS: rustup component add rust-analyzer

return {
  {
    "mrcjkb/rustaceanvim",
    optional = true,
    opts = {
      server = {
        default_settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = false, -- big RAM win; enable per-project if needed
              loadOutDirsFromCheck = true,
              buildScripts = { enable = true },
            },
            check = {
              command = "check", -- not clippy-on-every-save
            },
            procMacro = { enable = true },
            files = { watcher = "client" },
          },
        },
      },
    },
  },
}
