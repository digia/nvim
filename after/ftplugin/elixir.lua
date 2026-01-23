-- Elixir-specific keybinds
-- Test keybindings provided by neotest (see lua/digia/plugin/testing.lua)

-- Format with mix format
vim.keymap.set("n", "<leader>rf", vim.lsp.buf.format, {
  buffer = true,
  desc = "Run Format (mix format)",
  noremap = true,
  silent = true,
})
