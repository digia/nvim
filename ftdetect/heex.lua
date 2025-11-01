-- Override vim-polyglot's eelixir detection for heex files
vim.filetype.add({
  extension = {
    heex = "heex",
  },
  pattern = {
    [".*%.html%.heex"] = "heex",
  },
})

-- Force override with autocmd that runs after polyglot
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.heex", "*.html.heex" },
  callback = function()
    vim.bo.filetype = "heex"
  end,
})
