require('digia.plugins')

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

-- TEMP: Testing out a function to rename the current file (2024-04-24)
local function rename_current_file()
    local current_file = vim.api.nvim_buf_get_name(0)

    -- Ask for the new filename, pre-filling the current filename
    local new_file, input_cancelled  = vim.fn.input('New filename: ', current_file, 'file')

    -- Check if input was cancelled, assuming cancellation if input is empty
    if input_cancelled or new_file == '' then
        print('File rename cancelled')
        return
    end

    -- Proceed with renaming if there is a valid new filename and it's different from the current
    if new_file and #new_file > 0 and new_file ~= current_file then
        -- Try to rename and handle potential errors
        local success, err = pcall(os.rename, current_file, new_file)
        if success then
            vim.api.nvim_command('edit ' .. new_file)
            vim.api.nvim_command('redraw')
            print('File renamed to: ' .. new_file)
        else
            print('Error renaming file: ' .. err)
        end
    else
        print('No valid new filename provided.')
    end
end


vim.api.nvim_create_user_command(
    'RenameFile',
    rename_current_file,
    {desc = "Rename the current file"}
)


-- NOTE(digia): Using a directory as a namespace to avoid module collisions
require('digia.remap')
-- require('digia.lspconfig')
require('digia.treesitter')
require('digia.telescope')
-- require('digia.gps')
