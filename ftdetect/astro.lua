-- Set up file type detection for Astro files
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.astro",
  callback = function()
    vim.bo.filetype = "astro"
  end,
})

-- Set up file type detection for MDX files
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.mdx",
  callback = function()
    vim.bo.filetype = "markdown.mdx"
  end,
})
