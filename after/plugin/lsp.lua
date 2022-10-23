local cmp = require('cmp')
local cmp_nvim_lsp = require('cmp_nvim_lsp')
local lspconfig = require('lspconfig')
local luasnip = require('luasnip')
local luasnip_from_vscode = require('luasnip.loaders.from_vscode')
local navic = require('nvim-navic')

local Remap = require('digia.remap')


local nnoremap = Remap.nnoremap
local inoremap = Remap.inoremap

-- Setup completion
cmp.setup({
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
      -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
  },

  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm completion

    -- NOTE: Not seeing where `abort` is needed with <C-c> acting as escape
    -- ['<C-c>'] = cmp.mapping.abort(), -- Close the completion window

    -- Unable to get "complete" to work, not sure what it actually does
    -- ['<C-Space>'] = cmp.mapping.complete(),

    -- Unable to get page style scrolling to work
    -- ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    -- ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),

  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'path' },
  }, {
    { name = 'buffer' },
  })
})

local lsp_capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())

local function lsp_config(config)
  local on_attach = function(client, bufnr)
    -- Act upon a variable/function
    nnoremap('K', function() vim.lsp.buf.hover() end) -- View the documentation
    nnoremap('<leader>vd', function() vim.lsp.buf.definition() end) -- View variable definition
    nnoremap('<leader>vi', function() vim.lsp.buf.implementation() end) -- View variable implementation
    nnoremap('<leader>vws', function() vim.lsp.buf.workspace_symbol() end) -- View symbol within workspace
    -- nnoremap('<leader>vd', function() vim.diagnostic.open_float() end) -- ?
    nnoremap('<leader>vr', function() vim.lsp.buf.references() end) -- View references
    nnoremap('<leader>vrn', function() vim.lsp.buf.rename() end) -- Rename the variable/function

    -- Testing bindings from ThePrimeagen (2022-10-23)
    inoremap('<C-h>', function() vim.lsp.buf.signature_help() end)

    -- Attach navic for code context
    if client.server_capabilities.documentSymbolProvider then
      navic.attach(client, bufnr)
    end
  end

  local base_config = {
    on_attach = on_attach,
    capabilities = lsp_capabilities,
  }

  return vim.tbl_deep_extend('force', base_config, config or {})
end

luasnip_from_vscode.lazy_load() -- Load friendly snippets like VS Code

--[[
LSP (Language Server Protocol)

NOTE: This needs to happen after setting up styles, not sure why...
--]]
lspconfig.tsserver.setup(lsp_config())
lspconfig.pyright.setup(lsp_config({ enabled = true }))
lspconfig.html.setup(lsp_config())
lspconfig.cssls.setup(lsp_config())
lspconfig.bashls.setup(lsp_config())
lspconfig.jsonls.setup(lsp_config())
lspconfig.dockerls.setup(lsp_config())
lspconfig.jdtls.setup(lsp_config())

-- lspconfig.intelephense.setup{}
-- lspconfig.vimls.setup{}
