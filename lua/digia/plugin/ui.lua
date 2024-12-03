return {
  {
    "lifepillar/vim-solarized8",
    branch = "neovim",
    lazy = false,        -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,     -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd.colorscheme("solarized8_flat")
    end,
    enabled = false,
  },

  -- Tweaks (treesitter highlighting):
  -- - Adds a lot of reds (arguments, (), {}, html, etc.)
  -- - Whites are brighter compared to srvana/neosolarized.nvim, though they are easier to scan at times
  {
    "ishan9299/nvim-solarized-lua",
    lazy = false,        -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,     -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd.colorscheme("solarized-flat")

      -- For avante.tokenizers and templates to work
      require("avante_lib").load()
    end,
    enabled = false,
  },

  -- https://github.com/svrana/neosolarized.nvim
  -- - Easier on the eyes as the whites are not as bright
  -- Tweaks (treesitter highlighting):
  -- - Adds a lot of orange (arguments, (), {}, html, etc.)
  {
    "svrana/neosolarized.nvim",
    lazy = false,        -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,     -- make sure to load this before all the other start plugins
    dependencies = {
      "tjdevries/colorbuddy.nvim",
    },
    config = function()
      require("neosolarized").setup({
        comment_italics = true,
        background_set = false,
      })
      vim.cmd.colorscheme("neosolarized")

      -- For avante.tokenizers and templates to work
      require("avante_lib").load()
    end,
    -- enabled = false,
  },

  -- Too many red hue's!
  {
    "Tsuzat/NeoSolarized.nvim",
    lazy = false,        -- make sure we load this during startup if it is your main colorscheme
    priority = 1000,     -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd.colorscheme("NeoSolarized")
    end,
    enabled = false,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = function(ctx)
        -- TODO: Adjust the delay for which-key
        return ctx.plugin and 0 or 1000
      end,
    },
  },

  -- TODO: Archived plugin, migrate to lukas-reineke/indent-blankline.nvim
  { "Yggdroot/indentLine" },   -- Visual line indention

  -- TODO: Configure indent-blankline (https://github.com/lukas-reineke/indent-blankline.nvim)
  -- {
  -- "lukas-reineke/indent-blankline.nvim",
  -- event = { "BufReadPre", "BufNewFile" },
  -- main = "ibl", -- Lua module name is "ibl" not "indent-blankline"
  -- opts = {
  -- indent = { char = "┊" },
  -- },
  -- },

  -- TODO: Configure goto-preview (https://github.com/rmagatti/goto-preview)
  {
    "rmagatti/goto-preview",
    lazy = true,
    event = "VeryLazy",
    config = function()
      require("goto-preview").setup {}
    end,
  },

  {
    "MeanderingProgrammer/render-markdown.nvim",
    keys = {
      { "<leader>rm", "<cmd>RenderMarkdown toggle<cr>", desc = "Render Markdown (Toggle)" },
    },
  },

  -- Visually distracting (2024-01-01)
  -- { "rcarriga/nvim-notify" },

  -- Current code context for statusline (https://github.com/SmiteshP/nvim-navic)
  {
    "SmiteshP/nvim-navic",
    opts = {
      -- highlight = true,
      -- depth_limit = 4,

      -- Defaults
      -- depth_limit = 0,
      -- depth_limit_indicator = "..",
    },
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "SmiteshP/nvim-navic",
    },

    opts = function()
      local filename_location = require("digia.statusline.filename_location")

      local sections = {
        lualine_a = {
          {
            filename_location,
            path = 1,
            shorting_target = 60,             -- Space to __leave__ within the window
          }
        },

        lualine_b = {
          {
            "filetype",
            icons_enabled = true,
            -- icon_only = true,
          }
        },

        lualine_c = {},

        lualine_x = {
          {
            "navic",
          },
          -- {
          -- noice.api.statusline.mode.get,
          -- cond = noice.api.statusline.mode.has,
          -- color = { fg = "#ff9e64" },
          -- },
        },

        lualine_y = {
          "diagnostics",
        },

        lualine_z = {},
      }

      local inactive_sections = {
        lualine_a = {
          {
            filename_location,
            path = 1,
            shorting_target = 60,             -- Space to __leave__ within the window
          }
        },

        lualine_b = {
          {
            "filetype",
            icons_enabled = true,
            -- icon_only = true,
          }
        },

        lualine_c = {},

        lualine_x = {},

        lualine_y = {
          "diagnostics",
        },

      }

      return {
        sections = sections,
        inactive_sections = inactive_sections,
      }
    end,
  },

  -- TODO: Finish setting up (https://github.com/stevearc/dressing.nvim)
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    ops = {
    },
  },

  -- Minimalistic UI for notifications, defaulting to bottom right corner -- https://github.com/j-hui/fidget.nvim
  -- folke/noice.nvim has a similar feature builtin
  -- { "j-hui/fidget.nvim", }

  -- TODO: Finish setting up (https://github.com/folke/noice.nvim)
  {
    "folke/noice.nvim",
    enabled = false,

    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      -- `nvim-notify` is only needed, if you want to use the notification view. If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
    },

    event = "VeryLazy",

    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,           -- requires hrsh7th/nvim-cmp
        },
      },
      -- add any options here
      -- routes = {
      -- {
      -- filter = {
      -- event = 'msg_show',
      -- any = {
      -- { find = '%d+L, %d+B' },
      -- { find = '; after #%d+' },
      -- { find = '; before #%d+' },
      -- { find = '%d fewer lines' },
      -- { find = '%d more lines' },
      -- },
      -- },
      -- opts = { skip = true },
      -- }
      -- {
      -- filter = {
      -- event = "lsp",
      -- kind = "progress",
      -- cond = function(message)
      -- local client = vim.tbl_get(message.opts, "progress", "client")
      -- return client == "lua_ls"
      -- end,
      -- },
      -- opts = { skip = true },
      -- },
      -- },

      views = {
        cmdline_popup = {
          -- position = {
          -- row = "14%",
          -- col = "50%",
          -- },
          size = {
            width = "60%",
            height = "auto",
          },
          border = {
            -- style = "solid",
            padding = { 0, 0 },
          },
          text = {
            top = "Popup Title",
            top_align = "center",
          },
          -- filtering_options = {},
          win_options = {
            -- Causes the popup to have the lighter BG color, versus matching the dark BG color of the cmdline
            -- winhighlight = "NormalFloat:NormalFloat,FloatBorder:FloatBorder",
          },
        },

        -- popupmenu = {
        -- relative = "editor",
        -- position = {
        -- row = "95%",
        -- col = "50%",
        -- },
        -- size = {
        -- width = "60%",
        -- height = 10,
        -- },
        -- border = {
        -- style = "none",
        -- padding = { 0, 0 },
        -- },
        -- win_options = {
        -- winhighlight = {
        -- Normal = "Normal",
        -- FloatBorder = "DiagnosticInfo",
        -- },
        -- },
        -- },
      },

      presets = {
        bottom_search = true,                 -- use a classic bottom cmdline for search
        command_palette = true,               -- position the cmdline and popupmenu together
        long_message_to_split = true,         -- long messages will be sent to a split
        lsp_doc_border = true,                -- add a border to hover docs and signature help
      },
    },
  },

  -- Highlighting & searching for TODO, HACK, BUG, FIX, etc.
  -- TODO: Finish setting up (https://github.com/folke/todo-comments.nvim)
  {
    "folke/todo-comments.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local todo_comments = require("todo-comments")
      vim.keymap.set("n", "[t", todo_comments.jump_next, { desc = "Next todo comment" })
      vim.keymap.set("n", "]t", todo_comments.jump_prev, { desc = "Previous todo comment" })
      todo_comments.setup()
    end,
  },

  -- Trouble
  -- TODO: Finish setting up (https://github.com/folke/trouble.nvim)
}
