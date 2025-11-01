local M = {}

function M.remove_qf_item()
  local qflist = vim.fn.getqflist()
  local idx = vim.fn.line(".")

  if idx > 0 and idx <= #qflist then
    table.remove(qflist, idx)
    vim.fn.setqflist(qflist, "r")

    -- Reopen quickfix window to refresh
    vim.cmd("copen")

    -- Move cursor to appropriate line
    local new_idx = math.min(idx, #qflist)
    if new_idx > 0 then
      vim.api.nvim_win_set_cursor(0, {new_idx, 0})
    end
  end
end

-- Set up autocommand to add keybinding when quickfix window opens
vim.api.nvim_create_autocmd("FileType", {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "dd", M.remove_qf_item, { buffer = true, desc = "Remove quickfix item" })
  end,
})

return M
