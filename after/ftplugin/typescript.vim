augroup DigiaTypeScriptCommands
  au!
  " autocmd BufWritePost <buffer>  :silent! !prettier --write %
  autocmd BufNewFile,BufRead,FileType typescript nmap <leader>rt :call VimuxRunCommand("clear; echo " . bufname("%") . "; npm run --silent test " . bufname("%"))<cr>
augroup END

setlocal shiftwidth=2
