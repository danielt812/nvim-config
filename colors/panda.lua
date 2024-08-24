local palette

palette = {
  base00 = "#242526",
  base01 = "#242526",
  base02 = "#31353a",
  base03 = "#373B41",
  base04 = "#757575",
  base05 = "#E6E6E6",
  base06 = "#CDCDCD",
  base07 = "#FFFFFF",
  base08 = "#FF2C6D",
  base09 = "#FFB86C",
  base0A = "#FFCC95",
  base0B = "#19f9d8",
  base0C = "#45A9F9",
  base0D = "#6FC1FF",
  base0E = "#B084EB",
  base0F = "#FF75B5",
}

if palette then
  require("mini.base16").setup({ palette = palette, use_cterm = nil })
  vim.g.colors_name = "panda"
end
