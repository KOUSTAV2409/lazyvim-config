-- Ensure Ctrl+B toggles/closes explorer even while Neo-tree has focus
-- (Neo-tree window maps can otherwise shadow global keys).
return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = {
      window = {
        mappings = {
          ["<C-b>"] = "close",
        },
      },
    },
  },
}
