local M = {}

local loaded = false
local data = {}

local function load()
  if loaded then return end
  loaded = true

  local path = vim.fn.stdpath("config") .. "/local.lua"
  if vim.fn.filereadable(path) == 0 then return end

  local ok, result = pcall(dofile, path)
  if not ok then
    vim.notify("Failed to load local.lua: " .. tostring(result), vim.log.levels.WARN)
    return
  end
  if type(result) == "table" then
    data = result
  end
end

function M.get(key, default)
  load()
  local v = data[key]
  if v == nil then return default end
  return v
end

return M
