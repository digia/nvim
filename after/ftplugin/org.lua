local opt = vim.opt_local

opt.wrap = true
opt.conceallevel = 0
opt.concealcursor = "nc"

opt.textwidth = 100
opt.formatoptions:append("n") -- recognize lists when formatting (gq)
opt.formatoptions:append("q") -- allow gq on comments/quotes
-- bullets: - + *   numbered: 1. 1)   either can carry a checkbox [ ] / [x] / [-]
opt.formatlistpat = [[^\s*[-*+]\s\+\(\[[ xX-]\]\s\+\)\?\|^\s*\d\+[.)]\s\+\(\[[ xX-]\]\s\+\)\?]]

-- Kill orgmode's auto-indent. `indent/org.lua` forces autoindent=true and an
-- indentexpr that carries context-aware indentation onto `o`/`O`. We prefer
-- folding as the structural indicator, so flatten all of it.
-- Deferred because orgmode lazy-loads *after* this ftplugin, and its
-- `indent/org.lua` would clobber these otherwise.
vim.schedule(function()
  vim.bo.autoindent = false
  vim.bo.smartindent = false
  vim.bo.cindent = false
  vim.bo.indentexpr = ""
  vim.bo.indentkeys = ""
end)

vim.keymap.set("n", "<leader>rp", function()
  if vim.wo.conceallevel > 0 then
    vim.wo.conceallevel = 0
    vim.notify("Org: raw markup")
  else
    vim.wo.conceallevel = 2
    vim.notify("Org: reader mode")
  end
end, { buffer = 0, desc = "Toggle org render (raw/reader)" })

-- nvim-orgmode ignores file-level `#+STARTUP:` fold directives — it only
-- honors the global `org_startup_folded` config. Parse them ourselves and
-- apply the right foldlevel, mirroring Emacs org-mode's set of directives
-- (overview, content, showall, showeverything, show{N}levels).
local STARTUP_FOLD = {
  overview       = 0,
  content        = 1,
  showall        = 99,
  showeverything = 99,
}

local function startup_fold_override()
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, 40, false)) do
    local val = line:lower():match("^#%+startup:%s*(.+)$")
    if val then
      for tok in val:gmatch("%S+") do
        local n = tok:match("^show(%d+)levels$")
        if n then return tonumber(n) end
        if STARTUP_FOLD[tok] then return STARTUP_FOLD[tok] end
      end
    end
  end
  return nil
end

-- Close :PROPERTIES: / :LOGBOOK: drawers on open — except when the file says
-- to show everything. org_startup_folded = "content" sets foldlevel=1, so
-- drawers inside headings (fold level 2) are already closed; file-level
-- drawers sit at fold level 1 and stay open — close those to match Emacs.
local function close_drawers()
  local ok, parser = pcall(vim.treesitter.get_parser, 0, "org")
  if not ok or not parser then return end
  local tree = parser:parse()[1]
  if not tree then return end
  local query = vim.treesitter.query.parse("org", "[(property_drawer) (drawer)] @d")
  for _, node in query:iter_captures(tree:root(), 0) do
    local srow = node:range()
    local lnum = srow + 1
    if vim.fn.foldclosed(lnum) == -1 then
      pcall(vim.cmd, lnum .. "foldclose")
    end
  end
end

vim.schedule(function()
  local override = startup_fold_override()
  if override then
    vim.wo.foldlevel = override
    if override >= 99 then return end -- show everything: leave drawers alone
  end
  close_drawers()
end)

