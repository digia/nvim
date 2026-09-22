local opt = vim.opt_local

opt.wrap = true
opt.textwidth = 100
opt.formatoptions:append("n")
opt.formatoptions:append("q")
opt.formatlistpat = [[^\s*[-*+]\s\+\(\[[ xX-]\]\s\+\)\?\|^\s*\d\+[.)]\s\+\(\[[ xX-]\]\s\+\)\?]]

--- [r]ender markdown [p]review
vim.keymap.set("n", "<leader>rp", "<cmd>RenderMarkdown buf_toggle<cr>", { buffer = 0 })

local CHECKBOX_ORDER = { " ", "/", "x", "-", ">", "?", "!" }
vim.keymap.set("n", "<C-t>", function()
  local line = vim.api.nvim_get_current_line()
  local s, e, char = line:find("%[([ /x%->?!])%]")
  if not s then return end
  local next_char = CHECKBOX_ORDER[1]
  for i, c in ipairs(CHECKBOX_ORDER) do
    if c == char then
      next_char = CHECKBOX_ORDER[(i % #CHECKBOX_ORDER) + 1]
      break
    end
  end
  vim.api.nvim_set_current_line(line:sub(1, s) .. next_char .. line:sub(e))
end, { buffer = 0, desc = "Toggle checkbox" })

-- 2026-09-22: With this configuration, list under a heading inherit the heading's
-- baseline level and then increments from there. Which isn't what is expected or
-- desired. Disabling for now to see if it's missed.
-- local brain = require("digia.brain")
-- if brain.is_vault_buffer() then
--   opt.foldlevel = brain.foldlevel()
-- end
