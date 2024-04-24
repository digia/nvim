-- vim.keymap.set('i', '<C-e>', 'copilot#Accept("\\<CR>")', {
  -- expr = true,
  -- replace_keycodes = false
-- })
-- vim.g.copilot_no_tab_map = true

require("copilot").setup({
  panel = {
    -- enabled = false,
    auto_refresh = false,
    keymap = {
      accept = "<CR>",
      jump_prev = "[[",
      jump_next = "]]",
      refresh = "gr",
      open = "<M-CR>",
    },
  },
  suggestion = {
    -- enabled = false,
    auto_trigger = true,
    keymap = {
      accept = "<M-p>",
      prev = "<M-[>",
      next = "<M-]>",
      dismiss = "<C-]>",
    },
  },
})
