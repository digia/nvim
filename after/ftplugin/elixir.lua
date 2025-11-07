-- Elixir-specific keybinds

-- Format with mix format
vim.keymap.set("n", "<leader>rf", vim.lsp.buf.format, {
  buffer = true,
  desc = "Run Format (mix format)",
  noremap = true,
  silent = true,
})

-- Run mix test on current file in tmux split below
vim.keymap.set("n", "<leader>rt", function()
  local file = vim.fn.expand("%")
  local cmd = string.format("mix test %s", file)

  -- Check if there's a pane below
  local at_bottom = vim.fn.system("tmux display-message -p '#{pane_at_bottom}'"):match("1")

  if at_bottom then
    -- No pane below, create new split
    vim.fn.system(string.format("tmux split-window -v '%s'", cmd))
  else
    -- Check if pane below is running a process (not just a shell)
    local pane_cmd = vim.fn.system("tmux display-message -p -t bottom '#{pane_current_command}'"):gsub("%s+$", "")
    local is_shell = pane_cmd:match("^zsh$") or pane_cmd:match("^bash$") or pane_cmd:match("^fish$") or pane_cmd:match("^sh$")

    if is_shell then
      -- Shell is idle, send command to it
      vim.fn.system("tmux select-pane -D")
      vim.fn.system(string.format("tmux send-keys '%s' C-m", cmd))
      vim.fn.system("tmux select-pane -U")
    else
      -- Pane is busy, create new split
      vim.fn.system(string.format("tmux split-window -v '%s'", cmd))
    end
  end
end, {
  buffer = true,
  desc = "Run Test (mix test)",
  noremap = true,
  silent = true,
})
