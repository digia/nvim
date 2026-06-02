local text = require("digia.util.text")

local function range_of(opts)
  return opts.range > 0 and opts.line1 .. "," .. opts.line2 or "."
end

-- Focused per-category command: cleanse one category, report its own label.
local function register(name, category, label)
  vim.api.nvim_create_user_command(name, function(opts)
    local changed = text.cleanse({ category }, range_of(opts), opts)
    vim.notify(changed and ("Cleansed " .. label) or ("No " .. label .. " found"))
  end, {
    range = true,
    bang = true,
    desc = "Convert " .. label .. " to ASCII. Use ! for confirmation mode",
  })
end

register("CleanseQuotes", "quotes", "smart quotes")
register("CleanseDashes", "dashes", "dashes")
register("CleanseEllipsis", "ellipsis", "ellipsis")
register("CleanseArrows", "arrows", "arrows")

-- Umbrella: run every category minus any `--<category>` excluded on the command line.
vim.api.nvim_create_user_command("CleanseUTF8", function(opts)
  local excluded = {}
  for _, arg in ipairs(opts.fargs) do
    local key = arg:match("^%-%-(%a+)$")
    if key and text.categories[key] then
      excluded[key] = true
    end
  end

  local keys = {}
  for key in pairs(text.categories) do
    if not excluded[key] then
      table.insert(keys, key)
    end
  end

  local changed = text.cleanse(keys, range_of(opts), opts)
  vim.notify(changed and "Cleansed UTF-8" or "No UTF-8 chars found")
end, {
  range = true,
  bang = true,
  nargs = "*",
  complete = function(arglead, cmdline)
    local tokens = {}
    for key in pairs(text.categories) do
      local token = "--" .. key
      if token:find(arglead, 1, true) == 1 and not cmdline:find(token, 1, true) then
        table.insert(tokens, token)
      end
    end
    table.sort(tokens)
    return tokens
  end,
  desc = "Convert UTF-8 chars to ASCII; exclude with --quotes/--dashes/--ellipsis/--arrows. Use ! for confirmation mode",
})
