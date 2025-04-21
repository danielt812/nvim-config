local M = { "echasnovski/mini.base16" }

M.enabled = true

M.event = { "VimEnter" }

M.priority = 1000

M.config = function()
  vim.cmd("colorscheme everforest")

  local comment_hl = vim.api.nvim_get_hl(0, { name = "Comment", link = false })

  -- Reapply it with italic
  comment_hl.italic = true

  vim.api.nvim_set_hl(0, "Comment", comment_hl)

  local kind_links = {
    Text = "Statement",
    Method = "Function",
    Function = "Function",
    Constructor = "Type",
    Field = "Structure",
    Variable = "Identifier",
    Class = "Type",
    Interface = "Type",
    Module = "Include",
    Property = "Identifier",
    Unit = "Number",
    Value = "Number",
    Enum = "Type",
    Keyword = "Keyword",
    Snippet = "Special",
    Color = "Special",
    File = "Directory",
    Reference = "Identifier",
    Folder = "Directory",
    EnumMember = "Constant",
    Constant = "Constant",
    Struct = "Structure",
    Event = "Exception",
    Operator = "Operator",
    TypeParameter = "Type",
  }

  for kind, link in pairs(kind_links) do
    vim.api.nvim_set_hl(0, "BlinkCmpKind" .. kind, { link = link })
  end
end

return M
