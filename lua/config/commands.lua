vim.api.nvim_create_user_command("BufferClose", function()
  require("utils.buf_kill").buf_kill("bd")
end, { force = true })

vim.api.nvim_create_user_command("ToggleRelative", function()
  require("utils.toggle").toggle_rel()
end, {})

vim.api.nvim_create_user_command("ToggleHighlight", function()
  require("utils.toggle").toggle_hl()
end, {})

vim.api.nvim_create_user_command("ToggleSpell", function()
  require("utils.toggle").toggle_spell()
end, {})

vim.api.nvim_create_user_command("ToggleWrap", function()
  require("utils.toggle").toggle_wrap()
end, {})

vim.api.nvim_create_user_command("ToggleDiagnostic", function()
  require("utils.toggle").toggle_diagnostic()
end, {})
