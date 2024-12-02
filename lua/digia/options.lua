-- Change cursor based on mode
vim.opt.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.autoindent = true
vim.opt.smartindent = true
-- vim.opt.cindent = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.wrap = false -- new

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 7 -- new, prev 3
vim.opt.sidescrolloff = 7 -- new, prev 5
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@") -- new

vim.opt.updatetime = 50 -- Time in milliseconds to wait before triggering the plugin events after a change

vim.opt.cursorline = true

-- Only show colorcolumn at 80 and 120
-- vim.opt.colorcolumn = "80,120"
-- Or... show colorcolumn at 80 and from 120 to 999
-- Build a string of all columns from 120 to 999, to later use as a comma separated list for colorcolumn
local colorcolumns = {}; for i = 120, 999 do colorcolumns[#colorcolumns+1] = tostring(i) end;
vim.opt.colorcolumn = "80," .. table.concat(colorcolumns, ",")


vim.opt.list = true -- new, show tab characters and trailing whitespace
vim.opt.listchars = "tab:»\\ ,extends:›,precedes:‹,nbsp:·,trail:·" -- show tab characters and trailing whitespace
vim.opt.formatoptions:remove("t") -- new, no auto-intent of line breaks, keep line wrap enabled

vim.opt.splitbelow = true -- split windows below current window
vim.opt.splitright = true -- split windows right of current window

vim.opt.grepprg = "rg --vimgrep"

if vim.fn.has("nvim-0.10") == 1 then
  vim.opt.smoothscroll = true
  vim.opt.foldexpr = "v:lua.require'digia.util'.ui.foldexpr()"
  vim.opt.foldmethod = "expr"
  vim.opt.foldtext = ""
else
  vim.opt.foldmethod = "indent"
  vim.opt.foldtext = "v:lua.require'digia.util'.ui.foldtext()"
end


