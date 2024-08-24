vim.api.nvim_create_user_command("BufferClose", function()
  require("utils.buf_kill").buf_kill("bd")
end, { force = true })
