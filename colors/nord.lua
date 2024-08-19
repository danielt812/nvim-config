local palette = {
  base00 = "#282828",
  -- base01 = "#3B4252",
  base01 = "#282828",
  base02 = "#434C5E",
  base03 = "#4C566A",
  base04 = "#D8DEE9",
  base05 = "#E5E9F0",
  base06 = "#ECEFF4",
  base07 = "#8FBCBB",
  base08 = "#88C0D0",
  base09 = "#81A1C1",
  base0A = "#5E81AC",
  base0B = "#BF616A",
  base0C = "#D08770",
  base0D = "#EBCB8B",
  base0E = "#A3BE8C",
  base0F = "#B48EAD",
}

if palette then
  require("mini.base16").setup({ palette = palette, use_cterm = nil })
  vim.g.colors_name = "oxocarbon"
end
