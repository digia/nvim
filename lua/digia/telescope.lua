--[[
-- WIP: Using tjdevries dotfiles as reference while refactoring
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/tj/telescope
--]]
local is_git_repo = function (cwd)
  local cmd = 'git -C ' .. cwd .. ' rev-parse --show-toplevel'
  local git_root = vim.fn.systemlist(cmd)[1]

  if vim.v.shell_error ~= 0 then
    return false
  end

  return true
end

local M = {}

function M.find_all_files()
  local find_command = { "rg", "--smart-case", "--files", "--hidden", "--follow" }
  require('telescope.builtin').find_files {
    prompt_title = 'Find All Files',
    find_command = find_command
  }
end

function M.find_project_files()
  local builtin = require('telescope.builtin')

  local title = 'Find Project Files'

  if is_git_repo(vim.loop.cwd()) then
    builtin.find_files {
      prompt_title = title
    }
  else
    -- TODO(digia): Better way to define language specific ignores
    local find_command = {
      "rg",
      "--smart-case",
      "--files",
      "--hidden",
      "--follow",
      "-g", "!*/.git/*",
      "-g", "!*/node_modules/*",
      "-g", "!*/venv/*"
    }

    builtin.find_files {
      prompt_title = title,
      find_command = find_command
    }
  end
end

return M

