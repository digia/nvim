local lualine = require('lualine')

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
    }
  },

  lualine_c = {}, -- Remove the default filename in c

  lualine_x = {},

  lualine_y = {
    'diagnostics',
  },

  lualine_z = {},
}

lualine.setup({
  sections = sections,
  inactive_sections = sections,
})
