local M = { "echasnovski/mini.tabline" }

M.enabled = false

M.event = { "BufReadPre", "BufNew" }

M.opts = function()
  return {
    show_icons = true,

    format = function(buf_id, label)
      local listed_buffers = vim.fn.getbufinfo({ buflisted = 1 })

      -- Determine if current buffer is the last listed one
      local is_last = listed_buffers[#listed_buffers].bufnr == buf_id
      local sep = (not is_last and #listed_buffers > 1) and "│" or ""

      local suffix = ""
      if vim.bo[buf_id].modified then
        suffix = "●"
      elseif vim.bo[buf_id].readonly or not vim.bo[buf_id].modifiable then
        suffix = ""
      end

      return require("mini.tabline").default_format(buf_id, label) .. suffix -- .. sep
    end,

    tabpage_section = "right",
  }
end

M.config = function(_, opts)
  require("mini.tabline").setup(opts)
end

return M
