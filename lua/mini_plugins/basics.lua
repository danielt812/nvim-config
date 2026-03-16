local basics = require("mini.basics")

basics.setup({
  options = {
    basic = true,
    extra_ui = false,
    win_borders = "rounded",
  },
  mappings = {
    basic = true,
    option_toggle_prefix = "\\",
    windows = true,
    move_with_alt = true,
  },
  autocommands = {
    basic = false,
    relnum_in_visual_mode = false,
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local scratch_types = {
  { ft = "html" },
  { ft = "javascript", ext = "js" },
  { ft = "typescript", ext = "ts" },
  { ft = "json" },
  { ft = "lua" },
  { ft = "markdown", ext = "md" },
  { ft = "python", ext = "py" },
  { ft = "text", ext = "txt" },
}

-- Create scratch buffer
vim.keymap.set("n", "<leader>bs", function()
  vim.ui.select(scratch_types, {
    prompt = "Filetype:",
    format_item = function(item) return item.ft end,
  }, function(item)
    if item == nil then return end
    vim.ui.input({ prompt = "Name: " }, function(name)
      if name == nil then return end
      local buf = vim.api.nvim_create_buf(true, true)
      vim.api.nvim_win_set_buf(0, buf)
      vim.bo[buf].filetype = item.ft
      if name ~= "" then vim.api.nvim_buf_set_name(buf, name .. "." .. (item.ext or item.ft)) end
    end)
  end)
end, { desc = "Scratch" })
