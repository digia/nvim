-- Go-specific settings
local opt = vim.opt_local

-- Indentation: use tabs, not spaces
opt.expandtab = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 0

-- Display tabs as 4 spaces visually
opt.listchars = "tab:  ,extends:›,precedes:‹,nbsp:·,trail:·"

-- Format on save using LSP (gopls handles gofmt/goimports)
vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = 0,
    callback = function()
        -- Format with LSP
        vim.lsp.buf.format({ async = false })

        -- Organize imports
        local params = vim.lsp.util.make_range_params()
        params.context = { only = { "source.organizeImports" } }
        local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
        for cid, res in pairs(result or {}) do
            for _, r in pairs(res.result or {}) do
                if r.edit then
                    local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                    vim.lsp.util.apply_workspace_edit(r.edit, enc)
                end
            end
        end
    end
})

-- Toggle visible tabs
vim.keymap.set("n", "<leader>vt", function()
    if vim.opt_local.listchars:get().tab == "  " then
        vim.opt_local.listchars = "tab:│ ,extends:›,precedes:‹,nbsp:·,trail:·"
        print("Tabs visible")
    else
        vim.opt_local.listchars = "tab:  ,extends:›,precedes:‹,nbsp:·,trail:·"
        print("Tabs hidden")
    end
end, { buffer = 0, desc = "Toggle visible tabs" })
