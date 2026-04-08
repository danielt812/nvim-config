local statusline = require("mini.statusline")
local icons = require("mini.icons")
local util_hl = require("utils.highlight")

statusline.setup({
  content = {
    active = function()
      local function combine_strings(strings, separator)
        separator = separator and (" " .. separator .. " ") or " "
        local out = {}
        for _, str in ipairs(strings) do
          if str ~= nil and str ~= "" then out[#out + 1] = str end
        end
        return { table.concat(out, separator) }
      end

      local function section_git(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local summary = vim.b.minigit_summary
        if type(summary) ~= "table" then return "" end

        local branch = summary.head_name
        if not branch then return "" end

        local icon = args.icon and "" .. " " or ""
        return icon .. "%#MiniStatuslineGit#" .. branch .. "%#MiniStatuslineDevinfo#"
      end

      local function section_diff(args)
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
        return icon .. table.concat(diffs, args.symbols and " " or "·")
      end

      local function section_diagnostics(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local count = vim.diagnostic.count(0)
        if not count or not vim.diagnostic.is_enabled({ bufnr = 0 }) then return "" end

        -- stylua: ignore
        local levels = {
          { name = "ERROR", sign = "" },
          { name = "WARN",  sign = "" },
          { name = "INFO",  sign = "" },
          { name = "HINT",  sign = "" },
        }

        local severity = vim.diagnostic.severity
        local diagnostics = {}

        for _, level in ipairs(levels) do
          local num = count[severity[level.name]] or 0
          if num > 0 then
            local str
            local hl = "%#MiniStatuslineDiagnostic" .. level.name .. "#"
            if args.symbols then
              str = hl .. level.sign .. " " .. "%#MiniStatuslineDevinfo#" .. num
            else
              str = hl .. num .. "%#MiniStatuslineDevinfo#"
            end
            table.insert(diagnostics, str)
          end
        end

        if #diagnostics == 0 then return "" end
        local icon = args.icon and "" .. " " or ""
        return icon .. table.concat(diagnostics, args.symbols and " " or "·")
      end

      local function section_filename(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate or vim.bo.buftype == "terminal" then return "%t %h" end

        return "%f %h"
      end

      local function section_filetype(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local ft = vim.bo.filetype or "none"
        local icon, hl = icons.get("filetype", ft)
        hl = hl:gsub("MiniIcons", "MiniStatuslineIcons")

        local sw = vim.bo.shiftwidth
        local ts = vim.bo.tabstop
        local indent = "󰌒 " .. (sw > 0 and sw or ts) .. " "

        return indent .. "%#" .. hl .. "#" .. icon .. " %#MiniStatuslineFileinfo#" .. ft
      end

      local function section_disabled(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        -- stylua: ignore
        local plugins = {
          animate     = "A",
          hipatterns  = "H",
          indentscope = "I",
          pairs       = "P",
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

      local function section_options(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate then return "" end

        local hl = "%#MiniStatuslineFileinfo#"
        local parts = {}
        if vim.lsp.inline_completion.is_enabled() then parts[#parts + 1] = "%#MiniStatuslineCopilot#  " .. hl end
        if vim.wo.spell then parts[#parts + 1] = "%#MiniStatuslineSpell#󰓆" .. hl end
        if vim.wo.wrap then parts[#parts + 1] = "%#MiniStatuslineWrap#󰖶" .. hl end

        if #parts == 0 then return "" end

        return table.concat(parts, "  ")
      end

      local function section_searchcount(args)
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

      local function section_location(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate or vim.bo.buftype == "terminal" then return "" end

        local line, col = vim.fn.line("."), vim.fn.col(".")
        return line .. ":" .. col
      end

      local function section_progress(args)
        local truncate = statusline.is_truncated(args.trunc_width)
        if truncate or vim.bo.buftype == "terminal" then return "" end

        return "%P"
      end

      local mode, mode_hl = statusline.section_mode({ trunc_width = 120 })

      -- stylua: ignore start
      local git         = section_git        ({ trunc_width = 70, icon = true })
      local diff        = section_diff       ({ trunc_width = 70, icon = true, symbols = false })
      local diagnostics = section_diagnostics({ trunc_width = 70, icon = true, symbols = false })
      local filename    = section_filename   ({ trunc_width = 120 })
      local filetype    = section_filetype   ({ trunc_width = 30 })
      local disabled    = section_disabled   ({ trunc_width = 70, icon = true })
      local options     = section_options    ({ trunc_width = 70 })
      local searchcount = section_searchcount({ trunc_width = 70 })
      local location    = section_location   ({ trunc_width = 70 })
      local progress    = section_progress   ({ trunc_width = 70 })
      -- stylua: ignore end

      return statusline.combine_groups({
        { hl = mode_hl, strings = combine_strings({ mode }, "│") },
        { hl = "MiniStatuslineDevinfo", strings = combine_strings({ git, diff, diagnostics }, "│") },
        "%<", -- Mark general truncate point
        { hl = "MiniStatuslineFilename", strings = combine_strings({ filename }, "│") },
        "%=", -- End left alignment
        { hl = "MiniStatuslineFileinfo", strings = combine_strings({ disabled, options, filetype }, "│") },
        { hl = mode_hl, strings = combine_strings({ searchcount, location, progress }, "│") },
      })
    end,
  },
})

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local function get_mode_suffix()
  local m = vim.fn.mode():lower()
  local m1 = m:sub(1, 1)
  if m1 == "v" or m == "\022" then return "Visual" end
  if m1 == "c" then return "Command" end
  if m1 == "i" then return "Insert" end
  if m1 == "n" then return "Normal" end
  if m1 == "r" then return "Replace" end
  return "Other"
end

local function link_cursor_line_nr()
  vim.api.nvim_set_hl(0, "CursorLineNr", { link = "CursorLineNr" .. get_mode_suffix() })
end

local function gen_hl_groups()
  local prefix = "MiniStatusline"
  -- Diagnostics
  for _, suffix in ipairs({ "Error", "Warn", "Info", "Hint" }) do
    util_hl.merge_hl("Diagnostic" .. suffix, prefix .. "Devinfo", prefix .. "Diagnostic" .. suffix)
  end
  -- Diff
  for _, suffix in ipairs({ "Add", "Change", "Delete" }) do
    util_hl.merge_hl("MiniDiffSign" .. suffix, prefix .. "Devinfo", prefix .. "Diff" .. suffix)
  end
  -- Icons
  for _, suffix in ipairs({ "Azure", "Blue", "Cyan", "Green", "Grey", "Orange", "Purple", "Red", "Yellow", "White" }) do
    util_hl.merge_hl("MiniIcons" .. suffix, prefix .. "Fileinfo", prefix .. "Icons" .. suffix)
  end
  -- Git
  util_hl.merge_hl("Terminal", prefix .. "Devinfo", prefix .. "Git")
  -- Options
  util_hl.merge_hl("Green", prefix .. "Fileinfo", prefix .. "Spell")
  util_hl.merge_hl("Orange", prefix .. "Fileinfo", prefix .. "Wrap")
  util_hl.merge_hl("White", prefix .. "Fileinfo", prefix .. "Copilot")

  -- Mode line numbers
  -- stylua: ignore
  local mode_hl_suffixes = {
    command = "Command",
    insert  = "Insert",
    normal  = "Normal",
    replace = "Replace",
    visual  = "Visual",
    other   = "Other",
  }

  for _, suffix in pairs(mode_hl_suffixes) do
    local bg = vim.api.nvim_get_hl(0, { name = "MiniStatuslineMode" .. suffix, link = false }).bg
    if bg then vim.api.nvim_set_hl(0, "CursorLineNr" .. suffix, { fg = bg }) end
  end

  link_cursor_line_nr()
end

gen_hl_groups() -- Call this now if colorscheme was already set

local function redraw_status()
  local cmdtype = vim.fn.getcmdtype()
  if cmdtype == "/" or cmdtype == "?" then vim.cmd("redrawstatus") end
end

local group = vim.api.nvim_create_augroup("mini_statusline", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  desc = "Create highlight groups",
  callback = gen_hl_groups,
})

vim.api.nvim_create_autocmd("ModeChanged", {
  pattern = "*",
  group = group,
  desc = "Mode-colored line number",
  callback = link_cursor_line_nr,
})

vim.api.nvim_create_autocmd("CmdlineChanged", {
  pattern = "*",
  group = group,
  desc = "Redraw statusline on search",
  callback = redraw_status,
})
