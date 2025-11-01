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
    -- Save the current view to restore it after the substitution, avoidingn cur
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

-- Create ThemeColors command
vim.api.nvim_create_user_command("ThemeColors", function()
  require("digia.theme").show_colors()
end, { desc = "Show current theme colors in a scratch buffer" })

-- Create CleanseQuotes command for converting smart quotes to standard quotes
vim.api.nvim_create_user_command("CleanseQuotes", function(opts)
  local range = opts.range > 0 and opts.line1 .. "," .. opts.line2 or "."
  local flags = "ge" .. (opts.bang and "c" or "")

  -- Save cursor position and search register
  local save_pos = vim.fn.getpos(".")
  local save_search = vim.fn.getreg("/")

  -- Track if any changes occur
  local changenr_before = vim.fn.changenr()

  -- Execute substitutions silently
  vim.cmd(string.format([[
    silent! %ss/[""„‟]/"/g%s
    silent! %ss/[''‚‛'']/'/g%s
  ]], range, flags, range, flags))

  -- Restore cursor (unless in confirmation mode)
  if not opts.bang then
    vim.fn.setpos(".", save_pos)
  end
  vim.fn.setreg("/", save_search)

  -- Check if changes were made
  local changenr_after = vim.fn.changenr()

  if changenr_after > changenr_before then
    vim.notify("Cleansed smart quotes")
  else
    vim.notify("No smart quotes found")
  end
end, {
  range = true,
  bang = true,
  desc = "Convert smart quotes to standard quotes. Use ! for confirmation mode"
})
