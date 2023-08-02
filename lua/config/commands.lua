vim.api.nvim_create_user_command("BufferKill", function()
  require("utils.buf_kill").buf_kill("bd")
end, { force = true })

vim.api.nvim_create_user_command("ToggleRelative", function()
  require("utils.toggle_rel").toggle_rel()
end, {})
