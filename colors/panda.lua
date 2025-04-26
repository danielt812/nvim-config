local palette = {
  base00 = "#292a2b",
  base01 = "#292a2b",
  base02 = "#373b41",
  base03 = "#757575",
  base04 = "#cdcdcd",
  base05 = "#ffffff",
  base06 = "#e6e6e6",
  base07 = "#ffb86c",
  base08 = "#ff2c6d",
  base09 = "#ffcc95",
  base0A = "#ff9ac1",
  base0B = "#19f9d8",
  base0C = "#6fe7d2",
  base0D = "#6fc1ff",
  base0E = "#b084eb",
  base0F = "#ff75b5",
}

if palette then
  require("mini.base16").setup({ palette = palette, use_cterm = nil })
  vim.g.colors_name = "panda"
end
