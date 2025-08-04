-- Set indentation
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Enable comment continuation
vim.opt_local.formatoptions:append("cro")

-- Set comment string for Astro files
vim.opt_local.commentstring = "<!-- %s -->"