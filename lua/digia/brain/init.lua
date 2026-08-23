local local_config = require("digia.local_config")

local M = {}

local _WORKSPACES = nil

local function resolve_workspaces()
  if _WORKSPACES then return _WORKSPACES end

  local specs = local_config.get("brain_workspaces", {
    { name = "brain", path = "~/Code/digia/digia-brain/kb" },
  })

  _WORKSPACES = {}
  for _, spec in ipairs(specs) do
    local expanded = vim.fn.expand(spec.path)
    if vim.fn.isdirectory(expanded) == 1 then
      table.insert(_WORKSPACES, {
        name = spec.name,
        path = expanded,
      })
    end
  end

  return _WORKSPACES
end

function M.workspaces()
  return resolve_workspaces()
end

function M.is_vault_buffer(bufname)
  bufname = bufname or vim.api.nvim_buf_get_name(0)
  if bufname == "" then return false end
  bufname = vim.fn.resolve(bufname)
  for _, ws in ipairs(resolve_workspaces()) do
    if bufname:find(ws.path, 1, true) == 1 then return true end
  end
  return false
end

function M.active_workspace(bufname)
  bufname = bufname or vim.api.nvim_buf_get_name(0)
  if bufname ~= "" then
    bufname = vim.fn.resolve(bufname)
    for _, ws in ipairs(resolve_workspaces()) do
      if bufname:find(ws.path, 1, true) == 1 then return ws end
    end
  end

  local cwd = vim.fn.getcwd()
  for _, ws in ipairs(resolve_workspaces()) do
    if cwd:find(ws.path, 1, true) == 1 then return ws end
  end

  local workspaces = resolve_workspaces()

  -- First workspace is considered the default
  return workspaces[1]
end

function M.foldlevel()
  -- Fold at H3 and below for second brain documents
  return local_config.get("brain_foldlevel", 3)
end

return M
