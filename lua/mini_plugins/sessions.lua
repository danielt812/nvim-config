local sessions = require("mini.sessions")

sessions.setup()

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local delete_session = function() sessions.select("delete") end
local select_session = function() sessions.select("read") end
local write_session = function()
  if vim.v.this_session ~= "" then return sessions.write() end

  local name = vim.fn.input("New session: ")

  if name == "" then return vim.notify("Session name required", vim.log.levels.ERROR) end

  sessions.write(name)
end

vim.keymap.set("n", "<leader>sd", delete_session, { desc = "Delete" })
vim.keymap.set("n", "<leader>ss", select_session, { desc = "Select" })
vim.keymap.set("n", "<leader>sw", write_session, { desc = "Write" })
-- stylua: ignore end
