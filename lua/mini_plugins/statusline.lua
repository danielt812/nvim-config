local statusline = require("mini.statusline")
local icons = require("mini.icons")

statusline.setup({
  content = {
    active = function()
      local combine_strings = function(tbl, seperator)
        seperator = seperator and " " .. seperator .. " " or " "
        return { table.concat(vim.fn.filter(tbl, function(_, v) return v ~= nil and v ~= "" end), seperator) }
      end

      local section_git = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local summary = vim.b.minigit_summary
        if type(summary) ~= "table" then return "" end

        local branch = summary.head_name
        if not branch then return "" end

        local icon = args.icon and "" .. " " or ""
        return icon .. "%#MiniStatuslineGit#" .. branch .. "%#MiniStatuslineDevinfo#"
      end

      local section_diff = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

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
        return icon .. table.concat(diffs, "|")
      end

      local function section_diagnostics(args)
        -- stylua: ignore
        local levels = {
          { name = "ERROR", sign = "" },
          { name = "WARN",  sign = "" },
          { name = "INFO",  sign = "" },
          { name = "HINT",  sign = "" },
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

      local section_filename = function(args)
        if vim.bo.buftype == "toggleterm" then return "%t" end

        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "%t %h" end

        return "%f %h"
      end

      local section_filetype = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local ft = vim.bo.filetype or "none"
        if ft == "toggleterm" then return nil end

        local icon, hl_name = icons.get("filetype", ft, { with_hl = true })
        local color = hl_name:gsub("MiniIcons", "MiniStatuslineIcons")

        local fileinfo = string.format("%%#%s#%s %%#MiniStatuslineFileinfo#%s", color or "", icon, ft)

        return fileinfo
      end

      local section_disabled = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local plugins = {
          animate = "A",
          hipatterns = "H",
          indentscope = "I",
          pairs = "P",
        }

        local disabled = {}

        for plugin, symbol in pairs(plugins) do
          local g = vim.g["mini" .. plugin .. "_disable"]
          local b = vim.b["mini" .. plugin .. "_disable"]
          if g or b then table.insert(disabled, symbol) end
        end

        if #disabled == 0 then return "" end

        local icon = args.icon and "󱐤" .. " " or ""

        return icon .. "[" .. table.concat(disabled, ",") .. "]"
      end

      local section_spell = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local spell = vim.wo.spell and "󰓆" or ""

        return spell
      end

      local section_shift_width = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local shiftwidth = "󰌒 " .. vim.bo.shiftwidth

        return shiftwidth
      end

      local section_searchcount = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local in_search = vim.fn.getcmdtype() == "/" or vim.fn.getcmdtype() == "?"
        if vim.v.hlsearch == 0 and not in_search then return "" end

        local pattern = in_search and vim.fn.getcmdline() or vim.fn.getreg("/")
        if pattern == "" then return "" end

        local ok, s_count = pcall(vim.fn.searchcount, { recompute = true, pattern = pattern })
        if not ok or s_count.current == nil or s_count.total == 0 then return "" end

        if s_count.incomplete == 1 then return "?/?" end

        local too_many = ">" .. s_count.maxcount

        local current = s_count.current > s_count.maxcount and too_many or s_count.current
        local total = s_count.total > s_count.maxcount and too_many or s_count.total

        return current .. "/" .. total
      end

      local section_location = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local ft = vim.bo.filetype or "none"
        if ft == "toggleterm" then return nil end

        local line = vim.fn.line(".")
        local col = vim.fn.col(".")

        return line .. ":" .. col
      end

      local section_progress = function(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local ft = vim.bo.filetype or "none"
        if ft == "toggleterm" then return nil end

        return "%P"
      end

      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })
      local git = section_git({ trunc_width = 70, icon = true })
      local diff = section_diff({ trunc_width = 70, icon = true, symbols = false })
      local diagnostics = section_diagnostics({ trunc_width = 70, icon = true, symbols = false })
      local filename = section_filename({ trunc_width = 120 })
      local filetype = section_filetype({ trunc_width = 120 })
      local shiftwidth = section_shift_width({ trunc_width = 120 })
      local disabled = section_disabled({ trunc_width = 70, icon = true })
      local spell = section_spell({ trunc_width = 120 })
      local searchcount = section_searchcount({ trunc_width = 70 })
      local location = section_location({ trunc_width = 70 })
      local progress = section_progress({ trunc_width = 70 })

      return statusline.combine_groups({
        { hl = mode_hl, strings = combine_strings({ mode }, "│") },
        { hl = "MiniStatuslineDevinfo", strings = combine_strings({ git, diff, diagnostics }, "│") },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = combine_strings({ filename }, "│") },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = combine_strings({ disabled, spell, shiftwidth, filetype }, "│") },
        { hl = mode_hl, strings = combine_strings({ searchcount, location, progress }, "│") },
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

local redraw_status = function()
  local cmdtype = vim.fn.getcmdtype()
  if cmdtype == "/" or cmdtype == "?" then vim.cmd("redrawstatus") end
end

vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = "*",
  group = group,
  desc = "Redraw statusline on search",
  callback = redraw_status,
})
