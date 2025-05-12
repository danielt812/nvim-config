local M = { "echasnovski/mini.statusline" }

M.enabled = false

M.event = { "BufReadPre" }

M.opts = function()
  local function hide_in_width()
    return vim.fn.winwidth(0) > 80
  end

  return {
    content = {
      active = function()
        local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
        local git = MiniStatusline.section_git({ trunc_width = 75 })
        local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
        local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 120 })
        local location = MiniStatusline.section_location({ trunc_width = 75 })

        local encoding = vim.bo.fenc ~= "" and vim.bo.fenc or vim.o.enc
        local filetype = vim.bo.filetype ~= "" and vim.bo.filetype or "none"
        local shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
        local spaces = "󰌒 " .. shiftwidth

        local diff = ""
        if hide_in_width() then
          local symbols = { added = " ", modified = " ", removed = " " }
          local git_stats = vim.b.gitsigns_status_dict or {}
          diff = (git_stats.added and git_stats.added > 0) and (symbols.added .. git_stats.added .. " ") or ""
          diff = diff
            .. ((git_stats.changed and git_stats.changed > 0) and (symbols.modified .. git_stats.changed .. " ") or "")
          diff = diff
            .. ((git_stats.removed and git_stats.removed > 0) and (symbols.removed .. git_stats.removed) or "")
        end

        local progress = MiniStatusline.section_searchcount({ trunc_width = 120 }) .. " %P"

        return MiniStatusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diagnostics, diff } },
          { hl = "MiniStatuslineFilename", strings = { fileinfo } },
          "%<",
          { hl = "MiniStatuslineFileinfo", strings = { spaces, encoding, filetype } },
          { hl = "MiniStatuslineLocation", strings = { location, progress } },
        })
      end,
    },
  }
end

M.config = function(_, opts)
  require("mini.statusline").setup(opts)
end

return M
