local colors = require("mini.colors")

-- Default {L, S} pairs per shade. shade_0 darkest -> shade_9 brightest.
local default_shades = {
  dark = {
    { 6, 65 },
    { 9, 62 },
    { 12, 65 },
    { 15, 65 },
    { 35, 50 },
    { 45, 48 },
    { 48, 60 },
    { 74, 80 },
    { 88, 85 },
    { 92, 88 },
  },
  light = {
    { 10, 100 },
    { 20, 90 },
    { 28, 75 },
    { 65, 55 },
    { 72, 52 },
    { 78, 52 },
    { 82, 52 },
    { 86, 52 },
    { 90, 55 },
    { 95, 55 },
  },
}

local presets = {
  crt = {
    { 6, 65 },
    { 8, 62 },
    { 11, 65 },
    { 15, 65 },
    { 18, 62 },
    { 22, 55 },
    { 22, 40 },
    { 74, 60 },
    { 88, 85 },
    { 92, 95 },
  },
}

local function shade(base_hex, l, s, opts)
  opts = opts or {}
  if opts.achromatic then s = 0 end
  local hue_shift = opts.hue_shift or 20
  local base = colors.convert(base_hex, "okhsl")
  if base == nil then return end
  local h = ((base.h or 0) + hue_shift * (50 - l) / 50) % 360
  return colors.convert({ h = h, s = s, l = l }, "hex")
end

local function gen_monochrome_palette(base_hex, opts)
  opts = opts or {}
  local dark = opts.dark ~= false

  local shades = opts.shades
    or (opts.style and presets[opts.style])
    or (dark and default_shades.dark)
    or default_shades.light

  local palette = {}
  for i, pair in ipairs(shades) do
    local hex = shade(base_hex, pair[1], pair[2], opts)
    if hex == nil then return end
    palette["shade_" .. (i - 1)] = hex
  end
  return palette
end

return {
  gen_monochrome_palette = gen_monochrome_palette,
  shade = shade,
}
