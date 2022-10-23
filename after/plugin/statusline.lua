local lualine = require('lualine')
local navic = require('nvim-navic')

local filename_location = require('digia.statusline.filename_location')


local sections = {
  lualine_a = {
    {
      filename_location,
      path = 1,
      shorting_target = 60, -- Space to __leave__ within the window
    }
  },

  lualine_b = {
    {
      'filetype',
      icons_enabled = true, -- TODO: fix the color of the python icon, the yellow is distracting
      -- icon_only = true,
      
    }
  },

  lualine_c = {},

  lualine_x = {
    {
      navic.get_location,
      cond = navic.is_available,
    },
  },

  lualine_y = {
    'diagnostics',
  },

  lualine_z = {},
}

lualine.setup({
  sections = sections,
  inactive_sections = sections,
})
