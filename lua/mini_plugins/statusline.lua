local statusline = require("mini.statusline")
local icons = require("mini.icons")

statusline.setup({
  content = {
    active = function()
      local function section_diagnostics(args)
        local levels = {
          { name = "ERROR", sign = "" },
          { name = "WARN", sign = "" },
          { name = "INFO", sign = "" },
          { name = "HINT", sign = "" },
        }

        if statusline.is_truncated(args.trunc_width) then return "" end
        local count = vim.diagnostic.count(0)
        if not count or not vim.diagnostic.is_enabled({ bufnr = 0 }) then return "" end

        local severity = vim.diagnostic.severity
        local diagnostics = {}

        for _, level in ipairs(levels) do
          local num = count[severity[level.name]] or 0
          if num > 0 then
            local str
            if args.symbols then
              -- stylua: ignore
              str = string.format("%%#MiniStatuslineDiagnostic%s#%s %d%%#MiniStatuslineDevinfo#", level.name, level.sign, num)
            else
              str = string.format("%%#MiniStatuslineDiagnostic%s#%d%%#MiniStatuslineDevinfo#", level.name, num)
            end
            table.insert(diagnostics, str)
          end
        end

        if #diagnostics == 0 then return "" end
        local icon = args.icon and "" .. " " or ""
        return icon .. table.concat(diagnostics, "|")
      end

      local section_filetype = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end
        local ft = vim.bo.filetype or "none"
        if ft == "toggleterm" then return nil end

        local icon, hl_name = icons.get("filetype", ft, { with_hl = true })
        local color = hl_name:gsub("MiniIcons", "MiniStatuslineIcons")

        local fileinfo = string.format("%%#%s#%s %%#MiniStatuslineFileinfo#%s", color or "", icon, ft)

        return truncate and "" or fileinfo
      end

      local section_shift_width = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        local shiftwidth = "󰌒 " .. vim.bo.shiftwidth
        return truncate and "" or shiftwidth
      end

      local section_spell = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        local spell = vim.wo.spell and "󰓆" or ""
        return truncate and "" or spell
      end

      local section_location = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        local ft = vim.bo.filetype or "none"
        if ft == "toggleterm" then return nil end
        local line = vim.fn.line(".")
        local col = vim.fn.col(".")

        return truncate and "" or string.format("%d:%d", line, col)
      end

      local section_progress = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        local ft = vim.bo.filetype or "none"
        if ft == "toggleterm" then return nil end

        return truncate and "" or "%P"
      end

      local section_diff = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        local summary = vim.b.minidiff_summary

        if type(summary) ~= "table" then return "" end

        local symbols = {
          add = args.symbols and "%#MiniStatuslineDiffAdd#" or "%#MiniStatuslineDiffAdd#",
          change = args.symbols and "%#MiniStatuslineDiffChange#" or "%#MiniStatuslineDiffChange#",
          delete = args.symbols and "%#MiniStatuslineDiffDelete#" or "%#MiniStatuslineDiffDelete#",
        }
        local diffs, has_diff = {}, false

        for key, symbol in pairs(symbols) do
          local count = summary[key]
          if type(count) == "number" and count > 0 then
            symbol = args.symbols and symbol .. " " or symbol
            if not args.symbols then table.insert(diffs, symbol .. count .. "%#MiniStatuslineDevinfo#") end
            if args.symbols then table.insert(diffs, symbol .. "%#MiniStatuslineDevinfo#" .. count) end
            has_diff = true
          end
        end
        if not has_diff then return "" end

        local icon = args.icon and "" .. " " or ""
        return truncate and "" or icon .. table.concat(diffs, "|")
      end

      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = statusline.section_git({ trunc_width = 80 })
      local diff = section_diff({ trunc_width = 80, icon = true, symbols = false })
      local diagnostics = section_diagnostics({ trunc_width = 75, icon = true, signs = false })
      local filename = statusline.section_filename({ trunc_width = 120 })
      local filetype = section_filetype({ trunc_width = 120 })
      local shiftwidth = section_shift_width({ trunc_width = 120 })
      local spell = section_spell({ trunc_width = 120 })
      local searchcount = statusline.section_searchcount({ trunc_width = 80 })
      local location = section_location({ trunc_width = 80 })
      local progress = section_progress({ trunc_width = 80 })

      local gen_string = function(tbl, seperator)
        seperator = seperator and " " .. seperator .. " " or " "
        return { table.concat(vim.fn.filter(tbl, function(_, v) return v ~= nil and v ~= "" end), seperator) }
      end

      return statusline.combine_groups({
        { hl = mode_hl, strings = gen_string({ mode }, "│") },
        { hl = "MiniStatuslineDevinfo", strings = gen_string({ git, diff, diagnostics }, "│") },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = gen_string({ filename }, "│") },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = gen_string({ spell, shiftwidth, filetype }, "│") },
        { hl = mode_hl, strings = gen_string({ searchcount, location, progress }, "│") },
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
  -- Git
  merge_hl("White", prefix .. "Devinfo", prefix .. "Git")
end

-- Call once when this module is loaded
apply_hl()

local group = vim.api.nvim_create_augroup("mini_statusline", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  group = group,
  desc = "Generate icon highlights",
  callback = apply_hl,
})
