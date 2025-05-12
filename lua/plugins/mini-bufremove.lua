local M = { "echasnovski/mini.bufremove" }

M.enabled = true

M.event = { "VeryLazy" }

M.keys = {
  {
    "<leader>bd",
    function()
      _G.bufdelete(0, false)
    end,
    desc = "Delete",
  },
  {
    "<leader>bw",
    function()
      _G.bufwipeout(0, false)
    end,
    desc = "Wipeout",
  },
}

M.opts = function()
  return {
    -- Whether to set Vim's settings for buffers (allow hidden buffers)
    set_vim_settings = true,

    -- Whether to disable showing non-error feedback
    silent = false,
  }
end

M.config = function(_, opts)
  require("mini.bufremove").setup(opts)

  local open_starter_if_empty_buffer = function()
    local buf_id = vim.api.nvim_get_current_buf()
    local is_empty = vim.api.nvim_buf_get_name(buf_id) == "" and vim.bo[buf_id].filetype == ""
    if not is_empty then
      return
    end

    require("mini.starter").open()
    vim.cmd(buf_id .. "bwipeout")
  end

  _G.bufdelete = function(...)
    require("mini.bufremove").delete(...)
    open_starter_if_empty_buffer()
  end

  _G.bufwipeout = function(...)
    require("mini.bufremove").wipeout(...)
    open_starter_if_empty_buffer()
  end
end

return M
