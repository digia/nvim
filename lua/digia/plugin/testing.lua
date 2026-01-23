return {
  -- Neotest: Extensible test runner framework
  --
  -- Tmux Strategy: Not built-in natively, but the strategy system is extensible.
  -- See GitHub discussion #473 - someone already built a custom tmux strategy.
  -- Alternative: Create a custom consumer that routes output to a tmux pane.
  -- The integrated strategy (PTY within Neovim) works well for now.
  -- If tmux integration is needed later, implement neotest.Strategy interface:
  --   - output() -> path to output file
  --   - is_complete() -> boolean
  --   - result() -> async exit code
  --   - attach() -> attach to process
  --   - stop() -> kill process
  {
    "nvim-neotest/neotest",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- Adapters
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-python",
      "jfpedroza/neotest-elixir",
      { "thenbe/neotest-playwright", dependencies = "nvim-telescope/telescope.nvim" },
    },

    keys = {
      { "<leader>t", nil, desc = "Test" },
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file" },
      { "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run all tests" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run last test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop test" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle watch" },
    },

    opts = function()
      return {
        adapters = {
          require("neotest-vitest")({
            -- Uses vitest.config.* by default
            -- vitestCommand = "pnpm exec vitest",  -- Optional override
          }),
          require("neotest-python")({
            -- Auto-detects venv, pdm, poetry, pipenv
            dap = { justMyCode = false },
            runner = "pytest",
            -- python = ".venv/bin/python",  -- Optional override
          }),
          require("neotest-elixir")({
            -- mix_task = "test.interactive",  -- For watch mode with mix_test_interactive
            args = { "--trace" },  -- Show test execution trace
          }),
          require("neotest-playwright").adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
              -- preset = "headed",  -- Options: "none", "headed", "debug"
            },
          }),
        },
        status = {
          virtual_text = true,
          signs = true,
        },
        output = {
          open_on_run = "short",
        },
        quickfix = {
          open = false,  -- Don't auto-open quickfix
        },
      }
    end,
  },
}
