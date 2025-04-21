local palette = {
  base00 = "#343f44",
  base01 = "#343f44",
  base02 = "#475258",
  base03 = "#859289",
  base04 = "#9da9a0",
  base05 = "#d3c6aa",
  base06 = "#e6e2cc",
  base07 = "#fdf6e3",
  base08 = "#e67e80",
  base09 = "#e69875",
  base0A = "#dbbc7f",
  base0B = "#a7c080",
  base0C = "#83c092",
  base0D = "#7fbbb3",
  base0E = "#d699b6",
  base0F = "#9da9a0",
}

if palette then
  require("mini.base16").setup({ palette = palette, use_cterm = nil })
  vim.g.colors_name = "everforest"
end
