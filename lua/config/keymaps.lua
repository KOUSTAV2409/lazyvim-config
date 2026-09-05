-- VS Code–familiar keymaps for LazyVim (Omarchy / Foot).
-- Uses Snacks picker (LazyVim default) — Telescope is not installed.
-- Note: some chords arrive as <C-_> instead of <C-/> in the terminal.
-- Never map <C-[> — in terminals that is Escape.

local map = vim.keymap.set

local function snacks_ok()
  return Snacks and Snacks.picker
end

-- ----------------------------------------------------------------------------
-- 1. Clipboard: Copy / Paste / Cut
-- ----------------------------------------------------------------------------
map("v", "<C-c>", '"+y', { desc = "Copy" })
map({ "n", "v" }, "<C-v>", '"+p', { desc = "Paste" })
map("i", "<C-v>", "<C-r>+", { desc = "Paste" })
map("v", "<C-x>", '"+d', { desc = "Cut" })
map({ "n", "i", "v" }, "<C-a>", "<Esc>ggVG", { desc = "Select All" })

-- ----------------------------------------------------------------------------
-- 2. Files / Explorer / Tabs
-- ----------------------------------------------------------------------------
map({ "n", "i", "v" }, "<C-s>", "<cmd>w<cr><Esc>", { desc = "Save File" })
map({ "n", "i", "v" }, "<C-S-s>", "<cmd>wa<cr><Esc>", { desc = "Save All" })

-- Quick Open (Ctrl+P) + Command Palette (Ctrl+Shift+P)
map({ "n", "i", "v" }, "<C-p>", function()
  if snacks_ok() then
    Snacks.picker.files()
  end
end, { desc = "Quick Open" })

map({ "n", "i", "v" }, "<C-S-p>", function()
  if snacks_ok() then
    Snacks.picker.commands()
  end
end, { desc = "Command Palette" })

-- Find: prefer native `/` (faster muscle memory than a picker widget).
-- Ctrl+F just drops you into `/` — same power, less chrome.
map("n", "<C-f>", "/", { desc = "Find in File (/)" })
map("i", "<C-f>", "<Esc>/", { desc = "Find in File (/)" })

map({ "n", "i" }, "<C-S-f>", function()
  if snacks_ok() then
    Snacks.picker.grep()
  end
end, { desc = "Find in Project" })

-- Replace in *current file* (VS Code Ctrl+H). Ctrl+H itself is Backspace/window-left.
-- In the UI: fill Replace, then use the replace / replace-all actions (shown in the buffer).
-- Project-wide replace stays on LazyVim default: <leader>sr
local function replace_in_file()
  local ok, grug = pcall(require, "grug-far")
  if not ok then
    return
  end
  local path = vim.fn.expand("%")
  if path == "" then
    grug.open({ transient = true })
    return
  end
  grug.open({
    transient = true,
    prefills = {
      paths = path,
      search = vim.fn.expand("<cword>"),
    },
  })
end

map("n", "<C-S-h>", replace_in_file, { desc = "Replace in File" })
map("v", "<C-S-h>", function()
  local ok, grug = pcall(require, "grug-far")
  if ok then
    grug.with_visual_selection({ prefills = { paths = vim.fn.expand("%") } })
  end
end, { desc = "Replace Selection in File" })

map({ "n", "i", "v" }, "<C-b>", "<Esc><cmd>Neotree toggle<cr>", { desc = "Toggle Explorer" })
map({ "n", "i", "v" }, "<C-S-e>", "<Esc><cmd>Neotree focus<cr>", { desc = "Focus Explorer" })

map({ "n", "i", "v" }, "<C-w>", function()
  Snacks.bufdelete()
end, { desc = "Close Tab" })

map({ "n", "i", "v" }, "<C-PageUp>", "<Esc><cmd>bprevious<cr>", { desc = "Previous Tab" })
map({ "n", "i", "v" }, "<C-PageDown>", "<Esc><cmd>bnext<cr>", { desc = "Next Tab" })
map({ "n", "i", "v" }, "<C-Tab>", "<Esc><cmd>bnext<cr>", { desc = "Next Tab" })
map({ "n", "i", "v" }, "<C-S-Tab>", "<Esc><cmd>bprevious<cr>", { desc = "Previous Tab" })

-- ----------------------------------------------------------------------------
-- 3. Editing
-- ----------------------------------------------------------------------------
-- Duplicate line (your Notepad++ preference). Also on Ctrl+Shift+D like VS Code.
map({ "n", "i" }, "<C-d>", "<Esc><cmd>t.<cr>gi", { desc = "Duplicate Line" })
map({ "n", "i" }, "<C-S-d>", "<Esc><cmd>t.<cr>gi", { desc = "Duplicate Line" })

-- Delete line (VS Code Ctrl+Shift+K)
map({ "n", "i" }, "<C-S-k>", "<Esc>dd", { desc = "Delete Line" })
map("v", "<C-S-k>", "d", { desc = "Delete Selection" })

map({ "n", "i", "v" }, "<C-z>", "<Esc>u", { desc = "Undo" })
map({ "n", "i", "v" }, "<C-y>", "<Esc><C-r>", { desc = "Redo" })

-- Toggle comment (terminals often send <C-_> for Ctrl+/)
map("n", "<C-/>", "gcc", { remap = true, desc = "Toggle Comment" })
map("n", "<C-_>", "gcc", { remap = true, desc = "Toggle Comment" })
map("v", "<C-/>", "gc", { remap = true, desc = "Toggle Comment" })
map("v", "<C-_>", "gc", { remap = true, desc = "Toggle Comment" })
map("i", "<C-/>", "<Esc>gccgi", { remap = true, desc = "Toggle Comment" })
map("i", "<C-_>", "<Esc>gccgi", { remap = true, desc = "Toggle Comment" })

-- Indent (Ctrl+] only — Ctrl+[ is Escape in terminals)
map("n", "<C-]>", ">>", { desc = "Indent" })
map("v", "<C-]>", ">gv", { desc = "Indent" })
map("i", "<C-]>", "<C-t>", { desc = "Indent" })
map("v", "<Tab>", ">gv", { desc = "Indent" })
map("v", "<S-Tab>", "<gv", { desc = "Outdent" })

-- Line move is handled by mini.move (Alt+Up/Down) in plugins/vscode-ux.lua

-- ----------------------------------------------------------------------------
-- 4. Selection (Shift + arrows)
-- ----------------------------------------------------------------------------
map("n", "<S-Up>", "v<Up>", { desc = "Select Up" })
map("n", "<S-Down>", "v<Down>", { desc = "Select Down" })
map("n", "<S-Left>", "v<Left>", { desc = "Select Left" })
map("n", "<S-Right>", "v<Right>", { desc = "Select Right" })
map("v", "<S-Up>", "<Up>", { desc = "Extend Selection Up" })
map("v", "<S-Down>", "<Down>", { desc = "Extend Selection Down" })
map("v", "<S-Left>", "<Left>", { desc = "Extend Selection Left" })
map("v", "<S-Right>", "<Right>", { desc = "Extend Selection Right" })

map("n", "<C-S-Left>", "vB", { desc = "Select Word Left" })
map("n", "<C-S-Right>", "vE", { desc = "Select Word Right" })
map("v", "<C-S-Left>", "B", { desc = "Extend Word Left" })
map("v", "<C-S-Right>", "E", { desc = "Extend Word Right" })

-- Insert-mode word hops (VS Code Ctrl+Left/Right)
map("i", "<C-Left>", "<C-o>b", { desc = "Word Left" })
map("i", "<C-Right>", "<C-o>w", { desc = "Word Right" })

-- ----------------------------------------------------------------------------
-- 5. Go to / LSP (VS Code-ish)
-- ----------------------------------------------------------------------------
map({ "n", "i" }, "<C-g>", function()
  vim.ui.input({ prompt = "Go to line: " }, function(input)
    local n = tonumber(input)
    if n then
      vim.api.nvim_win_set_cursor(0, { n, 0 })
    end
  end)
end, { desc = "Go to Line" })

map("n", "<F12>", vim.lsp.buf.definition, { desc = "Go to Definition" })
map("n", "<S-F12>", vim.lsp.buf.references, { desc = "Find References" })
map("n", "<F2>", vim.lsp.buf.rename, { desc = "Rename Symbol" })
map({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, { desc = "Quick Fix" })
map({ "n", "i", "v" }, "<C-S-o>", function()
  if snacks_ok() then
    Snacks.picker.lsp_symbols()
  end
end, { desc = "Go to Symbol in File" })
map({ "n", "i", "v" }, "<C-t>", function()
  if snacks_ok() then
    Snacks.picker.lsp_workspace_symbols()
  end
end, { desc = "Go to Symbol in Workspace" })

-- Format document (Shift+Alt+F)
map({ "n", "i", "v" }, "<A-S-f>", function()
  LazyVim.format({ force = true })
end, { desc = "Format Document" })

-- ----------------------------------------------------------------------------
-- 6. Terminal / splits
-- ----------------------------------------------------------------------------
-- Ctrl+` / Ctrl+Shift+` are defined on snacks.nvim keys (plugins/snacks-*.lua)
-- so they work consistently from normal, insert, and terminal modes.

map({ "n", "i" }, "<C-\\>", "<Esc><cmd>vsplit<cr>", { desc = "Split Editor Right" })
