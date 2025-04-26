local palette = {
  base00 = "#24283b",
  base01 = "#24283b",
  base02 = "#343a52",
  base03 = "#444b6a",
  base04 = "#787c99",
  base05 = "#a9b1d6",
  base06 = "#cbccd1",
  base07 = "#d5d6db",
  base08 = "#2ac3de",
  base09 = "#ffc777",
  base0A = "#0db9d7",
  base0B = "#9ece6a",
  base0C = "#b4f9f8",
  base0D = "#c0caf5",
  base0E = "#bb9af7",
  base0F = "#f7768e",
}

if palette then
  require("mini.base16").setup({ palette = palette, use_cterm = nil })
  vim.g.colors_name = "tokyonight"
end
