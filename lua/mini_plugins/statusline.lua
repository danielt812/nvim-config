local statusline = require("mini.statusline")
local icons = require("mini.icons")

statusline.setup({
  content = {
    active = function()
      -- NOTE these are custom highlight groups that are not part of MiniNvim
      local diagnostic_icons = { ERROR = "", WARN = "", INFO = "", HINT = "" }
      local diagnostic_symbols = {}

      for severity, icon in pairs(diagnostic_icons) do
        diagnostic_symbols[severity] =
          string.format("%%#MiniStatuslineDiagnostic%s#%s %%#MiniStatuslineDevinfo#", severity, icon)
      end

      local function section_fileinfo(trunc_width)
        local ft = vim.bo.filetype or "none"
        local shiftwidth = "󰌒 " .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })

        if ft == "toggleterm" then return nil end

        local icon, hl_name = icons.get("filetype", ft, { with_hl = true })
        local color = hl_name:gsub("MiniIcons", "MiniStatuslineIcons")

        local fileinfo = string.format("%%#%s#%s %%#MiniStatuslineFileinfo#%s", color or "", icon, ft)
        local truncate = statusline.is_truncated(trunc_width)

        return truncate and fileinfo or shiftwidth .. " " .. fileinfo
      end

      local function section_location(trunc_width)
        local ft = vim.bo.filetype or "none"
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")
        local truncate = statusline.is_truncated(trunc_width)

        if ft == "toggleterm" then return nil end

        return truncate and "" or string.format("%d:%d", line, col)
      end

      local section_progress = function(trunc_width)
        local progressbar = function()
          local current_line = vim.fn.line(".")
          local total_lines = vim.fn.line("$")
          local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
          local line_ratio = current_line / total_lines
          local index = math.ceil(line_ratio * #chars)
          return chars[index]
        end

        local ft = vim.bo.filetype or "none"
        local truncate = statusline.is_truncated(trunc_width)

        if ft == "toggleterm" then return nil end

        return truncate and "%P" or "%P" -- .. " " .. progressbar()
      end

      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 100 })
      local diff = statusline.section_diff({ trunc_width = 100, icon = "" })
      local diagnostics = statusline.section_diagnostics({ trunc_width = 75, icon = "", signs = diagnostic_symbols })
      local filename = statusline.section_filename({ trunc_width = 240 })
      local fileinfo = section_fileinfo(120)
      local searchcount = statusline.section_searchcount({ trunc_width = 80 })
      local location = section_location(80)
      local progress = section_progress(80)

      return statusline.combine_groups({
        { hl = mode_hl, strings = { mode } },
        { hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = { filename } },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
        { hl = mode_hl, strings = { searchcount, location, "│", progress } },
      })
    end,
  },
})

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

--- Create new highlight with inherited fg and bg of two existing groups
--- @param fg_name string
--- @param bg_name string
--- @param new_name string
local merge_hl = function(fg_name, bg_name, new_name)
  local fg_hl = vim.api.nvim_get_hl(0, { name = fg_name, link = false })
  local bg_hl = vim.api.nvim_get_hl(0, { name = bg_name, link = false })
  local fg, bg = fg_hl.fg, bg_hl.bg
  vim.api.nvim_set_hl(0, new_name, { fg = fg, bg = bg })
end

local apply_hl = function()
  local prefix = "MiniStatusline"
  -- Diagnostics
  for _, suffix in ipairs({ "Error", "Warn", "Info", "Hint" }) do
    merge_hl("Diagnostic" .. suffix, prefix .. "Devinfo", prefix .. "Diagnostic" .. suffix)
  end
  -- Diff
  for _, suffix in ipairs({ "Add", "Change", "Delete" }) do
    merge_hl("MiniDiffSign" .. suffix, prefix .. "Devinfo", prefix .. "Diff" .. suffix)
  end
  -- Icons
  for _, suffix in ipairs({ "Azure", "Blue", "Cyan", "Green", "Grey", "Orange", "Magenta", "Red", "Yellow" }) do
    merge_hl("MiniIcons" .. suffix, prefix .. "Fileinfo", prefix .. "Icons" .. suffix)
  end
end

-- Call once when this module is loaded
apply_hl()

local au_group = vim.api.nvim_create_augroup("mini_statusline", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  group = au_group,
  desc = "Generate icon highlights",
  callback = apply_hl,
})
