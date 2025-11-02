--
-- Plugins which don't fit into any specific category
--
return {
  { "nvim-lua/plenary.nvim", name = "plenary" },

  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,

    ---@type snacks.Config
    opts = {
      -- https://github.com/folke/snacks.nvim/blob/main/docs/bigfile.md
      bigfile = {
        enabled = true,
      },

      -- Enabled 2025-11-01: replacing vim-bufkill
      bufdelete = { enabled = true },

      -- https://github.com/folke/snacks.nvim/blob/main/docs/debug.md
      debug = {
        enabled = true,
      },

      -- https://github.com/folke/snacks.nvim/blob/main/docs/indent.md
      -- Enabled 2025-11-01: replacing Yggdroot/indentLine
      indent = {
        enabled = true,
        indent = {
          -- char = "┆",
          char = "╎", -- Subtle broken line with gaps
          only_scope = false, -- Show all indent guides, not just current scope
        },
        animate = {
          enabled = false, -- No animation, just subtle lines
        },
        scope = {
          enabled = false, -- Don't highlight current scope specially
        },
      },

      -- https://github.com/folke/snacks.nvim/blob/main/docs/dim.md
      dim = { enabled = false },

      -- https://github.com/folke/snacks.nvim/blob/main/docs/explorer.md
      explorer = {
        enabled = true,
      },

      -- https://github.com/folke/snacks.nvim/blob/main/docs/gitbrowse.md
      gitbrowse = {
        enabled = true,
      },

      -- https://github.com/folke/snacks.nvim/blob/main/docs/quickfile.md
      quickfile = {
        enabled = true,
      },

      -- https://github.com/folke/snacks.nvim/blob/main/docs/rename.md
      rename = {
        enabled = true,
      },

      -- https://github.com/folke/snacks.nvim/blob/main/docs/scratch.md
      scratch = {
        enabled = true,
      },
    },

    keys = {
      -- Explorer
      { "<leader>fe", function() Snacks.explorer() end, desc = "File Explorer" },

      -- Gitbrowse
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },

      -- Rename
      { "<leader>frn", function() Snacks.rename.rename_file() end, desc = "Rename File" },

      -- Scratch
      { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    },

    init = function()
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
          -- Setup some globals for debugging (lazy-loaded)
          _G.dd = function(...)
            Snacks.debug.inspect(...)
          end
          _G.bt = function()
            Snacks.debug.backtrace()
          end
          vim.print = _G.dd -- Override print to use snacks for `:=` command

          -- Create :BD command for buffer deletion (replaces vim-bufkill)
          vim.api.nvim_create_user_command("BD", function()
            Snacks.bufdelete()
          end, { desc = "Delete buffer without closing split" })

          -- Create some toggle mappings
          Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
          Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
          Snacks.toggle.diagnostics():map("<leader>ud")
          Snacks.toggle.inlay_hints():map("<leader>uh")

          -- Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
          -- Snacks.toggle.line_number():map("<leader>ul")
          -- Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
          -- Snacks.toggle.treesitter():map("<leader>uT")
          -- Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
          -- Snacks.toggle.indent():map("<leader>ug")
          -- Snacks.toggle.dim():map("<leader>uD")
        end,
      })
    end,

    enabled = true,
  },
}
