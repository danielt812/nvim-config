local M = { "FabijanZulj/blame.nvim" }

M.enabled = true

M.cmd = { "ToggleBlame", "EnableBlame", "DisableBlame" }

M.opts = function()
  return {
    date_format = "%Y/%m/%d %H:%M", -- string - Pattern for the date
    width = 50, -- number - fixed width of the window (default: width of longest blame line + 8)
    virtual_style = "right_align", -- "right_align" or "float" - Float moves the virtual text close to the content of the file
    merge_consecutive = true, -- boolean - Merge consecutive blames that are from the same commit
  }
end

M.config = function(_, opts)
  require("blame").setup(opts)
end

return M
