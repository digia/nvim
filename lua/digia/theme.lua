local M = {}

-- Helper function to abbreviate color names for display
local function abbreviate_name(name, max_length)
  if #name <= max_length then
    return name
  end

  -- Try intelligent abbreviation
  local abbrev = name:gsub("_", "")  -- Remove underscores first
  if #abbrev <= max_length then
    return abbrev
  end

  -- Try removing vowels from middle
  abbrev = name:gsub("([^aeiou_])([aeiou]+)([^aeiou_])", "%1%3")
  if #abbrev <= max_length then
    return abbrev
  end

  -- Last resort: truncate with ellipsis
  return name:sub(1, max_length - 1) .. "."
end

-- Get colors from the currently active theme
-- Returns a table of color_name = hex_value pairs
function M.get_colors()
  local colors = {}

  -- Try to get colors from Tokyonight if it's active
  local current_colorscheme = vim.g.colors_name

  if current_colorscheme and current_colorscheme:find("^tokyonight") then
    -- Tokyonight stores colors in a specific module
    local ok, tokyonight_colors = pcall(require, "tokyonight.colors")
    if ok then
      -- Get the current style's colors
      local theme_colors = tokyonight_colors.setup()

      -- Extract all color values
      for name, value in pairs(theme_colors) do
        if type(value) == "string" and value:match("^#%x%x%x%x%x%x$") then
          colors[name] = value
        elseif type(value) == "table" then
          -- Handle nested tables like git colors
          for sub_name, sub_value in pairs(value) do
            if type(sub_value) == "string" and sub_value:match("^#%x%x%x%x%x%x$") then
              colors[name .. "_" .. sub_name] = sub_value
            end
          end
        end
      end
    end
  end

  -- TODO: Add support for other themes (Catppuccin, Nord, etc.)
  -- TODO: Add fallback to extract from highlight groups if theme not recognized

  return colors
end

