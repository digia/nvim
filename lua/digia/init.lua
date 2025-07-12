require("digia.options")
require("digia.keymaps")
require("digia.quickfix")

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
      { out,                            "WarningMsg" },
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

autocmd({ "BufWritePre" }, {
  group = DigiaGroup,
  pattern = "*",
  callback = function()
    -- Save the current view to restore it after the substitution, avoidingn cursor jump
    local save = vim.fn.winsaveview()
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.winrestview(save)
  end,
})

autocmd("BufEnter", {
  group = DigiaGroup,
  callback = function()
    -- Being the primary color scheme it's loaded within the plugin spec
    -- vim.cmd.colorscheme("solarized8_flat")
  end
})
