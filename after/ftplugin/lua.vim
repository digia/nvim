augroup DigiaLuaCommands
  au!

  " Auto recompile Packer when changes are made to plugins.lua
  autocmd BufWritePost digia.plugins.lua PackerCompile
augroup END
