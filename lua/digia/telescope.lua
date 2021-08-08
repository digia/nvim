require('telescope').setup({
    defaults = {
        file_sorter = require('telescope.sorters').get_fzy_sorter,
        prompt_prefix = '> ',
        color_devicons = true,

        -- TODO(digia): Finish reviewing https://www.youtube.com/watch?v=2tO2sT7xX2k
        -- file_previewer = require('telescope.previewers').vim_buffer_cat.new,
        -- grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
        -- qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

        -- mappings = {
            -- i = {
                -- ['<C-x>'] = false,
                -- ['<C-q>'] = actions.send_to_qflist,
            -- },
        -- },
    },
    extensions = {
        fzy_native = {
            override_generic_sorter = false,
            override_file_sorter = true,
        },
    },
})
require('telescope').load_extension('fzy_native')

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

-- TODO(digia): Review customer finders below and see if they're necessary with fzy
local M = {}

function M.find_all_files()
  local find_command = {
    'rg',
    '--smart-case',
    '--files',
    '--hidden',
    '--follow',
    '--no-ignore',
    '-g', '!*/.git/*',
  }

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
      'rg',
      '--smart-case',
      '--files',
      '--hidden',
      '--follow',
      '--ignore',
    }

    builtin.find_files {
      prompt_title = title,
      find_command = find_command
    }
  end
end

return M

