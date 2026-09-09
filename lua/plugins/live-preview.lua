-- VS Code Live Server–style HTML/CSS preview.
-- HTML refreshes in the browser when you save (Ctrl+S / :w).
-- No Node required — pure Lua server inside Neovim.

return {
  {
    "brianhuster/live-preview.nvim",
    dependencies = { "folke/snacks.nvim" },
    cmd = { "LivePreview" },
    ft = { "html", "htmldjango", "css", "scss", "markdown", "svg" },
    keys = {
      {
        "<leader>lp",
        "<cmd>LivePreview start<cr>",
        desc = "Live Preview: Start",
      },
      {
        "<leader>lP",
        "<cmd>LivePreview close<cr>",
        desc = "Live Preview: Close",
      },
      -- Muscle-memory-ish "Live" chord (Alt+Shift+L)
      {
        "<A-S-l>",
        "<cmd>LivePreview start<cr>",
        mode = { "n", "i" },
        desc = "Live Preview: Start",
      },
    },
    opts = {
      port = 5500,
      browser = "default",
      -- Serve from the project folder so ./dist/output.css and relative assets resolve
      dynamic_root = true,
      sync_scroll = true,
      picker = "snacks.picker",
    },
    config = function(_, opts)
      require("livepreview.config").set(opts)
    end,
  },
}
