local brain = require("digia.brain")

local function daily_template(date_str)
  local t = { year = date_str:sub(1, 4), month = date_str:sub(6, 7), day = date_str:sub(9, 10) }
  local label = os.date("%A, %Y-%m-%d", os.time(t))

  -- Example:
  -- # Monday, 2026-05-25 - Daily
  --
  -- ---
  return "# " .. label .. " - Daily\n\n---"
end

local function slugify(title)
  if not title or title == "" then return require("digia.brain.uuid").v7() end
  return title:lower():gsub("[^%w%s-]", ""):gsub("%s+", "-"):gsub("%-+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
end

local function open_daily_file(date_str, ws)
  ws = ws or brain.active_workspace()
  if not ws then
    vim.notify("No brain workspace configured", vim.log.levels.ERROR)
    return
  end
  local dir = ws.path .. "/daily"
  local path = dir .. "/" .. date_str .. ".md"
  if vim.fn.filereadable(path) == 0 then
    vim.fn.mkdir(dir, "p")
    local f = io.open(path, "w")
    if f then f:write(daily_template(date_str)); f:close() end
  end
  vim.cmd("edit " .. vim.fn.fnameescape(path))
end

local function open_daily(offset)
  local d = os.date("*t")
  d.day = d.day + (offset or 0)
  open_daily_file(os.date("%Y-%m-%d", os.time(d)))
end

local function ensure_brain_id()
  local uuid = require("digia.brain.uuid")
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  if #lines > 0 and lines[1] == "---" then
    local end_idx
    for i = 2, math.min(#lines, 20) do
      if lines[i] == "---" then end_idx = i; break end
    end
    if not end_idx then
      vim.notify("Malformed frontmatter: no closing ---", vim.log.levels.ERROR)
      return
    end
    for i = 2, end_idx - 1 do
      local existing = lines[i]:match("^id:%s+(.+)$")
      if existing then
        vim.notify("ID exists: " .. existing)
        return
      end
    end
    local id = uuid.v7()
    vim.api.nvim_buf_set_lines(0, 1, 1, false, { "id: " .. id })
    vim.notify("Brain ID: " .. id)
  else
    local id = uuid.v7()
    vim.api.nvim_buf_set_lines(0, 0, 0, false, { "---", "id: " .. id, "---", "" })
    vim.notify("Brain ID: " .. id)
  end
end

local function brain_capture()
  local ws = brain.active_workspace()
  if not ws then
    vim.notify("No brain workspace configured", vim.log.levels.ERROR)
    return
  end
  vim.ui.input({ prompt = "Capture: " }, function(input)
    if not input or input == "" then return end
    local entry = "- " .. os.date("%Y-%m-%d %H:%M") .. " " .. input
    local inbox = ws.path .. "/inbox.md"
    if vim.fn.filereadable(inbox) == 0 then
      vim.fn.mkdir(vim.fn.fnamemodify(inbox, ":h"), "p")
      local f = io.open(inbox, "w")
      if f then f:write("# Inbox\n\n"); f:close() end
    end
    local f = io.open(inbox, "a")
    if f then f:write(entry .. "\n"); f:close() end
    vim.notify("Captured to inbox")
  end)
end

local function obsidian_workspaces()
  return brain.workspaces()
end

return {
  {
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",

    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
    },

    keys = {
      { "<leader>bd", function() open_daily(0) end,  desc = "Brain: today's daily" },
      { "<leader>by", function() open_daily(-1) end, desc = "Brain: yesterday" },
      { "<leader>bt", function() open_daily(1) end,  desc = "Brain: tomorrow" },
      { "<leader>bD", "<cmd>BrainDate<CR>",          desc = "Brain: pick date" },
      { "<leader>bc", brain_capture,                  desc = "Brain: capture to inbox" },
      { "<leader>bb", "<cmd>Obsidian backlinks<CR>",  desc = "Brain: backlinks" },
      { "<leader>bI", ensure_brain_id,               desc = "Brain: ensure UUID" },
      { "<leader>bs", "<cmd>Obsidian search<CR>",    desc = "Brain: vault search" },
    },

    config = function()
      require("obsidian").setup({
        workspaces = obsidian_workspaces(),
        frontmatter = { enabled = false },
        note_id_func = function(title) return slugify(title) end,
        link = { style = "wiki" },
        daily_notes = { enabled = false },
        ui = { enable = false },
        footer = {
          format = "{{backlinks}} backlinks  {{words}} words  {{chars}} chars",
        },
        legacy_commands = false,
        checkbox = {
          enabled = true,
          order = { " ", "/", "x", "-", ">", "?", "!" },
        },
      })

      vim.api.nvim_create_user_command("BrainId", ensure_brain_id, { desc = "Generate UUID v7 frontmatter id" })
      vim.api.nvim_create_user_command("BrainDaily", function() open_daily(0) end, { desc = "Open today's daily" })
      vim.api.nvim_create_user_command("BrainYesterday", function() open_daily(-1) end, { desc = "Open yesterday's daily" })
      vim.api.nvim_create_user_command("BrainTomorrow", function() open_daily(1) end, { desc = "Open tomorrow's daily" })
      vim.api.nvim_create_user_command("BrainDate", function()
        vim.ui.input({ prompt = "Date (YYYY-MM-DD): " }, function(input)
          if not input or input == "" then return end
          if not input:match("^%d%d%d%d%-%d%d%-%d%d$") then
            vim.notify("Invalid date. Use YYYY-MM-DD.", vim.log.levels.ERROR)
            return
          end
          open_daily_file(input)
        end)
      end, { desc = "Open daily for a specific date" })
      vim.api.nvim_create_user_command("BrainCapture", brain_capture, { desc = "Capture to inbox" })
      vim.api.nvim_create_user_command("BrainBacklinks", "Obsidian backlinks", { desc = "Show backlinks" })
      vim.api.nvim_create_user_command("BrainSearch", "Obsidian search", { desc = "Search vault" })
    end,
  },
}
