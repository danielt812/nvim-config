local M = { "FabijanZulj/blame.nvim" }

M.enabled = true

M.cmd = { "BlameToggle" }

M.keys = {
  { "<leader>gB", "<cmd>BlameToggle<cr>", desc = "Blame File  " },
}

M.opts = function()
  return {
    date_format = "%Y/%m/%d %H:%M", -- string - Pattern for the date
    virtual_style = "right_align", -- "right_align" or "float" - Float moves the virtual text close to the content of the file
    max_summary_width = 30,
    merge_consecutive = true,
    mappings = {
      commit_info = "i",
      stack_push = "<TAB>",
      stack_pop = "<BS>",
      show_commit = "<CR>",
      commit_detail_view = "vsplit", -- 'current' | 'tab' | 'vsplit' | 'split'
      close = { "<Esc>", "q" },
    },
  }
end

M.config = function(_, opts)
  require("blame").setup(opts)

  local blame_au_group = vim.api.nvim_create_augroup("Blame group", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = blame_au_group,
    pattern = "BlameViewOpened",
    callback = function(event)
      local blame_type = event.data
      if blame_type == "window" then
        require("lualine").hide({
          place = { "winbar" },
          unhide = false,
        })
        vim.opt_local.wrap = false
      end
    end,
  })

  vim.api.nvim_create_autocmd("User", {
    group = blame_au_group,
    pattern = "BlameViewClosed",
    callback = function(event)
      local blame_type = event.data
      if blame_type == "window" then
        require("lualine").hide({
          place = { "winbar" },
          unhide = true,
        })
        vim.opt_local.wrap = true
      end
    end,
  })
end

return M
