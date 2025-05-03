local palette = {
  base00 = "#2d353b",
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
  require("mini.base16").setup({ palette = palette })
  vim.g.colors_name = "everforest"

  -- vim.api.nvim_set_hl(0, "SignColumn", { link = "Normal" })

  for _, v in pairs({ "Nr", "NrAbove", "NrBelow" }) do
    local line_hl = vim.api.nvim_get_hl(0, { name = "Line" .. v, link = false })
    line_hl = vim.tbl_deep_extend("force", line_hl, { bg = palette.base00 })
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_set_hl(0, "Line" .. v, line_hl)
  end

  for _, v in pairs({ "Add", "Delete", "Change", "Untracked" }) do
    local sign_hl = vim.api.nvim_get_hl(0, { name = "GitSigns" .. v, link = false })
    sign_hl = vim.tbl_deep_extend("force", sign_hl, { bg = palette.base00 })
    ---@diagnostic disable-next-line: param-type-mismatch
    vim.api.nvim_set_hl(0, "GitSigns" .. v, sign_hl)
  end
end
