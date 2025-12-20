-- space bar leader key
vim.g.mapleader = " "

-- Ensure Escape key works in all modes
vim.keymap.set("i", "<Esc>", "<Esc>", { noremap = true })
vim.keymap.set("v", "<Esc>", "<Esc>", { noremap = true })
vim.keymap.set("x", "<Esc>", "<Esc>", { noremap = true })
vim.keymap.set("s", "<Esc>", "<Esc>", { noremap = true })
vim.keymap.set("c", "<Esc>", "<Esc>", { noremap = true })

vim.keymap.set("i", "<C-c>", "<Esc>")

-- Reload nvim config
local function reload_config()
  vim.cmd("source $MYVIMRC")
  print("Config reloaded")
end

-- Create :ReloadConfig command
vim.api.nvim_create_user_command("ReloadConfig", reload_config, { desc = "Reload Neovim configuration" })
vim.keymap.set("n", "<leader><leader>r", reload_config, { desc = "Reload config" })

-- System clipboard with <leader>y
vim.keymap.set({"n", "v"}, "<leader>y", '"+y', { desc = "Yank to system clipboard (cmd-v)" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank line(s) to system clipboard (cmd-v)" })

-- Copy filename (normal) or filename:lines (visual) to clipboard for Claude Code
vim.keymap.set("n", "<leader>ys", function()
  local filepath = vim.fn.expand("%:.")
  if filepath == "" then
    print("No filename")
    return
  end
  vim.fn.setreg("+", filepath)
  print("Copied: " .. filepath)
end, { desc = "Copy filename to clipboard" })

vim.keymap.set("v", "<leader>ys", function()
  local filepath = vim.fn.expand("%:.")
  if filepath == "" then
    print("No filename")
    return
  end
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local result = start_line == end_line
    and string.format("%s:%d", filepath, start_line)
    or string.format("%s:%d-%d", filepath, start_line, end_line)
  vim.fn.setreg("+", result)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
  print("Copied: " .. result)
end, { desc = "Copy filename:lines to clipboard" })

-- Window movement
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

-- Terminal mode: escape and navigate splits (left/right only for agent splits)
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h")
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l")

-- Run the last command
vim.keymap.set("n", "<leader><leader>c", ":<up>")
-- nnoremap <leader><leader>c :<up>

-- Keep things centered when manipulating lines
--  * Remap n, to n -> zz -> zv
--  * Next, center, expand any folds
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Text movement
-- vnoremap <C-j> :m ?>+1<CR>gv=gv
-- vnoremap <C-k> :m ?<-2<CR>gv=gv
-- inoremap <C-j> <esc>:m .+1<CR>==
-- inoremap <C-k> <esc>:m .-2<CR>==

-- Add movement to jumplist when greater than N lines
-- nnoremap <expr> k (v:count > 5 ? "m?" . v:count : "") . ?k?
-- nnoremap <expr> j (v:count > 5 ? "m?" . v:count : "") . ?j?

-- Use K to show documentation in preview window
-- nnoremap <silent> K :call <SID>show_documentation()<CR>

-- Void paste, or paste over text without losing current paste
-- vnoremap <leader>p "_dp

-- Turn off search highlighting
-- iTerm2 interprets <C-/> as <C-/>
-- vim.keymap.set("n", "<C-/>", ":nohl<CR>", { silent = true })
-- WezTerm interprets <C-_> as <C-_>
vim.keymap.set("n", "<C-_>", ":nohl<CR>", { silent = true })

-- Reselect visual block after indent
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")
