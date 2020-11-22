local lspconfig = require('lspconfig')

local mapper = function(mode, key, result)
  local buffer = 0 -- Buffer number or 0 for the current buffer
  vim.api.nvim_buf_set_keymap(buffer, mode, key, result, {noremap = true, silent = true})
end

local on_attach = function(client)
  -- completion.on_attach(client)
  -- mapper('n', 'gd', '<cmd>lua vim.lsp.buf.declaration()<CR>')
  mapper('n', '<c-]>', '<cmd>lua vim.lsp.buf.definition()<CR>')
  mapper('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>')
  mapper('n', '1gD', '<cmd>lua vim.lsp.buf.type_definition()<CR>')
  mapper('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>')
  mapper('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>')
  -- mapper('n', '<space>cr', '<cmd>lua MyLspRename()<CR>')


  -- nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
  -- nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
  -- nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
  -- nnoremap <silent> grr :lua vim.lsp.buf.rename()<CR>
  -- nnoremap <silent> gh :lua vim.lsp.buf.hover()<CR>
  -- nnoremap <silent> ga :lua vim.lsp.buf.code_action()<CR>
  --  nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>

end

--[[
LSP (Language Server Protocol)

NOTE: This needs to happen after setting up styles, not sure why...
--]]

lspconfig.tsserver.setup {
  on_attach = on_attach
}

lspconfig.pyls_ms.setup {
  enable = true,
  on_attach = on_attach
}

lspconfig.html.setup {
  on_attach = on_attach
}

lspconfig.cssls.setup {
  on_attach = on_attach
}

lspconfig.bashls.setup {
  on_attach = on_attach
}

lspconfig.jsonls.setup {
  on_attach = on_attach
}

lspconfig.dockerls.setup {
  on_attach = on_attach
}

-- lspconfig.intelephense.setup{}
-- lspconfig.vimls.setup{}
-- lspconfig.gopls.setup{}
