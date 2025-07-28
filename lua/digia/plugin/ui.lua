return {

  --
  -- Tokyonight
  --
  --
  -- Tokyonight "Storm" Theme
  -- https://github.com/catppuccin/nvim
  {
    "folke/tokyonight.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("tokyonight").setup({
        style = "storm", -- storm, day, night, moon
        transparent = false, -- Enable transparent background
        terminal_colors = true, -- Enable terminal colors
        styles = {
          keywords = {
            italic = false,
          },
          floats = "normal",
        },

        on_colors = function(colors)
          colors.hint = colors.warning
        end,

        on_highlights = function(hl, c)
          --
          -- Telescope highlights
          --

          hl.TelescopePromptBorder = { fg = c.border_highlight }
          hl.TelescopePromptTitle = { fg = c.bg_highlight }

          --
          -- TODO highlights
          --

          -- Native Neovim TODO (non-Tree-sitter)
          -- hl.Todo = { bg = c.magenta2, fg = c.white } -- Captures eyes a bit too much
          hl.Todo = { bg = c.bg_highlight, fg = c.magenta2 } -- Less distracting, though still noticeable

          -- Tree-sitter comment highlights
          -- hl["@comment.todo"] = { bg = c.magenta2, fg = c.white }
          hl["@comment.todo"] = { bg = c.bg_highlight, fg = c.magenta2 }
          hl["@comment.note"] = { bg = c.bg_highlight, fg = c.hint }
          hl["@comment.warning"] = { bg = c.bg_highlight, fg = c.warning }
          hl["@comment.error"] = { bg = c.bg_highlight, fg = c.error }
        end,
      })

      vim.cmd.colorscheme("tokyonight")
    end,
    enabled = true,
  },

  --
  -- Catppuccino
  --

  -- Catppuccin "Macchiato" Theme
  -- https://github.com/catppuccin/nvim
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require("catppuccin").setup({
        flavour = "macchiato", -- latte, frappe, macchiato, mocha
        styles = {
          conditionals = {
            -- Disables italics for conditionals
          },
        },

        -- Expand the default integrations
        integrations = {
          telescope = true, -- telescope.nvim
        },
      })

      vim.cmd.colorscheme("catppuccin")
    end,
    enabled = false,
  },


  --
  -- Nord
  --

  {
    "nordtheme/vim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      vim.cmd.colorscheme("nord")
    end,
    enabled = false,
  },

  ---
  --- Solarized
  ---

  -- https://github.com/svrana/neosolarized.nvim
  -- - Easier on the eyes as the whites are not as bright
  -- Tweaks (treesitter highlighting):
  -- - Adds a lot of orange (arguments, (), {}, html, etc.)
  {
    "svrana/neosolarized.nvim",
    lazy = false,    -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    dependencies = {
      "tjdevries/colorbuddy.nvim",
    },
    config = function()
      require("neosolarized").setup({
        comment_italics = true,
        background_set = false,
      })
      vim.cmd.colorscheme("neosolarized")

      -- TODO: Discover tool to make theme tweaking easier
      -- TODO: Tweak theme to desire
      -- sol.Group.link("WarningMsg", sol.groups.Comment)
      -- sol.Group.new("WarningMsg", sol.groups.Comment, sol.groups.Comment, sol.groups.Comment)

      -- sol.Group.link("DiagnosticHint", sol.groups.Comment)
      -- sol.Group.new("DiagnosticHint", sol.colors.green)
      -- sol.Group.new("DiagnosticVirtualTextHint", sol.colors.Comment)

      -- sol.Group.new("@variable.builtin", sol.colors.white)
      -- sol.Group.new("@variable.parameter.builtin", sol.colors.white)
      -- sol.Group.new("@lsp.type.parameter", sol.colors.white)

      -- For avante.tokenizers and templates to work
      require("avante_lib").load()
    end,
    enabled = false,
  },

  "tjdevries/colorbuddy.nvim",

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = function(ctx)
        -- TODO: Adjust the delay for which-key
        return ctx.plugin and 0 or 1250
      end,
    },
  },

  -- TODO: Archived plugin, migrate to https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-indentscope.md
  { "Yggdroot/indentLine" }, -- Visual line indention

  -- TODO: Configure indent-blankline (https://github.com/lukas-reineke/indent-blankline.nvim)
  -- {
  -- "lukas-reineke/indent-blankline.nvim",
  -- event = { "BufReadPre", "BufNewFile" },
  -- main = "ibl", -- Lua module name is "ibl" not "indent-blankline"
  -- opts = {
  -- indent = { char = "┊" },
  -- },
  -- },

  {
    "MeanderingProgrammer/render-markdown.nvim",
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

      -- Show the active LSP clients, including the AI assistant (claude, copilot, etc.)
      local active_lsp_clients = function()
        local clients = vim.lsp.get_active_clients()
        if next(clients) == nil then
          return ""
        end
        local client_names = {}
        for _, client in pairs(clients) do
          table.insert(client_names, client.name)
        end
        return table.concat(client_names, ", ")
      end

      local not_avante_filetype = function()
        local ft = vim.bo.filetype
        return not string.match(ft, "^Avante")
      end

      local filename_section = {
        "filename",
        path = 1,
        shorting_target = 80, -- Space to __leave__ within the window
        cond = not_avante_filetype
        -- Maybe, add on_click to open the file directory in either finder or a terminal
        -- on_click = function() end
      }

      local filetype_section = { "filetype", icons_enabled = false }
      local lsp_clients_section = { active_lsp_clients, cond = not_avante_filetype }
      local navic_section = { "navic" }
      local diagnostics_section = { "diagnostics" }

      local sections = {
        lualine_a = {
          filename_section,
        },

        lualine_b = {
          filetype_section,
        },

        lualine_c = {
          -- lsp_clients_section, -- Might be too much unnecessary information on display at all times (2024-12-04)
        },

        lualine_x = {
          navic_section
        },

        lualine_y = {
          diagnostics_section,
        },

        lualine_z = {},
      }

      local inactive_sections = {
        lualine_a = {
          filename_section,
        },

        lualine_b = {
          filetype_section,
        },

        lualine_c = {
          -- lsp_clients_section, -- Might be too much unnecessary information on display at all times (2024-12-04)
        },

        lualine_x = {
          navic_section,
        },

        lualine_y = {
          diagnostics_section,
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
          ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
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
        bottom_search = true,         -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        lsp_doc_border = true,        -- add a border to hover docs and signature help
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
      require("todo-comments").setup({
        signs = false, -- Don't show signs within the signs column

        highlight = {
          keyword = "wide",
          after = "",
        },

        keywords = {
          PERF = {
            alt = { "ENHANCEMENT", },
          },
        }
      })

      -- Set up keymaps after plugin is loaded
      local todo_comments = require("todo-comments")
      vim.keymap.set("n", "]t", todo_comments.jump_next, { desc = "Next TODO comment" })
      vim.keymap.set("n", "[t", todo_comments.jump_prev, { desc = "Previous TODO comment" })
    end,
    enabled = true,
  },

  -- Trouble
  -- TODO: Finish setting up (https://github.com/folke/trouble.nvim)
}
