-- space bar leader key
vim.g.mapleader = " "

vim.keymap.set("i", "<C-c>", "<Esc>")

-- Reload nvim config
vim.keymap.set("n", "<leader><leader>r", ":source $MYVIMRC<CR>")

-- System clipboard with <leader>y
vim.keymap.set({"n", "v"}, "<leader>y", [["+y]], { desc = "Yank to system clipboard (cmd-v)" })
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Window movement
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

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
