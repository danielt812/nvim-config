vim.api.nvim_create_user_command("BufferKill", function()
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
