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
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
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

        -- local function imap(keys, func, desc)
        --   local opts = { buffer = bufnr, desc = lsp_desc(desc) }
        --   Remap.inoremap(keys, func, opts)
        -- end

        nmap("gd", vim.lsp.buf.definition) -- gd to stick with Vim's gd (:h gd)
        nmap("K", vim.lsp.buf.hover)       -- K to stick with Vim's <Shift-k> (:h K)

        -- TODO: Understand why `v` is used as the prefix here...
        nmap("<leader>vs", vim.lsp.buf.workspace_symbol)
        nmap("<leader>vd", vim.diagnostic.open_float)
        nmap("<leader>vr", vim.lsp.buf.references)
        nmap("<leader>vh", vim.lsp.buf.signature_help) -- Necessary with `K`?

        nmap("]d", vim.diagnostic.goto_next)
        nmap("[d", vim.diagnostic.goto_prev)

        -- Actions

        -- Run Actions (WIP/TESTING)
        nmap("<leader>rn", vim.lsp.buf.rename)      -- [R]un re[N]ame
        nmap("<leader>rc", vim.lsp.buf.code_action) -- [R]un [C]ode Action
        nmap("<leader>rf", vim.lsp.buf.format)      -- [R]un [F]ormat file

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
          -- "basedpyright",
          "html",
          "cssls",
          "yamlls",
          "tailwindcss",
          "bashls",
          "jsonls",
          "dockerls",
          "phpactor",
          "gopls",
          "elixirls",
        },

        handlers = {
          function(server_name) -- default handler (optional)
            lspconfig[server_name].setup(config_base)
          end,

          elixirls = function()
            local elixir_opts = build_config({
              cmd = { "/Users/digia/.local/share/nvim/mason/bin/elixir-ls" },
            })
            lspconfig.elixirls.setup(elixir_opts)
          end,

          pyright = function()
            local pyright_opts = build_config({ enabled = true, })
            lspconfig.pyright.setup(pyright_opts)
          end,

          -- basedpyright = function()
          --   local basedpyright_opts = build_config({ enabled = true, })
          --   lspconfig.basedpyright.setup(basedpyright_opts)
          -- end,

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
        virtual_text = true,
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
