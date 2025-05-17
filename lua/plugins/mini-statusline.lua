local M = { "echasnovski/mini.statusline" }

M.enabled = false

M.event = { "VeryLazy" }

M.opts = function()
  local statusline = require("mini.statusline")
  return {
    content = {
      active = function()
        -- NOTE these are custom highlight groups that are not part of MiniNvim
        local diagnostic_icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          HINT = "",
        }

        local diagnostic_symbols = {}

        for severity, icon in pairs(diagnostic_icons) do
          diagnostic_symbols[severity] = string.format("%%#MiniStatuslineDiag%s#%s %%*", severity, icon)
        end

        local function section_fileinfo()
          local file_name = vim.fn.expand("%:t")
          local ft = vim.bo.filetype or "none"
          local icon, hl = require("mini.icons").get("file", file_name, { with_hl = true })

          return string.format("%%#%s#%s %%#MiniStatuslineFileinfo#%s%%*", hl or "", icon, ft)
        end

        local function section_location()
          local line = vim.fn.line(".")
          local col = vim.fn.col(".")
          return string.format("%d:%d", line, col)
        end

        local mode, mode_hl = statusline.section_mode({ trunc_width = 75 })
        local git = statusline.section_git({ trunc_width = 100 })
        local diff = statusline.section_diff({ trunc_width = 100, icon = "" })
        local diagnostics = statusline.section_diagnostics({ trunc_width = 75, icon = "", signs = diagnostic_symbols })
        local filename = statusline.section_filename({ trunc_width = 240 })
        local shiftwidth = "󰌒 " .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 }) .. " "

        local searchcount = statusline.section_searchcount({ trunc_width = 120 })

        local fileinfo = section_fileinfo()

        local location = section_location()

        local progress = "%P"
        return statusline.combine_groups({
          { hl = mode_hl, strings = { mode } },
          { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
          { hl = "MiniStatuslineFilename", strings = { filename } },
          "%=", -- End left alignment
          { hl = "MiniStatuslineFileinfo", strings = { shiftwidth, fileinfo } },
          { hl = "MiniStatuslineLocation", strings = { searchcount, location, progress } },
        })
      end,
    },
  }
end

M.config = function(_, opts)
  require("mini.statusline").setup(opts)
end

return M
