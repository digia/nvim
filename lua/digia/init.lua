require("digia.options")
require("digia.keymaps")

--
-- Bootstrap lazy.nvim plugin manager
--
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- https://lazy.folke.io/configuration
require("lazy").setup({
    spec = {
        { import = "digia.plugin" },
    },
    -- colorscheme that will be used when installing plugins.
    -- install = { colorscheme = { "solarized8" } },

    -- automatically check for plugin updates
    checker = {
        enabled = true,
        notify = false,
    },

    change_detection = {
        notify = false,
    },
})

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local DigiaGroup = augroup("Digia", {})
-- local HighlightYankGroup = augroup("HighlightYank", {})


autocmd({"BufWritePre"}, {
    group = DigiaGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd("BufEnter", {
    group = DigiaGroup,
    callback = function()
        -- Being the primary color scheme it's loaded within the plugin spec
        -- vim.cmd.colorscheme("solarized8_flat")
    end
})

-- autocmd("LspAttach", {
    -- group = DigiaGroup,
    -- callback = function(e)
        -- local opts = { buffer = e.buf }
        -- vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        -- -- Using "v" prefix due to it being a "visual" action -- e.g. it opens a split pane
        -- -- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        -- vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
        -- vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
        -- vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
        -- vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
        -- vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)
        -- vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)
        -- vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        -- vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        -- vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
    -- end
-- })
