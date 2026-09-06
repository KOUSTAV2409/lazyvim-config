-- Lightweight VS Code–style UX extras for LazyVim.

return {
  -- Alt+arrows move lines / selections
  {
    "nvim-mini/mini.move",
    event = "VeryLazy",
    opts = {
      mappings = {
        left = "<A-Left>",
        right = "<A-Right>",
        down = "<A-Down>",
        up = "<A-Up>",
        line_left = "<A-Left>",
        line_right = "<A-Right>",
        line_down = "<A-Down>",
        line_up = "<A-Up>",
      },
    },
  },

  -- Multi-cursor (VS Code Ctrl+Alt+Up/Down muscle memory)
  {
    "jake-stewart/multicursor.nvim",
    branch = "1.0",
    event = "VeryLazy",
    config = function()
      local mc = require("multicursor-nvim")
      mc.setup()

      local map = vim.keymap.set
      map({ "n", "x" }, "<C-A-Up>", function()
        mc.lineAddCursor(-1)
      end, { desc = "Add Cursor Above" })
      map({ "n", "x" }, "<C-A-Down>", function()
        mc.lineAddCursor(1)
      end, { desc = "Add Cursor Below" })
      map({ "n", "x" }, "<C-S-l>", function()
        mc.matchAddCursor(1)
      end, { desc = "Add Next Match Cursor" })
      map("n", "<leader>mc", function()
        if mc.hasCursors() then
          mc.clearCursors()
        end
      end, { desc = "Clear Multi-Cursors" })
    end,
  },

  -- VS Code sticky scroll (context lines while scrolling)
  {
    "nvim-treesitter/nvim-treesitter-context",
    optional = true,
    opts = {
      max_lines = 3,
      multiline_threshold = 1,
      mode = "cursor",
    },
  },
}
