local M = {}

M.print_table = function(tbl, indent)
  indent = indent or 0       -- Default to 0 if no indent is provided
  for k, v in pairs(tbl) do
    -- Indentation for better readability
    local prefix = string.rep("  ", indent)
    if type(v) == "table" then
      print(prefix .. k .. ":")
      M.print_table(v, indent + 1)       -- Recursive call with increased indent
    else
      print(prefix .. k .. ": " .. tostring(v))
    end
  end
end

return M
