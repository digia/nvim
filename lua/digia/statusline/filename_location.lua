-- Wrapper which combines the filename and location components
-- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/filename.lua
-- https://github.com/nvim-lualine/lualine.nvim/blob/master/lua/lualine/components/location.lua

local M = require('lualine.component'):extend()

local modules = require('lualine_require').lazy_require({
  utils = 'lualine.utils.utils',
})

local PATH_SEP = package.config:sub(1, 1)

local default_options = {
  symbols = {
    modified = '[+]',
    readonly = '[-]',
    unnamed = '[No Name]',
    newfile = '[New]',
  },
  file_status = true,
  newfile_status = false,
  path = 0,
  shorting_target = 60,
}

local function is_new_file()
  local filename = vim.fn.expand('%')
  return filename ~= ''
    and filename:match('^%a+://') == nil
    and vim.bo.buftype == ''
    and vim.fn.filereadable(filename) == 0
end

local function shorten_path(path, sep, max_len)
  local len = #path
  if len <= max_len then
    return path
  end

  local segments = vim.split(path, sep)
  for idx = 1, #segments - 1 do
    if len <= max_len then
      break
    end
    local segment = segments[idx]
    local shortened = segment:sub(1, vim.startswith(segment, '.') and 2 or 1)
    segments[idx] = shortened
    len = len - (#segment - #shortened)
  end

  return table.concat(segments, sep)
end

M.init = function(self, options)
  M.super.init(self, options)
  self.options = vim.tbl_deep_extend('keep', self.options or {}, default_options)
end

M.update_status = function(self)
  local winid = vim.g.statusline_winid or vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local is_focused = winid == vim.api.nvim_get_current_win()
  local ft = vim.bo[bufnr].filetype
  local is_special = vim.bo[bufnr].buftype ~= '' or ft:match('^fugitive') or ft:match('^git')

  local cursor = vim.api.nvim_win_get_cursor(winid)
  local line_num = cursor[1]
  local position

  if is_focused and not is_special then
    local mode = vim.api.nvim_get_mode().mode
    local is_visual = mode:match('[vV\22]')

    local col = vim.api.nvim_win_call(winid, function()
      return vim.fn.virtcol('.')
    end)

    if is_visual then
      local vline = vim.fn.line('v')
      local min_line = math.min(line_num, vline)
      local max_line = math.max(line_num, vline)
      if min_line == max_line then
        position = string.format(':%d:%d', min_line, col)
      else
        position = string.format(':%d-%d:%d', min_line, max_line, col)
      end
    else
      position = string.format(':%d:%d', line_num, col)
    end
  else
    position = string.format(':%d:%d', line_num, cursor[2] + 1)
  end

  local symbol_segments = {}
  if self.options.file_status then
    if vim.bo[bufnr].modified then
      table.insert(symbol_segments, self.options.symbols.modified)
    end
    if not vim.bo[bufnr].modifiable or vim.bo[bufnr].readonly then
      table.insert(symbol_segments, self.options.symbols.readonly)
    end
  end
  if self.options.newfile_status and is_new_file() then
    table.insert(symbol_segments, self.options.symbols.newfile)
  end
  local symbols = (#symbol_segments > 0 and ' ' .. table.concat(symbol_segments, '') or '')

  local data
  if self.options.path == 1 then
    data = vim.fn.expand('%:~:.')
  elseif self.options.path == 2 then
    data = vim.fn.expand('%:p')
  elseif self.options.path == 3 then
    data = vim.fn.expand('%:p:~')
  else
    data = vim.fn.expand('%:t')
  end

  if data == '' then
    data = self.options.symbols.unnamed
  end

  if (self.options.shorting_target or 0) ~= 0 then
    local windwidth = self.options.globalstatus and vim.go.columns or vim.fn.winwidth(0)
    local suffix_width = vim.api.nvim_strwidth(position .. symbols)
    local estimated_space_available = windwidth - self.options.shorting_target - suffix_width

    data = shorten_path(data, PATH_SEP, estimated_space_available)
  end

  data = modules.utils.stl_escape(data)

  return data .. position .. symbols
end

return M
