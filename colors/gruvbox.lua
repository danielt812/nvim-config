local palette = {
  base00 = "#282828",
  base01 = "#282828",
  base02 = "#504945",
  base03 = "#665c54",
  base04 = "#bdae93",
  base05 = "#d5c4a1",
  base06 = "#ebdbb2",
  base07 = "#fbf1c7",
  base08 = "#fb4934",
  base09 = "#fe8019",
  base0A = "#fabd2f",
  base0B = "#b8bb26",
  base0C = "#8ec07c",
  base0D = "#83a598",
  base0E = "#d3869b",
  base0F = "#d65d0e",
}

if palette then
  require("mini.base16").setup({ palette = palette, use_cterm = nil })
  vim.g.colors_name = "gruvbox"
end

