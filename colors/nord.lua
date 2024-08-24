local palette = {
  base00 = "#282828",
  base01 = "#282828",
  base02 = "#434c5e",
  base03 = "#4c566a",
  base04 = "#d8dee9",
  base05 = "#e5e9f0",
  base06 = "#eceff4",
  base07 = "#8fbcb3",
  base08 = "#88c0d0",
  base09 = "#81a1c1",
  base0a = "#5e81ac",
  base0b = "#bf616a",
  base0c = "#d08770",
  base0d = "#ebcb8b",
  base0e = "#a3be8c",
  base0f = "#b48ead",
}

if palette then
  require("mini.base16").setup({ palette = palette, use_cterm = nil })
  vim.g.colors_name = "nord"
end
