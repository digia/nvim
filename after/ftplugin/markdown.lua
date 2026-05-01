vim.opt.wrap = true

local opt = vim.opt_local
opt.textwidth = 100
opt.formatoptions:append("n") -- recognize lists when formatting (gq)
opt.formatoptions:append("q") -- allow gq on comments/quotes
opt.formatlistpat = [[^\s*[-*+]\s\+\(\[[ xX-]\]\s\+\)\?\|^\s*\d\+[.)]\s\+\(\[[ xX-]\]\s\+\)\?]]

-- [R]ender markdown [p]review
vim.keymap.set("n", "<leader>rp", "<cmd>RenderMarkdown toggle<cr>")
