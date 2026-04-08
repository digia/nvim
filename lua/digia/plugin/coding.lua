--
-- Plugins related to coding, completion, and other coding utilities
--
return {
  -- Replaced 2025-11-01: snacks.bufdelete handles this now
  -- { "qpkorr/vim-bufkill" },        -- Killing buffers without loosing split
  { "benizi/vim-automkdir" },      -- Automatically create missing directories when saving
  -- Replaced 2025-11-01: mini.splitjoin is more modern
  -- { "AndrewRadev/splitjoin.vim" }, -- Better support for joins (gS, gJ)

  -- TODO: Silence tpope/unimpaired commands from showing within cmdline
  { "tpope/vim-unimpaired" }, -- [<Space>, ]<Space>, [u, ]u, [f, ]f, [e, ]e

  { "tpope/vim-repeat" },     -- Repeat more than native commands
  -- { "tpope/vim-dispatch" },   -- Dispatch async tasks
  -- { "tpope/vim-surround" },   -- cs'"

  { "echasnovski/mini.ai", version = "*", config = true, }, -- Adds vaf, vif, caf, cif, etc.
  { "echasnovski/mini.surround", version = "*", config = true, }, -- TEST: Potential replacement for tpop/vim-surround
  { "echasnovski/mini.bracketed", version = "*", config = true, }, -- Navigate with []
  { "echasnovski/mini.splitjoin", version = "*", config = true, }, -- Better support for joins (gS, gJ)

  -- TODO: https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-move.md

  -- TODO: Investigate if the oil plugin is something that would be useful
  -- https://github.com/stevearc/oil.nvim

  --
  -- Completion
  --

  -- cmp-dotenv: cmp import and use all environment variables from .env.* and system
  -- https://github.com/SergioRibera/cmp-dotenv
  {
    "SergioRibera/cmp-dotenv",
    lazy = false,
    priority = 999,

    -- NOTE: Doesn't configure nivm-cmp, instead it sets sensitive env variables set within the ~/.config/nvim/.env
    -- file. Within this config because it uses the load utility to parse the environment file.
    config = function()
      local dotenv_load = require("cmp-dotenv.load")

      local env_path = vim.fn.expand("~/.config/nvim/.env")
      local env_file, _ = io.open(env_path, "r")
      if env_file == nil then
        local msg = "Unable to load nvim .env file, assistant/completion plugins may not work."
            .. " Ensure the necessary environment variables are populated within: "
            .. env_path
        print(msg)
        return
      end

      local env_content = dotenv_load.load_data_from_text(env_file:read("*a"))
      env_file:close()

      for var_name, v in pairs(env_content) do
        vim.env[var_name] = v.value
      end
    end
  },

  -- Emmet for HTML/CSS abbreviation expansion
  { "mattn/emmet-vim" },

  -- nvim-cmp: A completion plugin for neovim coded in Lua
  -- https://github.com/hrsh7th/nvim-cmp
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

      "saadparwaiz1/cmp_luasnip",           -- For autocompletion
      "rafamadriz/friendly-snippets",       -- Useful snippets
      "SergioRibera/cmp-dotenv",            -- Source from .env* files
      "lukas-reineke/cmp-under-comparator", -- Better completion sorting for languages which use dunder (__)
    },

    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

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

        sorting = {
          -- Config from `cmp-under-comparator`
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require("cmp-under-comparator").under,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },

        -- TODO: Investigate why <C-e> isn't fluid when suggestion & completion are present
        mapping = cmp.mapping.preset.insert({
          -- ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-Tab>"] = cmp.mapping.complete(),

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

        sources = cmp.config.sources(
          {
            { name = "nvim_lsp" },
            { name = "luasnip" }, -- Snippets
            { name = "buffer" },  -- Text within the current buffer
            { name = "path" },    -- File system paths

            -- .env* files
            {
              name = "dotenv",
              option = {
                path = ".",
              },
            },
          }

        -- Fallback groups when the above sources are exhausted
        -- {}
        )
      })
    end

  },

  -- TODO: Configure goto-preview (https://github.com/rmagatti/goto-preview)
  {
    "rmagatti/goto-preview",
    lazy = true,
    event = "VeryLazy",

    -- keys = {
    --   { "<C-h>", "<C-w>w", },
    --   {
    --     "P",
    --     function()
    --       require("goto-preview").goto_preview_definition({ focus_on_open = false, dismiss_on_move = true })
    --     end,
    --     { noremap = true, desc = "Peek Definition" },
    --   },
    -- },

    opts = function()
      -- Dev's configurations: https://github.com/rmagatti/dotfiles/blob/master/nvim/lua/rmagatti/goto-preview.lua
      local preview_mapping = function(wincmd_direction, bufnr)
        local function close()
          vim.cmd("wincmd " .. wincmd_direction)
          require("goto-preview").close_all_win({ skip_curr_window = true })
          -- vim.lsp.buf.definition()
        end

        vim.keymap.set("n", "<C-w>" .. wincmd_direction, close, {
          noremap = true,
          silent = true,
          buffer = bufnr,
        })
      end

      -- Mapping to cycle between windows
      -- vim.keymap.set("n", "<C-h>", "<C-w>w")

      -- "Peek" mapping
      -- vim.keymap.set(
      --   "n",
      --   "L", -- for "look"
      --   function()
      --     require("goto-preview").goto_preview_definition { focus_on_open = false, dismiss_on_move = true }
      --   end,
      --   { noremap = true }
      -- )

      return {
        default_mappings = true,
        resizing_mappings = true,
        post_open_hook = function(bufnr)
          preview_mapping("H", bufnr)
          preview_mapping("J", bufnr)
          preview_mapping("K", bufnr)
          preview_mapping("L", bufnr)
        end,
      }
    end,
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
    enabled = false,
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
          -- accept = "<M-p>",
          accept = "<C-e>", -- [E]xpand the suggestion, similar to <C-e> within the terminal
          -- prev = "<M-[>",
          prev = "<C-[>",
          -- next = "<M-]>",
          next = "<C-]>",
          -- dismiss = "<C-]>",
          dismiss = "<C-\\>",
        },
      },
    },
    -- config = function()
    --   require("copilot").setup({})
    -- end,
    -- enabled = false,
  },

  -- Claude Code integration - primary context-aware Claude instance in nvim
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },

    opts = {
      terminal_cmd = "/Users/digia/.claude/local/node_modules/.bin/claude",

      terminal = {
        split_side = "left",
        split_width_percentage = 0.27,
      },
    },

    config = function(_, opts)
      require("claudecode").setup(opts)

      -- Set keybind for hiding Claude terminal
      vim.api.nvim_create_autocmd("TermOpen", {
        pattern = "term://*claude*",
        callback = function()
          -- Set buffer name
          vim.api.nvim_buf_set_name(0, "Claude Code")

          -- Store original width for toggling
          local original_width = nil

          -- Keymap to hide terminal - Mirror standard window closing behavior
          vim.keymap.set("t", "<C-w>q", "<C-\\><C-n>:hide<CR>", {
            buffer = true,
            noremap = true,
            silent = true,
            desc = "Hide Claude terminal"
          })

          -- Keymap to toggle terminal width between max and original
          vim.keymap.set("t", "<C-w>|", function()
            local current_width = vim.api.nvim_win_get_width(0)
            local max_width = vim.o.columns

            if current_width >= max_width - 5 then
              -- Currently maximized, restore original
              if original_width then
                vim.cmd("normal! " .. original_width .. "\030|")
              end
            else
              -- Not maximized, save current and maximize
              original_width = current_width
              vim.cmd("normal! \030|")
            end
          end, {
            buffer = true,
            noremap = true,
            silent = true,
            desc = "Toggle Claude terminal width"
          })

          -- Keymap to switch focus back to claudecode session from normal mode
          vim.keymap.set("n", "<CR>", "i", {
            buffer = true,
            noremap = true,
            silent = true,
            desc = "Activate Claude terminal"
          })

          -- Auto-copy visual selection to system clipboard on mouse release (Mirror Tmux/Terminal behavior)
          vim.keymap.set("v", "<LeftRelease>", '"+y<LeftRelease>', {
            buffer = true,
            noremap = true,
            silent = true,
            desc = "Copy selection to clipboard"
          })
        end,
      })
    end,

    keys = {
      { "<leader>a", nil, desc = "AI/Claude Code" },
      { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude" },
      { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude" },
      { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume Claude" },
      { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
      { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },
      { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer" },
      { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
      { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept diff" },
      { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Deny diff" },
    },
  },

  -- AI assistant (DISABLED - using claudecode.nvim instead)
  -- {
  --   "yetone/avante.nvim",
  --
  --   event = "VeryLazy",
  --   lazy = true,
  --   version = false, -- set this if you want to always pull the latest change
  --   -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  --   build = "make",
  --   -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  --   dependencies = {
  --     "stevearc/dressing.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "MunifTanjim/nui.nvim",
  --
  --     --- The below dependencies are optional,
  --     "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
  --     "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
  --     "zbirenbaum/copilot.lua",      -- for providers='copilot'
  --
  --     -- Uses markdown preview for responses within the AvanteAsk buffer
  --     {
  --       "MeanderingProgrammer/render-markdown.nvim",
  --       opts = {
  --         file_types = { "markdown", "Avante" },
  --       },
  --       ft = { "markdown", "Avante" },
  --     },
  --
  --     -- {
  --     -- -- support for image pasting
  --     -- "HakonHarnes/img-clip.nvim",
  --     -- event = "VeryLazy",
  --
  --     -- -- recommended settings
  --     -- opts = {
  --     -- default = {
  --     -- embed_image_as_base64 = false,
  --     -- prompt_for_file_name = false,
  --     -- drag_and_drop = { insert_mode = true },
  --     -- -- required for Windows users
  --     -- use_absolute_path = true,
  --     -- },
  --     -- },
  --     -- },
  --   },
  --
  --   opts = function()
  --     -- Check if hostname ends with .linkedin.biz
  --     local provider = "claude"
  --     if vim.fn.hostname():match("%.linkedin%.biz$") then
  --       provider = "copilot"
  --     end
  --
  --     return {
  --       hints = { enabled = false },
  --       provider = provider,
  --       auto_suggestions_provider = "copilot",
  --       behaviour = {
  --         -- auto_suggestions = true, -- Experimental stage
  --       },
  --     }
  --   end,
  --   enabled = false,
  -- },

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

  -- Formatting (TODO) https://github.com/josean-dev/dev-environment-files/blob/main/.config/nvim/lua/josean/plugins/formatting.lua
  -- return {
  -- "stevearch/conformat.nvim",
  -- }
}
