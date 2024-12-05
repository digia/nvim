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
  command = [[%s/\s\+$//e]],
})

autocmd("BufEnter", {
  group = DigiaGroup,
  callback = function()
    -- Being the primary color scheme it's loaded within the plugin spec
    -- vim.cmd.colorscheme("solarized8_flat")
  end
})

-- JavaScript, typescript, tsx
autocmd({ "BufNewFile", "BufRead" }, {
  group = DigiaGroup,
  pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
  end
})

-- HTML, CSS
autocmd({ "BufNewFile", "BufRead" }, {
  group = DigiaGroup,
  pattern = { "*.html", "*.css", "*.sass", "*.scss", "*.json", "*.jsonc" }, -- Should probably add all the other possibilities here...
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
  end
})

-- Markdown
autocmd({ "BufNewFile", "BufRead" }, {
  group = DigiaGroup,
  pattern = { "*.md", "*.markdown", },
  callback = function()
    vim.opt.wrap = true
  end
})

-- Lua
autocmd({ "BufNewFile", "BufRead" }, {
  group = DigiaGroup,
  pattern = { "*.lua" },
  callback = function()
    vim.opt.tabstop = 2
    vim.opt.softtabstop = 2
    vim.opt.shiftwidth = 2
  end
})
