local M = { "echasnovski/mini.pick" }

M.enabled = true

M.cmd = { "Pick" }

M.keys = {
  { "<leader>fe", "<cmd>Pick explorer<cr>", desc = "Explorer" },
  { "<leader>ff", "<cmd>Pick files<cr>", desc = "Files" },
  { "<leader>fg", "<cmd>Pick grep_live<cr>", desc = "Livegrep" },
  { "<leader>fl", "<cmd>Pick hl_groups<cr>", desc = "Highlights" },
  { "<leader>fh", "<cmd>Pick help<cr>", desc = "Help" },
  { "<leader>fk", "<cmd>Pick keymaps<cr>", desc = "Keymaps" },
}

M.opts = function()
  local minipick = require("mini.pick")
  return {
    mappings = {
      move_down = "<C-j>",
      move_start = "<C-g>",
      move_up = "<C-k>",
      sys_paste = {
        char = "<C-v>",
        func = function()
          minipick.set_picker_query({ vim.fn.getreg("+") })
        end,
      },
    },
  }
end

M.config = function(_, opts)
  require("mini.pick").setup(opts)

  local minipick_settings_group = vim.api.nvim_create_augroup("minipick_settings_group", { clear = true })

  vim.api.nvim_create_autocmd("User", {
    group = minipick_settings_group,
    pattern = { "MiniPickStart", "MiniPickStop" },
    desc = "Toggle tabline when opening MiniPick",
    callback = function()
      local filetypes = {
        ministarter = false,
        oil = false,
        lazy = false,
        mason = false,
      }
      local hide_tabline = false
      local win_ids = vim.api.nvim_list_wins()

      for _, win_id in ipairs(win_ids) do
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id })

        if filetypes[buf_ft] ~= nil then
          hide_tabline = true
          break
        end
      end

      if hide_tabline then
        vim.opt.showtabline = 0
      else
        vim.opt.showtabline = 2
      end
    end,
  })
end

return M
