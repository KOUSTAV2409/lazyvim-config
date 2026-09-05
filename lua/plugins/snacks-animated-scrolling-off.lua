-- Snacks: disable scroll animation + VS Code–like bottom terminal panel.
return {
  {
    "folke/snacks.nvim",
    opts = {
      scroll = {
        enabled = false,
      },
      terminal = {
        win = {
          position = "bottom",
          height = 0.32,
          border = "top",
          wo = {
            winbar = "   %{get(b:, 'term_title', 'terminal')} ",
          },
          keys = {
            -- Hide like VS Code Ctrl+`
            hide_grave = { "<C-`>", "hide", desc = "Hide Terminal", mode = "t" },
            hide_slash = { "<C-/>", "hide", desc = "Hide Terminal", mode = "t" },
            hide_underscore = { "<C-_>", "hide", desc = "which_key_ignore", mode = "t" },
            -- Paste from system clipboard (VS Code Ctrl+V in terminal)
            paste = {
              "<C-v>",
              function()
                local text = vim.fn.getreg("+")
                if text == nil or text == "" then
                  text = vim.fn.getreg("*")
                end
                if text and text ~= "" then
                  vim.api.nvim_paste(text, false, -1)
                end
              end,
              mode = "t",
              desc = "Paste",
            },
            -- Jump back to editor
            editor = {
              "<C-h>",
              function()
                vim.cmd("wincmd k")
              end,
              mode = "t",
              desc = "Focus Editor",
            },
            -- Clear scrollback visually (shell still owns Ctrl+L clear)
            normal = {
              "<C-S-n>",
              function(self)
                self.esc_timer = self.esc_timer or (vim.uv or vim.loop).new_timer()
                vim.cmd("stopinsert")
              end,
              mode = "t",
              desc = "Terminal Normal Mode",
            },
          },
        },
      },
    },
    keys = {
      {
        "<C-`>",
        function()
          Snacks.terminal.toggle(nil, { cwd = LazyVim.root() })
        end,
        desc = "Toggle Terminal",
        mode = { "n", "i", "t" },
      },
      {
        "<C-S-`>",
        function()
          -- Counted float terminal (2Ctrl+` style): open a second shell
          Snacks.terminal.toggle(nil, {
            cwd = LazyVim.root(),
            win = { position = "float", height = 0.85, width = 0.9, border = "rounded" },
            env = { SNACKS_TERM = "float" },
          })
        end,
        desc = "Toggle Floating Terminal",
        mode = { "n", "i", "t" },
      },
    },
  },
}
