augroup DigiaLuaCommands
  au!

  " Auto recompile Packer when changes are made to plugins.lua
  autocmd BufWritePost plugins.lua PackerCompile
augroup END