-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Neovim 0.12 enables document_color by default. On some builds it flushes
-- textDocument/didChange on nearly every keystroke, so pyright/vtsls look like
-- they are "loading" constantly. Color swatches for CSS/Tailwind still come
-- from mini-hipatterns + the Tailwind language server.
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    if vim.lsp.document_color then
      pcall(vim.lsp.document_color.enable, false)
    end
  end,
})
