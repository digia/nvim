augroup DigiaTypeScriptReactCommands
  au!
  " autocmd BufWritePost <buffer>  :silent! !prettier --write %
  autocmd BufNewFile,BufRead,FileType typescriptreact nmap <leader>rt :call VimuxRunCommand("clear; echo " . bufname("%") . "; npm run --silent test " . bufname("%"))<cr>
augroup END

setlocal shiftwidth=2
