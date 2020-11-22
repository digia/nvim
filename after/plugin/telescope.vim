""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvim-telescope/telescope.nvim
"
" https://github.com/nvim-telescope/telescope.nvim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <expr> <C-p> fugitive#head() != '' ? ':lua require("telescope.builtin").find_files{ find_command = { "rg", "--smart-case", "--files", "--hidden", "--follow", "-g", "!.git/*" } }<CR><CR>' : ':lua require("telescope.builtin").find_files()<CR>'

nnoremap <silent> <leader>p :lua require('telescope.builtin').git_files()<CR>
nnoremap <silent> <leader>o :lua require('telescope.builtin').find_files{ find_command = { "rg", "--smart-case", "--files", "--hidden", "--follow" } }<CR>
nnoremap <silent> <leader>/ :lua require('telescope.builtin').live_grep()<CR>
