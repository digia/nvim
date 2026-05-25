local bit = require("bit")
local band, bor, rshift = bit.band, bit.bor, bit.rshift

local M = {}

local function random_byte()
  return math.floor(math.random() * 256)
end

function M.v7()
  local sec, usec = vim.uv.gettimeofday()
  local ms = sec * 1000 + math.floor(usec / 1000)

  local ms_hi = math.floor(ms / 0x10000)
  local ms_lo = ms % 0x10000

  local b = {}
  for i = 1, 16 do b[i] = random_byte() end

  -- bytes 0-5: 48-bit timestamp (big-endian)
  b[1] = band(rshift(ms_hi, 24), 0xFF)
  b[2] = band(rshift(ms_hi, 16), 0xFF)
  b[3] = band(rshift(ms_hi, 8), 0xFF)
  b[4] = band(ms_hi, 0xFF)
  b[5] = band(rshift(ms_lo, 8), 0xFF)
  b[6] = band(ms_lo, 0xFF)

  -- byte 6-7: version 7 (0111 in high nibble of byte 6)
  b[7] = bor(band(b[7], 0x0F), 0x70)

  -- byte 8: variant 10xx xxxx
  b[9] = bor(band(b[9], 0x3F), 0x80)

  return string.format(
    "%02x%02x%02x%02x-%02x%02x-%02x%02x-%02x%02x-%02x%02x%02x%02x%02x%02x",
    b[1], b[2], b[3], b[4], b[5], b[6], b[7], b[8],
    b[9], b[10], b[11], b[12], b[13], b[14], b[15], b[16]
  )
end

return M
