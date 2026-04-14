return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    -- main branch does not support lazy-loading; parsers must be on rtp before BufRead
    lazy = false,
    build = ":TSUpdate",

    config = function()
      local ts = require("nvim-treesitter")

      ts.setup({
        -- default install_dir: vim.fn.stdpath("data") .. "/site"
      })

      local parsers = {
        "bash", "c", "csv", "diff", "dockerfile", "elixir", "heex", "eex",
        "go", "html", "htmldjango", "java", "javascript", "jq", "jsdoc",
        "json", "json5", "lua", "luadoc", "luap", "markdown",
        "markdown_inline", "php", "printf", "python", "query", "regex",
        "sql", "tmux", "toml", "tsx", "typescript", "vim", "vimdoc", "xml",
        "yaml", "astro", "terraform"
      }

      -- Replaces `ensure_installed` + `auto_install`. Async; no-op if installed.
      ts.install(parsers)

      -- Parser name -> filetype(s). Most parsers match their filetype directly;
      -- list only the divergences (injection-only parsers and renamed filetypes).
      local parser_to_ft = {
        markdown_inline = {}, -- injection-only
        luap            = {}, -- injection-only
        luadoc          = {}, -- injection-only
        jsdoc           = {}, -- injection-only
        printf          = {}, -- injection-only
        regex           = {}, -- injection-only
        query           = { "query" },
        vimdoc          = { "help" },
        tsx             = { "typescriptreact" },
      }

      local filetypes = {}
      for _, p in ipairs(parsers) do
        local fts = parser_to_ft[p]
        if fts == nil then
          table.insert(filetypes, p)
        else
          for _, ft in ipairs(fts) do table.insert(filetypes, ft) end
        end
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("digia.treesitter", { clear = true }),
        pattern = filetypes,
        callback = function(args)
          pcall(vim.treesitter.start, args.buf)
          vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          -- Folding handled globally via lua/digia/options.lua +
          -- lua/digia/util/folding.lua (lazy-detects parser, foldlevelstart=99).
        end,
      })
    end,
  },

  -- nvim-ts-autotag configures itself now; split out of the treesitter config.
  {
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
