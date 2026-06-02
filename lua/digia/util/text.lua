-- NOTE: This module intentionally holds literal UTF-8 characters in
-- `M.categories` -- they are match data: the smart quotes, dashes, ellipsis,
-- and arrows we convert to ASCII. The project ASCII-only write policy does NOT
-- apply here; these bytes ARE the feature. If a tool ever normalizes them
-- (smart quotes -> straight quotes), the patterns silently stop matching.
-- Verify integrity: grep -nP '[^\x00-\x7F]' lua/digia/util/text.lua

local M = {}

-- Substitution pairs are Vim :substitute patterns (character classes, literal
-- multibyte chars) -- NOT Lua gsub. No class contains its own replacement, so a
-- match always changes text, keeping the changenr-based detection honest.
-- Box-drawing chars (U+2500-U+257F) are never a category, so directory-tree art
-- survives every cleanse.
M.categories = {
  quotes   = { { '[“”„‟]', '"' }, { "[‘’‚‛]", "'" } },
  dashes   = { { "—", "--" }, { "–", "-" }, { "−", "-" } },
  ellipsis = { { "…", "..." } },
  arrows   = { { "→", "->" }, { "←", "<-" }, { "↑", "^" }, { "↓", "v" } },
}

-- Runs the :substitute pairs for `category_keys` over `range`.
-- `opts.bang` appends Vim's `c` flag (confirm mode: prompt y/n per match).
-- Returns true if any substitution changed the buffer.
function M.cleanse(category_keys, range, opts)
  local flags = "ge" .. (opts.bang and "c" or "")
  local save_pos = vim.fn.getpos(".")
  local save_search = vim.fn.getreg("/")
  local changenr_before = vim.fn.changenr()

  for _, key in ipairs(category_keys) do
    for _, pair in ipairs(M.categories[key]) do
      vim.cmd(string.format("silent! %ss/%s/%s/%s", range, pair[1], pair[2], flags))
    end
  end

  -- Confirm mode leaves the cursor where the user landed; otherwise restore it.
  if not opts.bang then
    vim.fn.setpos(".", save_pos)
  end
  vim.fn.setreg("/", save_search)

  return vim.fn.changenr() > changenr_before
end

return M
