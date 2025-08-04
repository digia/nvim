return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",

  event = { "BufReadPre", "BufNewFile" },
  lazy = vim.fn.argc(-1) == 0,   -- load treesitter early when opening a file from the cmdline

  dependencies = {
    -- Automatically add closing tags for HTML and JSX
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

      indent = {
        enable = true,
      },

      -- Enable autotagging with windwp/nvim-ts-autotag
      -- TODO: Understand why it's not working
      autotag = {
        enable = true,
      },

      -- TODO: Refine the harsh highlighting when using treesitter
      highlight = {
        -- `false` will disable the whole extension
        -- enable = true,

        -- Name of the parser, not the filetype
        -- disable = { "tsx" },

        -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
        -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
        -- Using this option may slow down your editor, and you may see some duplicate highlights.
        -- Instead of true it can also be a list of languages
        -- additional_vim_regex_highlighting = { "markdown", },
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
    })
  end,
}
