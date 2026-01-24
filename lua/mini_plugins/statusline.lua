local statusline = require("mini.statusline")
local icons = require("mini.icons")
local components = require("utils.components")

statusline.setup({
  content = {
    active = function()
      -- NOTE  these are custom highlight groups that are not part of mini.nvim
      local diagnostic_icons =
        { ERROR = "", WARN = "", INFO = "", HINT = "" }

      local diagnostic_symbols = {}

      for severity, icon in pairs(diagnostic_icons) do
        diagnostic_symbols[severity] = string.format(
          "%%#MiniStatuslineDiag%s#%s %%#MiniStatuslineDevinfo#",
          severity,
          icon
        )
      end

      local function section_disabled_mods(trunc_width)
        if statusline.is_truncated(trunc_width) then
          return ""
        end
        local pairs = components.pairs({ text = true })
        local prefix = pairs ~= "" and "󱐤" or ""
        return prefix .. pairs
      end

      local function section_fileinfo(trunc_width)
        local truncate = statusline.is_truncated(trunc_width)
        local spell = components.spell({ icon = true, pad = "right" })
        local shift = components.shiftwidth({ icon = true, pad = "both" })

        local ft = vim.bo.filetype or "none"
        local icon, hl = icons.get("filetype", ft)
        local fileinfo = string.format(
          "%%#%s#%s %%#MiniStatuslineFileinfo#%s%%*",
          hl or "",
          icon,
          ft
        )

        return truncate and fileinfo or spell .. shift .. fileinfo
      end

      local function section_location(trunc_width)
        local truncate = statusline.is_truncated(trunc_width)
        local location = components.location({ pad = "both" })
        return truncate and location or location
      end

      local function section_progress(trunc_width)
        local truncate = statusline.is_truncated(trunc_width)
        local percent = "%P"
        local progressbar = components.progressbar({ pad = "left" })

        return truncate and percent or percent .. progressbar
      end

      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 100 })
      local diff = statusline.section_diff({ trunc_width = 100, icon = "" })
      -- stylua: ignore
      local diagnostics = statusline.section_diagnostics({ trunc_width = 75, icon = "", signs = diagnostic_symbols })
      local filename = statusline.section_filename({ trunc_width = 240 })
      local searchcount = statusline.section_searchcount({ trunc_width = 80 })
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
