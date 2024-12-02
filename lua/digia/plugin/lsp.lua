local Remap = require("digia.util.remap")


local function lsp_desc(desc)
  if not desc then
    return desc
  end
  return "LSP: " .. desc
end

return {
  { "onsails/lspkind.nvim" },
  { "sheerun/vim-polyglot" },

  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = false,     -- set this if you want to always pull the latest change

    opts = {
      -- add any opts here
    },

    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
      "stevearc/dressing.nvim",
      "nvim-lua/plenary.nvim",
      "MunifTanjim/nui.nvim",

      --- The below dependencies are optional,
      "hrsh7th/nvim-cmp",                  -- autocompletion for avante commands and mentions
      "nvim-tree/nvim-web-devicons",       -- or echasnovski/mini.icons
      "zbirenbaum/copilot.lua",            -- for providers='copilot'

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

      -- {
      -- -- Make sure to set this up properly if you have lazy=true
      -- 'MeanderingProgrammer/render-markdown.nvim',
      -- opts = {
      -- file_types = { "markdown", "Avante" },
      -- },
      -- ft = { "markdown", "Avante" },
      -- },
      -- },
    },
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local cmp_lsp = require("cmp_nvim_lsp")
      local lspconfig = require("lspconfig")
      local navic = require("nvim-navic")

      local capabilities_base = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        cmp_lsp.default_capabilities()
      )

      local function on_attach(client, bufnr)
        local function nmap(keys, func, desc)
          local opts = { buffer = bufnr, desc = lsp_desc(desc) }
          Remap.nmap(keys, func, opts)
        end

        local function imap(keys, func, desc)
          local opts = { buffer = bufnr, desc = lsp_desc(desc) }
          Remap.inoremap(keys, func, opts)
        end

        nmap("gd", vim.lsp.buf.definition)
        -- Using "v" prefix due to it being a "visual" action -- e.g. it opens a split pane
        -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        nmap("K", vim.lsp.buf.hover)
        nmap("<leader>vws", vim.lsp.buf.workspace_symbol)
        nmap("<leader>vd", vim.diagnostic.open_float)
        nmap("<leader>vca", vim.lsp.buf.code_action)
        nmap("<leader>vrr", vim.lsp.buf.references)
        nmap("<leader>vrn", vim.lsp.buf.rename)
        -- nmap("<C-h>", vim.lsp.buf.signature_help) -- Overrides window movement,though is it necessary with `K`?
        nmap("[d", vim.diagnostic.goto_next)
        nmap("]d", vim.diagnostic.goto_prev)
        nmap("<leader>f", vim.lsp.buf.format)

        -- Testing bindings from ThePrimeagen (2022-10-23, 2024-12-01)
        -- imap("<C-h>", vim.lsp.buf.signature_help) -- (?)

        -- Attach navic for code context
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
      end

      local config_base = {
        capabilities = capabilities_base,
        on_attach = on_attach,
      }

      local function build_config(config)
        return vim.tbl_deep_extend("force", {}, config_base, config or {})
      end

      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",
          "rust_analyzer",
          "gopls",
          "ts_ls",
          "pyright",
          "html",
          "cssls",
          "yamlls",
          "tailwindcss",
          "bashls",
          "jsonls",
          "dockerls",
          "phpactor",
          "gopls",
        },

        handlers = {
          function(server_name)           -- default handler (optional)
            lspconfig[server_name].setup(config_base)
          end,

          pyright = function()
            local pyright_opts = build_config({ enabled = true, })
            lspconfig.pyright.setup(pyright_opts)
          end,

          ["lua_ls"] = function()
            local lua_config = build_config({
              settings = {
                Lua = {
                  runtime = { version = "Lua 5.1" },
                  diagnostics = {
                    globals = {
                      "bit",
                      "vim",
                      "it",
                      "describe",
                      "before_each",
                      "after_each",
                    },
                  },
                  telemetry = { enable = false },
                }
              }
            })
            lspconfig.lua_ls.setup(lua_config)
          end,
        }
      })

      vim.diagnostic.config({
        -- update_in_insert = true,
        float = {
          focusable = false,
          style = "minimal",
          border = "rounded",
          source = "always",
          header = "",
          prefix = "",
        },
      })
    end,
  },
}
