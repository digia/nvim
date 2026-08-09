-- Forward declarations for mutual recursion
local find_project_root, find_test_file, find_impl_file, find_alternate_file, suggest_test_path

-- Files to skip (not impl files, not test files)
local SKIP_PATTERNS = {
  "%.d%.ts$",
  "%.stories%.",
  "testHelper%.",
  "testUtils%.",
  "/__mocks__/",
}

-- Test file patterns
local TEST_PATTERNS = { "%.test%.", "%.spec%.", "^test_", "_test%." }

-- Extension mappings for language ecosystems
local EXT_MAPPINGS = {
  cjs = { "cjs", "js" },
  cts = { "cts" },
  ex = { "exs" },
  exs = { "ex" },
  js = { "js", "jsx" },
  jsx = { "jsx", "js" },
  mjs = { "mjs", "js" },
  mts = { "mts" },
  go = { "go" },
  py = { "py" },
  ts = { "ts", "tsx" },
  tsx = { "tsx", "ts" },
}

-- Cache project roots per directory
local _root_cache = {}

find_project_root = function()
  local buf_dir = vim.fn.resolve(vim.fn.expand("%:p:h"))
  if _root_cache[buf_dir] then
    return _root_cache[buf_dir]
  end

  -- Prioritize .git for monorepo support
  local path = buf_dir
  while path ~= "/" do
    if vim.fn.isdirectory(path .. "/.git") == 1 then
      _root_cache[buf_dir] = path
      return path
    end
    path = vim.fn.fnamemodify(path, ":h")
  end

  -- Fallback to other markers
  path = buf_dir
  local markers = { "package.json", "mix.exs", "pyproject.toml", "go.work", "go.mod", "Cargo.toml" }
  while path ~= "/" do
    for _, marker in ipairs(markers) do
      if vim.fn.filereadable(path .. "/" .. marker) == 1 then
        _root_cache[buf_dir] = path
        return path
      end
    end
    path = vim.fn.fnamemodify(path, ":h")
  end

  _root_cache[buf_dir] = nil
  return nil
end

local function is_skipped_file(filepath)
  for _, pattern in ipairs(SKIP_PATTERNS) do
    if filepath:match(pattern) then
      return true
    end
  end
  return false
end

local function is_test_file(filename)
  for _, pattern in ipairs(TEST_PATTERNS) do
    if filename:match(pattern) then
      return true
    end
  end
  return false
end

