""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvim-telescope/telescope.nvim
"
" https://github.com/nvim-telescope/telescope.nvim
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <leader>b :lua require('telescope.builtin').buffers()<CR>
nnoremap <silent> <leader>/ :lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>

" Files
nnoremap <silent> <leader>fp :lua require('digia.telescope').find_project_files()<CR>
nnoremap <silent> <leader>fg :lua require('telescope.builtin').git_files()<CR>
nnoremap <silent> <leader>fa :lua require('digia.telescope').find_all_files()<CR>
nnoremap <silent> <leader>f/ :lua require('telescope.builtin').live_grep()<CR>
