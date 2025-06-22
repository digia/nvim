return {
  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>gs", "<cmd>Git<cr>" },
      { "<leader>gd", "<cmd>Git diff<cr>" },
      { "<leader>gc", "<cmd>Git commit<cr>" },
      { "<leader>gb", "<cmd>Git blame<cr>" },
      { "<leader>gl", "<cmd>Git log<cr>" },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    config = function()
      require("gitsigns").setup({
        on_attach = function(bufnr)
          local gitsigns = require("gitsigns")

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]g", function()
            if vim.wo.diff then
              vim.cmd.normal({ "]c", bang = true })
            else
              gitsigns.nav_hunk("next")
            end
          end, { desc = "Next git change" })

          map("n", "[g", function()
            if vim.wo.diff then
              vim.cmd.normal({ "[c", bang = true })
            else
              gitsigns.nav_hunk("prev")
            end
          end, { desc = "Previous git change" })
        end,
      })
    end,
  },
}
