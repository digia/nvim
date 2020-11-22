"
" junegunn/fzf.vim
"
let g:fzf_preview_use_dev_icons = 1
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
let g:fzf_action = { 'ctrl-s': 'split', 'ctrl-v': 'vsplit' }
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>h :History<CR>
nnoremap <silent> <leader>gh :BCommits<CR>

" NOTE: Trying out telescope instead
" command! -bang -nargs=? -complete=dir ProjectFiles
      " \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'source': 'rg --files --hidden --follow --glob "!.git/*"', 'options': ['--info=inline']}), <bang>0)
" command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)
" nnoremap <silent> <leader>/ :execute 'RG ' . input('RG/')<CR>
" nnoremap <silent> <C-p> :ProjectFiles<CR> " All files within the project following .gitignore rules
" nnoremap <silent> <leader>p :GFiles<CR> " All files within git index or working branch
" nnoremap <silent> <leader>o :FZF<CR> " All files within CWD


