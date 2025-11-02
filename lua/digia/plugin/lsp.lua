local Remap = require("digia.util.remap")


local function lsp_desc(desc)
  if not desc then
    return desc
  end
  return "LSP: " .. desc
end

return {
  { "onsails/lspkind.nvim" },
  {
    "sheerun/vim-polyglot",
    init = function()
      -- Disable polyglot's elixir handling - using treesitter instead
      vim.g.polyglot_disabled = { "elixir" }
    end,
  },

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
          local opts = { buffer = bufnr, desc = lsp_desc(desc), noremap = true, silent = true }
          Remap.nmap(keys, func, opts)
        end

        -- local function imap(keys, func, desc)
        --   local opts = { buffer = bufnr, desc = lsp_desc(desc) }
        --   Remap.inoremap(keys, func, opts)
        -- end

        -- TODO: Understand why `v` is used as the prefix here...
        nmap("<leader>vs", vim.lsp.buf.workspace_symbol)
        nmap("<leader>vd", vim.diagnostic.open_float)
        nmap("<leader>vr", vim.lsp.buf.references)
        nmap("<leader>vh", vim.lsp.buf.signature_help) -- Necessary with `K`?

        nmap("]d", vim.diagnostic.goto_next)
        nmap("[d", vim.diagnostic.goto_prev)
        nmap("]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, "Next Error")
        nmap("[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, "Previous Error")

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

      local function setup_lsp(server_name, opts)
        local final_opts = vim.tbl_deep_extend("force", {}, config_base, opts or {})
        lspconfig[server_name].setup(final_opts)
      end

      local handlers_table = {
        function(server_name)
          setup_lsp(server_name)
        end,
        ["elixirls"] = function()
          setup_lsp("elixirls", {
            cmd = { "/Users/digia/.local/share/nvim/mason/bin/elixir-ls" },
            settings = {
              elixirLS = {
                dialyzerEnabled = true,
                enableTestLenses = false,
                fetchDeps = false,
                mcpEnabled = false,
                suggestSpecs = true,
              },
            },
          })
        end,
        ["pyright"] = function()
          setup_lsp("pyright", { enabled = true })
        end,
        ["lua_ls"] = function()
          setup_lsp("lua_ls", {
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                },
                workspace = {
                  library = vim.api.nvim_get_runtime_file("", true),
                  checkThirdParty = false,
                },
                telemetry = { enable = false },
              }
            }
          })
        end,
        ["tailwindcss"] = function()
          setup_lsp("tailwindcss", {
            filetypes = {
              "html", "css", "scss", "javascript", "typescript",
              "javascriptreact", "typescriptreact", "astro", "mdx",
            },
          })
        end,
      }

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
          "astro",
        },
        automatic_installation = false,
      })

      for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
        local handler = handlers_table[server_name] or handlers_table[1]
        if handlers_table[server_name] then
          handler()
        else
          handler(server_name)
        end
      end

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


  -- folke/lazydev.nvim - Lazy loading for Lua development (e.g. DX for neovim Lua)
  -- https://github.com/folke/lazydev.nvim
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        {
          path = "${3rd}/luv/library",
          words = { "vim%.uv" },
        },
      },
    },
  },

  -- mfussenegger/nvim-ansible - Ansible plugin for neovim (2025-09-02)
  -- https://github.com/mfussenegger/nvim-ansible
  {
    "mfussenegger/nvim-ansible"
  },
}
