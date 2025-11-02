-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/plugins/extras/editor/telescope.lua
return {
  "nvim-telescope/telescope.nvim",

  tag = "0.1.8",

  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "nvim-telescope/telescope-ui-select.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },

  cmd = "Telescope",
  lazy = true,

  -- NOTE: Assuming this overrides what's defined within the defaults, though need to confirm
  keys = {
    -- Buffer
    { "<leader>/",   "<cmd>Telescope current_buffer_fuzzy_find<cr>",                desc = "Search Buffer" },

    -- Files
    { "<leader>f/",  "<cmd>Telescope live_grep<cr>",                                desc = "Search Workspace" },
    { "<leader>fp",  "<cmd>Telescope find_files<cr>",                               desc = "Find Files" },
    { "<leader>fP",  function() require("telescope.builtin").find_files({ find_command = { "rg", "--files", "--color", "never", "--no-ignore", "--hidden", "-g", "!.git" } }) end, desc = "Find Files (All)" },
    { "<leader>fg",  "<cmd>Telescope git_files<cr>",                                desc = "Find Files (git)" },
    { "<leader>fr",  "<cmd>Telescope oldfiles<cr>",                                 desc = "Recent Files" }, -- Previously opened files

    -- Search Utilities
    { "<leader>sr",  "<cmd>Telescope resume<cr>",                                   desc = "Resume" },

    -- Search
    { "<leader>ss",  "<cmd>Telescope lsp_document_symbols<cr>",                     desc = "Document Symbols" },
    { "<leader>sS",  "<cmd>Telescope lsp_workspace_symbols<cr>",                    desc = "Workspace Symbols" },
    { "<leader>sb",  "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "Buffers", },
    { "<leader>sgc", "<cmd>Telescope git_commits<CR>",                              desc = "Git Commits" },
    { "<leader>sgs", "<cmd>Telescope git_status<CR>",                               desc = "Git Status" },
    { "<leader>sR",  "<cmd>Telescope registers<cr>",                                desc = "Registers" },
    { "<leader>sa",  "<cmd>Telescope autocommands<cr>",                             desc = "Auto Commands" },
    { "<leader>sc",  "<cmd>Telescope command_history<cr>",                          desc = "Command History" },
    { "<leader>sC",  "<cmd>Telescope commands<cr>",                                 desc = "Commands" },
    { "<leader>sh",  "<cmd>Telescope help_tags<cr>",                                desc = "Help Pages" },
    { "<leader>sH",  "<cmd>Telescope highlights<cr>",                               desc = "Search Highlight Groups" },
    { "<leader>sj",  "<cmd>Telescope jumplist<cr>",                                 desc = "Jumplist" },
    { "<leader>sk",  "<cmd>Telescope keymaps<cr>",                                  desc = "Key Maps" },
    { "<leader>sl",  "<cmd>Telescope loclist<cr>",                                  desc = "Location List" },
    { "<leader>sM",  "<cmd>Telescope man_pages<cr>",                                desc = "Man Pages" },
    { "<leader>sm",  "<cmd>Telescope marks<cr>",                                    desc = "Jump to Mark" },
    { "<leader>so",  "<cmd>Telescope vim_options<cr>",                              desc = "Options" },
    { "<leader>sq",  "<cmd>Telescope quickfix<cr>",                                 desc = "Quickfix List" },
    { "<leader>sw",  "<cmd>Telescope grep_string word_match=-w<cr>",                desc = "Word (Root Dir)" },
    { "<leader>sW",  "<cmd>Telescope grep_string root=false word_match=-w<cr>",     desc = "Word (cwd)" },
    -- TODO: Investigate why mode = "v" doesn't work
    -- { "<leader>sw", "<cmd>Telescope grep_string<cr>", mode = "v", desc = "Selection (Root Dir)" },
    -- { "<leader>sW", "<cmd>Telescope grep_string root=false<cr>", mode = "v", desc = "Selection (cwd)" },
  },

  -- TODO: Confirm that load_extension is happening without this...
  -- config = function()
  -- local telescope = require("telescope")
  -- telescope.setup({
  -- extensions = {
  -- fzf = {
  -- -- override_generic_sorter = false,
  -- },

  -- fzy_native = {
  -- override_generic_sorter = false,
  -- override_file_sorter = true,
  -- },
  -- }
  -- })
  -- -- telescope.load_extension('fzy_native')
  -- telescope.load_extension("fzf")
  -- end,

  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    local mappings = {
      i = {
        ["<C-Down>"] = actions.cycle_history_next,
        ["<C-Up>"] = actions.cycle_history_prev,
        ["<C-f>"] = actions.preview_scrolling_down,
        ["<C-b>"] = actions.preview_scrolling_up,

        -- TODO: Figure out ideal mapping for quickfix
        ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
      },

      n = {
        ["<C-c>"] = actions.close,
      },
    }

    telescope.setup({
      defaults = {
        -- path_display = { "smart" },

        prompt_prefix = " ",
        -- selection_caret = " ",
        selection_caret = " ",

        mappings = mappings,

        color_devicons = true,

        -- open files in the first window that is an actual file.
        -- use the current window if no other window is available.
        get_selection_window = function()
          local wins = vim.api.nvim_list_wins()
          table.insert(wins, 1, vim.api.nvim_get_current_win())
          for _, win in ipairs(wins) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.bo[buf].buftype == "" then
              return win
            end
          end
          return 0
        end,
      },

      pickers = {
        find_files = {
          find_command = { "rg", "--files", "--color", "never", "-g", "!.git" },
          -- NOTE: Prev, when not a git repo
          -- find_command = { "rg", "--smart-case", "--files", "--hidden", "--follow", "--ignore", },
          hidden = true,
        },
      },

      extensions = {
        fzf = {
          -- override_generic_sorter = false,
        },

        ["ui-select"] = {
        },
      },

    })

    --- Load telescope extensions
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
  end,
}