find_test_file = function(impl_path)
  local dir = vim.fn.fnamemodify(impl_path, ":h")
  local basename = vim.fn.fnamemodify(impl_path, ":t:r")
  local ext = vim.fn.fnamemodify(impl_path, ":e")

  local suffixes = (ext == "ex" or ext == "go" or ext == "py") and { "_test." } or { ".test.", ".spec." }
  if ext == "py" then
    suffixes = { "_test." }
  end

  local extensions = EXT_MAPPINGS[ext] or { ext }

  local function check_candidate(candidate)
    candidate = vim.fs.normalize(candidate)
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
    return nil
  end

  -- 1. Co-located
  for _, suffix in ipairs(suffixes) do
    for _, e in ipairs(extensions) do
      local result = check_candidate(dir .. "/" .. basename .. suffix .. e)
      if result then return result end
    end
  end

  -- Python: test_*.py pattern
  if ext == "py" then
    local result = check_candidate(dir .. "/test_" .. basename .. ".py")
    if result then return result end
  end

  -- 2. Root test/ or tests/ directory
  local root = find_project_root()
  if root then
    local resolved_impl = vim.fn.resolve(impl_path)
    local resolved_root = vim.fn.resolve(root)
    if resolved_impl:sub(1, #resolved_root) == resolved_root then
      local relative = resolved_impl:sub(#resolved_root + 2)
      for _, test_dir in ipairs({ "test", "tests" }) do
        for _, suffix in ipairs(suffixes) do
          for _, e in ipairs(extensions) do
            local test_relative = relative:gsub("%." .. ext .. "$", suffix .. e)
            local result = check_candidate(root .. "/" .. test_dir .. "/" .. test_relative)
            if result then return result end
          end
        end
        -- Python prefix style
        if ext == "py" then
          local test_relative = relative:gsub("([^/]+)%.py$", "test_%1.py")
          local result = check_candidate(root .. "/" .. test_dir .. "/" .. test_relative)
          if result then return result end
        end
      end
    end
  end

  -- 3. __tests__ directory (Jest convention)
  if ext ~= "py" and ext ~= "ex" then
    for _, suffix in ipairs(suffixes) do
      for _, e in ipairs(extensions) do
        local result = check_candidate(dir .. "/__tests__/" .. basename .. suffix .. e)
        if result then return result end
      end
    end
  end

  return nil
end

find_impl_file = function(test_path)
  local dir = vim.fn.fnamemodify(test_path, ":h")
  local filename = vim.fn.fnamemodify(test_path, ":t")
  local ext = vim.fn.fnamemodify(test_path, ":e")

  -- Strip test patterns
  local basename = filename
    :gsub("%.test%.", ".")
    :gsub("%.spec%.", ".")
    :gsub("^test_", "")
    :gsub("_test%.", ".")
  basename = vim.fn.fnamemodify(basename, ":r")

  local impl_ext = ext
  if ext == "exs" then impl_ext = "ex" end

  local function check_candidate(candidate)
    candidate = vim.fs.normalize(candidate)
    if vim.fn.filereadable(candidate) == 1 then
      return candidate
    end
    return nil
  end

  -- 1. If in __tests__, check parent
  if dir:match("__tests__$") then
    local parent = vim.fn.fnamemodify(dir, ":h")
    local result = check_candidate(parent .. "/" .. basename .. "." .. impl_ext)
    if result then return result end
  end

  -- 2. Co-located
  local result = check_candidate(dir .. "/" .. basename .. "." .. impl_ext)
  if result then return result end

  -- 3. Root test/ mirroring
  local root = find_project_root()
  if root then
    for _, test_dir in ipairs({ "test", "tests" }) do
      local test_prefix = vim.fn.resolve(root .. "/" .. test_dir) .. "/"
      local resolved_test = vim.fn.resolve(test_path)
      if resolved_test:sub(1, #test_prefix) == test_prefix then
        local relative = resolved_test:sub(#test_prefix + 1)
        relative = relative
          :gsub("%.test%.", ".")
          :gsub("%.spec%.", ".")
          :gsub("^test_", "")
          :gsub("_test%.", ".")
        relative = relative:gsub("%.exs$", ".ex")
        for _, src_dir in ipairs({ "src", "lib", "" }) do
          local candidate = root .. "/" .. src_dir .. "/" .. relative
          result = check_candidate(candidate)
          if result then return result end
        end
      end
    end
  end

  return nil
end

find_alternate_file = function(filepath)
  filepath = vim.fn.resolve(filepath)
  local filename = vim.fn.fnamemodify(filepath, ":t")

  if is_test_file(filename) then
    return find_impl_file(filepath)
  else
    return find_test_file(filepath)
  end
end

suggest_test_path = function(impl_path)
  local filename = vim.fn.fnamemodify(impl_path, ":t")
  local ext = vim.fn.fnamemodify(impl_path, ":e")

  if is_test_file(filename) or is_skipped_file(impl_path) then
    return nil
  end

  local dir = vim.fn.fnamemodify(impl_path, ":h")
  local basename = vim.fn.fnamemodify(impl_path, ":t:r")

  if ext == "py" then
    return vim.fs.normalize(dir .. "/test_" .. basename .. ".py")
  elseif ext == "ex" then
    return vim.fs.normalize(dir .. "/" .. basename .. "_test.exs")
  elseif ext == "go" then
    return vim.fs.normalize(dir .. "/" .. basename .. "_test.go")
  else
    return vim.fs.normalize(dir .. "/" .. basename .. ".test." .. ext)
  end
end

local function goto_alternate()
  local current = vim.fn.expand("%:p")
  if current == "" then
    vim.notify("No file in current buffer", vim.log.levels.WARN)
    return
  end

  if is_skipped_file(current) then
    vim.notify("Not an implementation or test file", vim.log.levels.WARN)
    return
  end

  local alternate = find_alternate_file(current)
  local is_looking_for_test = not is_test_file(vim.fn.fnamemodify(current, ":t"))

  if alternate then
    vim.cmd.edit(alternate)
    local action = is_looking_for_test and "test" or "impl"
    vim.notify("Jumped to " .. action .. " file", vim.log.levels.INFO)
  elseif is_looking_for_test then
    local suggested = suggest_test_path(current)
    if suggested then
      local root = find_project_root() or vim.fn.getcwd()
      local relative = suggested:sub(#root + 2)
      local choice = vim.fn.confirm("Create test file?\n" .. relative, "&Yes\n&No", 2)
      if choice == 1 then
        local dir = vim.fn.fnamemodify(suggested, ":h")
        vim.fn.mkdir(dir, "p")
        vim.cmd.edit(suggested)
      end
    else
      vim.notify("Cannot determine test file location", vim.log.levels.WARN)
    end
  else
    vim.notify(
      "Implementation file not found for " .. vim.fn.fnamemodify(current, ":t"),
      vim.log.levels.WARN
    )
  end
end

return {
  {
    "nvim-neotest/neotest",
    lazy = true,
    event = "VeryLazy",
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "marilari88/neotest-vitest",
      { "fredrikaverpil/neotest-golang", version = "*" },
      "nvim-neotest/neotest-python",
      "jfpedroza/neotest-elixir",
      { "thenbe/neotest-playwright", dependencies = "nvim-telescope/telescope.nvim" },
    },

    keys = {
      { "<leader>t", nil, desc = "Test" },
      { "<leader>tg", goto_alternate, desc = "Go to test/impl file" },
      { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
      { "<leader>tf", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run file" },
      { "<leader>ta", function() require("neotest").run.run(vim.uv.cwd()) end, desc = "Run all tests" },
      { "<leader>tl", function() require("neotest").run.run_last() end, desc = "Run last test" },
      { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle summary" },
      { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show output" },
      { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
      { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop test" },
      { "<leader>tw", function() require("neotest").watch.toggle(vim.fn.expand("%")) end, desc = "Toggle watch" },
    },

    opts = function()
      return {
        floating = {
          border = "rounded",
          max_height = 0.6,
          max_width = 0.6,
        },
        adapters = {
          require("neotest-vitest")({
            -- Uses vitest.config.* by default
          }),
          require("neotest-golang")({}),
          require("neotest-python")({
            dap = { justMyCode = false },
            runner = "pytest",
          }),
          require("neotest-elixir")({
            args = { "--trace" },
          }),
          require("neotest-playwright").adapter({
            options = {
              persist_project_selection = true,
              enable_dynamic_test_discovery = true,
            },
          }),
        },
        status = {
          virtual_text = true,
          signs = true,
        },
        output = {
          open_on_run = "short",
        },
        quickfix = {
          open = false,
        },
      }
    end,
  },
}
