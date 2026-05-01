-- vim-polyglot sets did_load_filetypes=1 AND `au! filetypedetect`, wiping
-- Neovim's built-in .org detection. Re-register it and add an explicit
-- BufRead autocmd to survive polyglot's init.
vim.filetype.add({
  extension = {
    org = "org",
  },
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.org" },
  callback = function()
    vim.bo.filetype = "org"
  end,
})
