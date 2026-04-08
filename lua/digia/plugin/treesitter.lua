return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    version = false,
    build = ":TSUpdate",

    event = { "BufReadPre", "BufNewFile" },
    -- event = "BufReadPost",
    lazy = vim.fn.argc(-1) == 0,

    dependencies = {
      "windwp/nvim-ts-autotag",
    },

    config = function()
    require("nvim-treesitter.configs").setup({
      -- A list of parser names, or "all"
      -- ensure_installed = "all",
      ensure_installed = {
        "bash",
        "c",
        "csv",
        "diff",
        "dockerfile",
        "elixir",
        "heex",
        "eex",
        "go",
        "html",
        "htmldjango",
        "java",
        "javascript",
        "jq",
        "jsdoc",
        "json",
        "json5",
        "jsonc",
        "lua",
        "luadoc",
        "luap",
        "markdown",
        "markdown_inline",
        "php",
        "printf",
        "python",
        "query",
        "regex",
        "sql",
        "tmux",
        "toml",
        "tsx",
        "typescript",
        "vim",
        "vimdoc",
        "xml",
        "yaml",
        "astro",
        -- "mdx",
      },

      -- Install parsers synchronously (only applied to `ensure_installed`)
      sync_install = false,

      -- Automatically install missing parsers when entering buffer
      -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
      auto_install = true,

      ignore_install = {},

      indent = {
        enable = true,
      },

      -- Enable autotagging with windwp/nvim-ts-autotag
      autotag = {
        enable = true,
      },

      highlight = {
        -- `false` will disable the whole extension
        enable = true,
        -- enable = false,

        -- Name of the parser, not the filetype
        -- disable = { "tsx" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        additional_vim_regex_highlighting = false,
      },

      -- Enable treesitter-based incremental selection
      -- TODO: Figure out how to use this, allowing to select nodes (words, parents, etc)
      -- incremental_selection = {
      -- enable = true,
      -- keymaps = {
      -- init_selection = "gnn",
      -- node_incremental = "grn",
      -- scope_incremental = "grc",
      -- node_decremental = "grm",
      -- },
      -- },

      modules = {},
    })
  end,
  },

  -- NOTE: Distracting within front-end as it'll show all the destructured variables
  -- {
  --   "nvim-treesitter/nvim-treesitter-context",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = { "nvim-treesitter/nvim-treesitter" },
  --   opts = {
  --     max_lines = 5,
  --   },
  -- },
}
