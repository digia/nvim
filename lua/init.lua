require('plugins')

-- See tjdevries dotfiles for a reference to RELOAD
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/init.lua
RELOAD = require('plenary.reload').reload_module

-- See tjdevries dotfiles for a reference to R
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/init.lua
R = function(name)
  RELOAD(name)
  return require(name)
end

-- See tjdevries dotfiles for a reference to P
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/init.lua
P = function(v)
  print(vim.inspect(v))
  return v
end

-- NOTE(digia): Using a directory as a namespace to avoid module collisions
require('digia/lspconfig')
require('digia/telescope')
