--
-- Plugins related to coding, completion, and other coding utilities
--
return {
  { "qpkorr/vim-bufkill" },        -- Killing buffers without loosing split
  { "benizi/vim-automkdir" },      -- Automatically create missing directories when saving
  { "AndrewRadev/splitjoin.vim" }, -- Better support for joins (gS, gJ)

  -- TODO: Silence tpope/unimpaired commands from showing within cmdline
  { "tpope/vim-unimpaired" }, -- [<Space>, ]<Space>, [u, ]u, [f, ]f, [e, ]e

  { "tpope/vim-repeat" },     -- Repeat more than native commands
  -- { "tpope/vim-dispatch" },   -- Dispatch async tasks
  { "tpope/vim-surround" },   -- cs'"

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    lazy = true,
    dependencies = {
      "hrsh7th/cmp-buffer", -- Source for text in buffer
      "hrsh7th/cmp-path",   -- Source for file system paths
      -- TODO: Investigate if this is ideal
      "hrsh7th/cmp-cmdline",
      {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- Install jsregexp (optional)
        build = "make install_jsregexp",
      },
      "saadparwaiz1/cmp_luasnip",     -- For autocompletion
      "rafamadriz/friendly-snippets", -- Useful snippets
    },

    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- GOTCHA:
      -- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
      require("luasnip.loaders.from_vscode").lazy_load() -- `luasnip.loaders.from_vscode.lazy_load()` breaks?

      cmp.setup({
        -- view = {
        -- LSP popup entries end up being behind the completion menu (?)
        -- entries = "native",
        -- },
        completion = {
          completeopt = "menu,menuone,preview,noselect",
        },

        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body) -- For `luasnip` users.
          end,
        },

        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),

          -- ["<Tab>"] = cmp.mapping.confirm({ select = true }), -- Confirm completion, prev
          -- Might of taken this from ThePrimeagen, not sure why else to use <C-y>...
          -- ["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Confirm completion, new (?)
          -- ["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
          ["<Tab>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),

          -- Select next/prev item in completion menu
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),

        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" }, -- Snippets
          { name = "buffer" },  -- Text within the current buffer
          { name = "path" },    -- File system paths
        }, {
        })
      })
    end

  },

  -- Autopairing
  {
    "windwp/nvim-autopairs",
    event = { "InsertEnter" },
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    config = function()
      require("nvim-autopairs").setup({
        check_ts = true,                      -- Enable treesitter
        ts_config = {
          lua = { "string" },                 -- Don't add pairs in lua string treesitter nodes
          javascript = { "template_string" }, -- Don't add pairs in javascript template string treesitter nodes
          java = false,                       -- Don't check treesitter for java
        },
      })

      -- Configure autopairs to work with cmp
      local autopairs_cmp = require("nvim-autopairs.completion.cmp")
      local cmp = require("cmp")
      cmp.event:on("confirm_done", autopairs_cmp.on_confirm_done())
    end,
  },

  -- Copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    lazy = true,
    opts = {
      filetypes = {
        sh = function()
          -- disable for .env files
          if string.match(vim.fs.basename(vim.api.nvim_buf_get_name(0)), '^%.env.*') then
            return false
          end
          return true
        end,
      },
      panel = {
        enabled = false,
        auto_refresh = true,
        keymap = {
          -- accept = "<CR>",
          accept = "<M-p>",
          jump_prev = "[[",
          jump_next = "]]",
          refresh = "gr",
          open = "<M-CR>",
        },
      },
      suggestion = {
        -- enabled = false,
        auto_trigger = true,
        keymap = {
          accept = "<M-p>",
          prev = "<M-[>",
          next = "<M-]>",
          dismiss = "<C-]>",
        },
      },
    },
    -- config = function()
    --   require("copilot").setup({})
    -- end,
    -- enabled = false,
  },

  -- AI assistant
  {
    "yetone/avante.nvim",

    event = "VeryLazy",
    lazy = true,
    version = false, -- set this if you want to always pull the latest change
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      --- The below dependencies are optional,
      "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",      -- for providers='copilot'

      --
      {
        "MeanderingProgrammer/render-markdown.nvim",
        opts = {
          file_types = { "markdown", "Avante" },
        },
        ft = { "markdown", "Avante" },
      },

      -- {
      -- -- support for image pasting
      -- "HakonHarnes/img-clip.nvim",
      -- event = "VeryLazy",

      -- -- recommended settings
      -- opts = {
      -- default = {
      -- embed_image_as_base64 = false,
      -- prompt_for_file_name = false,
      -- drag_and_drop = { insert_mode = true },
      -- -- required for Windows users
      -- use_absolute_path = true,
      -- },
      -- },
      -- },
    },

    opts = {
      hints = { enabled = false, },
    },
  },

  -- https://github.com/folke/trouble.nvim
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    lazy = true,
    keys = {
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
    opts = {}, -- for default options, refer to the configuration section for custom setup.
    enabled = false,
  },

  -- Generate text using LLM, specifically Ollama
  -- https://github.com/David-Kunz/gen.nvim
  {
    "David-Kunz/gen.nvim",
    cmd = "Gen",
    lazy = true,
    config = function()
      local gen = require("gen")
      gen.setup({
        model = "qwen2.5-coder",
        display_mode = "horizontal-split",
      })

      gen.prompts['DevOps me! (omerxx)'] = {
        prompt =
        "You are a senior devops engineer, acting as an assistant. You offer help with cloud technologies like: Terraform, AWS, kubernetes, python. You answer with code examples when possible. $input:\n$text",
        replace = true
      }
    end,
    -- enabled = false,
  }


  -- Formatting (TODO) https://github.com/josean-dev/dev-environment-files/blob/main/.config/nvim/lua/josean/plugins/formatting.lua
  -- return {
  -- "stevearch/conformat.nvim",
  -- }
}
