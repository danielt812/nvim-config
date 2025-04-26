local palette = {
  base00 = "#1e1e1e",
  base01 = "#252526",
  base02 = "#373737",
  base03 = "#5a5a5a",
  base04 = "#7c7c7c",
  base05 = "#d4d4d4",
  base06 = "#e9e9e9",
  base07 = "#ffffff",
  base08 = "#f44747",
  base09 = "#ce9178",
  base0A = "#dcdcaa",
  base0B = "#6a9955",
  base0C = "#4ec9b0",
  base0D = "#569cd6",
  base0E = "#c586c0",
  base0F = "#d16969",
}

if palette then
  require("mini.base16").setup({ palette = palette, use_cterm = nil })
  vim.g.colors_name = "vscode"
end
