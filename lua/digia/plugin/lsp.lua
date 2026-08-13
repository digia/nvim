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
      -- Disable polyglot's elixir handling - using treesitter instead.
      -- Also disable org: polyglot ships an ftplugin/org.vim that guards with
      -- did_ftplugin, which prevents nvim-orgmode's own ftplugin (and thus its
      -- treesitter-based folds) from loading.
      vim.g.polyglot_disabled = { "elixir", "org" }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      { "antosha417/nvim-lsp-file-operations", config = true },
      "mason-org/mason.nvim",
      "mason-org/mason-lspconfig.nvim",
      "SmiteshP/nvim-navic",
    },

    config = function()
      local cmp_lsp = require("cmp_nvim_lsp")
      local navic = require("nvim-navic")

      local capabilities = vim.tbl_deep_extend(
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

        if client.server_capabilities.definitionProvider then
          nmap("gd", vim.lsp.buf.definition, "Go to Definition")
        end

        nmap("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover")

        nmap("]d", vim.diagnostic.goto_next)
        nmap("[d", vim.diagnostic.goto_prev)
        nmap("]e", function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, "Next Error")
        nmap("[e", function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, "Previous Error")

        -- Attach navic for code context
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
      end

      -- ENHANCEMENT: Neovim 0.11+ docs recommend an `LspAttach` autocmd as the
      -- modern pattern for buffer-local LSP setup. `on_attach` in vim.lsp.ClientConfig
      -- is NOT deprecated and is kept here to minimize the diff from the previous
      -- lspconfig.setup() pattern. Migrate if per-server on_attach chains ever
      -- become awkward (e.g. multiple servers needing distinct attach sequences).
      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = on_attach,
      })

      -- ENHANCEMENT: For servers where `mason-lspconfig/lua/mason-lspconfig/lsp/<name>.lua`
      -- exists AND sets fields that also appear in these overrides, mason-lspconfig's
      -- scheduled `automatic_enable.enable_all()` call (running on the next event-loop
      -- tick after setup) deep-merges mason's bundled defaults ON TOP of these values
      -- via tbl_deep_extend("force", ...), potentially clobbering them at conflicting
      -- leaf keys. Verified safe today: elixirls' bundled file only sets `cmd`;
      -- lua_ls and tailwindcss have no bundled files. When adding a new per-server
      -- override, spot-check the corresponding mason-lspconfig/lsp/<name>.lua file
      -- first. If it clobbers a key you care about, wrap the override in
      -- `vim.schedule(function() vim.lsp.config(name, ...) end)` to push it past
      -- mason's scheduled call, or move it to `~/.config/nvim/lsp/<name>.lua`.
      vim.lsp.config("elixirls", {
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

      vim.lsp.config("lua_ls", {
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
          },
        },
      })

      vim.lsp.config("tailwindcss", {
        filetypes = {
          "html", "css", "scss", "javascript", "typescript",
          "javascriptreact", "typescriptreact", "astro", "mdx",
        },
      })

      require("mason").setup()

      -- ENHANCEMENT: `automatic_enable = true` (the default in mason-lspconfig 2.x)
      -- auto-enables ALL mason-installed servers, not just `ensure_installed`.
      -- Ad-hoc `:MasonInstall <server>` calls will therefore auto-attach the next
      -- time a matching filetype is opened. For strict "only ensure_installed
      -- attaches" control, use the allow-list form `automatic_enable = { "lua_ls",
      -- "rust_analyzer", ... }` or the exclude form `{ exclude = { ... } }`.
      require("mason-lspconfig").setup({
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
          "elixirls",
          "astro",
          "marksman",
        },
      })

      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            -- Hide unused variable warnings from virtual text (return nil to hide, otherwise the icon & virtual line shows)
            if diagnostic.message:match("variable .* is unused") or diagnostic.message:match("unused variable") then
              return nil
            end
            return diagnostic.message
          end,
        },
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
