--
-- NOTE: Initial implementation by Claude, need to polish as it's quite "scripty"
--


-- Python test runner keybindings
local function run_test_in_split(cmd, is_pdm_test_cmd)
  -- Save the current window so we can return to it
  local current_win = vim.api.nvim_get_current_win()

  -- Check for virtual environment and activate if present
  local venv_cmd = ""
  local venv_type = nil
  local project_root = vim.fn.getcwd()
  local test_cmd = cmd

  -- Check for pdm first
  if vim.fn.filereadable(project_root .. "/pyproject.toml") == 1 then
    -- Check for pdm
    if vim.fn.filereadable(project_root .. "/pdm.lock") == 1 and vim.fn.executable("pdm") == 1 then
      if is_pdm_test_cmd then
        -- Replace pytest with pdm run test for PDM projects
        test_cmd = cmd:gsub("^pytest", "test")
      end
      venv_cmd = "pdm run "
      venv_type = "pdm"
    -- Check for poetry
    elseif vim.fn.filereadable(project_root .. "/poetry.lock") == 1 and vim.fn.executable("poetry") == 1 then
      venv_cmd = "poetry run "
      venv_type = "poetry"
    else
      -- pyproject.toml exists but no pdm.lock, check for regular venv
      local venv_paths = {
        project_root .. "/.venv",
        project_root .. "/venv",
        project_root .. "/.virtualenv",
        project_root .. "/virtualenv"
      }

      for _, venv_path in ipairs(venv_paths) do
        if vim.fn.isdirectory(venv_path) == 1 then
          -- Use source command to activate virtual environment
          venv_cmd = "source " .. venv_path .. "/bin/activate && "
          venv_type = "venv: " .. vim.fn.fnamemodify(venv_path, ":t")
          break
        end
      end
    end
  else
    -- Check for Pipenv
    if vim.fn.filereadable(project_root .. "/Pipfile") == 1 and vim.fn.executable("pipenv") == 1 then
      venv_cmd = "pipenv run "
      venv_type = "pipenv"
    else
      -- No pyproject.toml or Pipfile, check for regular virtual environments
      local venv_paths = {
        project_root .. "/.venv",
        project_root .. "/venv",
        project_root .. "/.virtualenv",
        project_root .. "/virtualenv"
      }

      for _, venv_path in ipairs(venv_paths) do
        if vim.fn.isdirectory(venv_path) == 1 then
          -- Use source command to activate virtual environment
          venv_cmd = "source " .. venv_path .. "/bin/activate && "
          venv_type = "venv: " .. vim.fn.fnamemodify(venv_path, ":t")
          break
        end
      end
    end
  end

  -- Show virtual environment info if detected
  if venv_type then
    vim.notify("Using " .. venv_type, vim.log.levels.INFO)
  end

  -- Open a horizontal split below and run the test command with virtual environment
  vim.cmd('rightbelow split | terminal ' .. venv_cmd .. test_cmd)

  -- Return focus to the original window
  vim.api.nvim_set_current_win(current_win)

  -- Save the last test command (including venv activation)
  vim.b.last_test_cmd = venv_cmd .. test_cmd
end

local function get_test_at_cursor()
  -- Get the current file and cursor position
  local file = vim.fn.expand('%:p')
  local line = vim.fn.line('.')

  -- Search backwards for the nearest test function or class
  local test_pattern = '^%s*def%s+(test_[%w_]+)'
  local class_pattern = '^%s*class%s+([%w_]+)'

  local test_name = nil
  local class_name = nil

  -- Search backwards for test function
  for i = line, 1, -1 do
    local line_content = vim.fn.getline(i)
    local match = line_content:match(test_pattern)
    if match then
      test_name = match
      break
    end
    -- Also check for class
    local class_match = line_content:match(class_pattern)
    if class_match and not class_name then
      class_name = class_match
    end
  end

  if test_name then
    if class_name then
      return file .. '::' .. class_name .. '::' .. test_name
    else
      return file .. '::' .. test_name
    end
  end

  return nil
end

-- Run test at cursor
vim.keymap.set('n', '<leader>tt', function()
  local test_location = get_test_at_cursor()
  if test_location then
    run_test_in_split('pytest -xvs ' .. test_location, true)
  else
    vim.notify("No test found at cursor position", vim.log.levels.WARN)
  end
end, { buffer = true, desc = "Run test at cursor" })

-- Run all tests in current file
vim.keymap.set('n', '<leader>tf', function()
  local file = vim.fn.expand('%:p')
  run_test_in_split('pytest -xvs ' .. file, true)
end, { buffer = true, desc = "Run tests in current file" })

-- Run all tests in project
vim.keymap.set('n', '<leader>ta', function()
  run_test_in_split('pytest -xvs', true)
end, { buffer = true, desc = "Run all tests" })

-- Run last test command
vim.keymap.set('n', '<leader>tl', function()
  if vim.b.last_test_cmd then
    -- last_test_cmd already contains the full command with venv activation
    -- Run it directly without going through venv detection again
    local current_win = vim.api.nvim_get_current_win()
    vim.cmd('rightbelow split | terminal ' .. vim.b.last_test_cmd)
    vim.api.nvim_set_current_win(current_win)
  else
    vim.notify("No previous test command", vim.log.levels.WARN)
  end
end, { buffer = true, desc = "Run last test" })