-- Show colors in a scratch buffer
function M.show_colors()
  local colors = M.get_colors()

  -- Create a new buffer
  local buf = vim.api.nvim_create_buf(false, true) -- nofile, scratch buffer

  -- Set buffer options
  vim.api.nvim_set_option_value('buftype', 'nofile', {buf = buf})
  vim.api.nvim_set_option_value('bufhidden', 'wipe', {buf = buf})
  vim.api.nvim_set_option_value('modifiable', true, {buf = buf})
  vim.api.nvim_set_option_value('filetype', 'lua', {buf = buf})

  -- Sort colors alphabetically first
  local sorted_colors = {}
  for name, _ in pairs(colors) do
    table.insert(sorted_colors, name)
  end
  table.sort(sorted_colors)

  -- Create horizontal split at bottom (adjust size based on color count)
  local window_height = math.min(30, 10 + #sorted_colors * 4)
  vim.cmd('botright ' .. window_height .. 'split')
  local win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(win, buf)

  -- Set window options for better viewing
  vim.api.nvim_set_option_value('wrap', false, {win = win})
  vim.api.nvim_set_option_value('cursorline', true, {win = win})

  -- Prepare content
  local lines = {
    "-- Theme Colors (" .. (vim.g.colors_name or "unknown") .. ")",
    "-- Color Matrix: Shows each color as foreground (FG) and background (BG) with all other colors",
    "",
  }

  if #sorted_colors == 0 then
    table.insert(lines, "-- No colors found for current theme")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    return
  end

  -- Calculate column widths
  local name_col_width = 8  -- Minimum width for "Name" column
  local hex_col_width = 7   -- Width for hex values
  local cell_width = 8      -- Width for each color cell

  -- Find longest color name for first column
  for _, name in ipairs(sorted_colors) do
    name_col_width = math.max(name_col_width, #name)
  end

  -- Create header row
  local header = string.format("%-" .. name_col_width .. "s | %-" .. hex_col_width .. "s |", "Name", "Hex")
  for _, color_name in ipairs(sorted_colors) do
    local display_name = abbreviate_name(color_name, cell_width)
    header = header .. string.format(" %-" .. cell_width .. "s |", display_name)
  end
  table.insert(lines, header)

  -- Add separator line
  local separator = string.rep("-", name_col_width) .. "-+-" .. string.rep("-", hex_col_width) .. "-+"
  for _ = 1, #sorted_colors do
    separator = separator .. string.rep("-", cell_width + 2) .. "+"
  end
  table.insert(lines, separator)

  -- Generate three rows for each color
  for _, name in ipairs(sorted_colors) do
    local hex = colors[name]

    -- Row 1: Color name and hex value
    local row1 = string.format("%-" .. name_col_width .. "s | %-" .. hex_col_width .. "s |", name, hex)
    -- Add empty cells for alignment
    for _ = 1, #sorted_colors do
      row1 = row1 .. string.format(" %-" .. cell_width .. "s |", "")
    end
    table.insert(lines, row1)

    -- Row 2: FG preview row
    local row2 = string.format("%-" .. name_col_width .. "s | %-" .. hex_col_width .. "s |", "FG", "")
    for _, other_name in ipairs(sorted_colors) do
      local display_name = abbreviate_name(other_name, cell_width)
      row2 = row2 .. string.format(" %-" .. cell_width .. "s |", display_name)
    end
    table.insert(lines, row2)

    -- Row 3: BG preview row
    local row3 = string.format("%-" .. name_col_width .. "s | %-" .. hex_col_width .. "s |", "BG", "")
    for _, other_name in ipairs(sorted_colors) do
      local display_name = abbreviate_name(other_name, cell_width)
      row3 = row3 .. string.format(" %-" .. cell_width .. "s |", display_name)
    end
    table.insert(lines, row3)

    -- Add blank line between color groups
    table.insert(lines, "")
  end

  -- Set buffer content
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Create namespace for highlights
  local ns = vim.api.nvim_create_namespace('theme_color_matrix')

  -- Create highlight groups for all color combinations
  for i, color_name in ipairs(sorted_colors) do
    local color_hex = colors[color_name]

    for j, other_name in ipairs(sorted_colors) do
      local other_hex = colors[other_name]

      -- FG combination: current color as foreground, other as background
      local fg_group = string.format("TC_fg_%d_%d", i, j)
      vim.api.nvim_set_hl(0, fg_group, { fg = color_hex, bg = other_hex })

      -- BG combination: other color as foreground, current as background
      local bg_group = string.format("TC_bg_%d_%d", i, j)
      vim.api.nvim_set_hl(0, bg_group, { fg = other_hex, bg = color_hex })
    end
  end

  -- Add usage instructions
  table.insert(lines, string.rep("-", 80))
  table.insert(lines, "-- Navigation: Use arrow keys or hjkl to move around the matrix")
  table.insert(lines, "-- FG row: Shows the color name as foreground text on various backgrounds")
  table.insert(lines, "-- BG row: Shows various colors as text on the current color's background")

  -- Apply highlighting to matrix cells
  local header_lines = 5  -- Title, description, blank line, header row, separator

  for i, color_name in ipairs(sorted_colors) do
    -- Calculate line numbers for this color's rows
    local base_line = header_lines + (i - 1) * 4  -- 3 rows + 1 blank line per color
    local fg_line = base_line + 1  -- FG row
    local bg_line = base_line + 2  -- BG row

    -- Calculate starting column position for cells (after name and hex columns)
    local cell_start = name_col_width + 3 + hex_col_width + 3  -- +3 for " | "

    -- Apply highlights to each cell in FG and BG rows
    for j, other_name in ipairs(sorted_colors) do
      local cell_pos = cell_start + (j - 1) * (cell_width + 3)  -- +3 for " | "

      -- Highlight FG row cell
      local fg_group = string.format("TC_fg_%d_%d", i, j)
      vim.api.nvim_buf_add_highlight(buf, ns, fg_group, fg_line, cell_pos, cell_pos + cell_width)

      -- Highlight BG row cell
      local bg_group = string.format("TC_bg_%d_%d", i, j)
      vim.api.nvim_buf_add_highlight(buf, ns, bg_group, bg_line, cell_pos, cell_pos + cell_width)
    end
  end
end

return M
