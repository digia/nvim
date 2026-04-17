local opt = vim.opt_local

opt.wrap = true
opt.conceallevel = 0
opt.concealcursor = "nc"

vim.keymap.set("n", "<leader>rp", function()
  if vim.wo.conceallevel > 0 then
    vim.wo.conceallevel = 0
    vim.notify("Org: raw markup")
  else
    vim.wo.conceallevel = 2
    vim.notify("Org: reader mode")
  end
end, { buffer = 0, desc = "Toggle org render (raw/reader)" })

-- Close :PROPERTIES: / :LOGBOOK: drawers on open.
-- org_startup_folded = "content" sets foldlevel=1, so drawers inside headings
-- (fold level 2) are already closed. File-level drawers sit at fold level 1
-- and stay open — close those to match Emacs's startup behavior.
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

vim.schedule(close_drawers)
