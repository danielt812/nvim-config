local statusline = require("mini.statusline")
local icons = require("mini.icons")
local components = require("utils.components")

statusline.setup({
  content = {
    active = function()
      -- NOTE  these are custom highlight groups that are not part of mini.nvim
      local diagnostic_levels = { ERROR = "", WARN = "", INFO = "", HINT = "" }
      local diagnostic_symbols = {}

      for severity, icon in pairs(diagnostic_levels) do
        diagnostic_symbols[severity] =
          string.format("%%#MiniStatuslineDiag%s#%s %%#MiniStatuslineDevinfo#", severity, icon)
      end

      local section_disabled_mods = function(trunc_width)
        if statusline.is_truncated(trunc_width) then return "" end
        local pairs = components.pairs({ text = true })
        local prefix = pairs ~= "" and "󱐤" or ""
        return prefix .. pairs
      end

      local section_fileinfo = function(trunc_width)
        local truncate = statusline.is_truncated(trunc_width)
        local spell = components.spell({ icon = true, pad = "right" })
        local shift = components.shiftwidth({ icon = true, pad = "both" })

        local ft = vim.bo.filetype or "none"
        local icon, hl = icons.get("filetype", ft)
        local fileinfo = string.format("%%#%s#%s %%#MiniStatuslineFileinfo#%s%%*", hl or "", icon, ft)

        return truncate and fileinfo or spell .. shift .. fileinfo
      end

      local section_location = function(trunc_width)
        local truncate = statusline.is_truncated(trunc_width)
        local location = components.location({ pad = "both" })
        return truncate and location or location
      end

      local section_progress = function(trunc_width)
        local truncate = statusline.is_truncated(trunc_width)
        local progressbar = components.progressbar({ pad = "left" })

        return truncate and "%P" or "%P" .. progressbar
      end

      local section_filename = function(trunc_width)
        local truncate = statusline.is_truncated(trunc_width)

        if vim.bo.buftype == "terminal" then
          return "%t"
        else
          return truncate and "%f" or "%F"
        end
      end

      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 100 })
      local diff = statusline.section_diff({ trunc_width = 100, icon = "" })
      local diagnostics = statusline.section_diagnostics({ trunc_width = 75, icon = "", signs = diagnostic_symbols })
      local searchcount = statusline.section_searchcount({ trunc_width = 80 })
      local filename = section_filename(120)
      local disabled = section_disabled_mods(80)
      local fileinfo = section_fileinfo(120)
      local location = section_location(100)
      local progress = section_progress(120)

      return statusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = { disabled, fileinfo } },
        { hl = "MiniStatuslineLocation", strings = { searchcount, location } },
        { hl = mode_hl, strings = { progress } },
      })
    end,
  },
})
