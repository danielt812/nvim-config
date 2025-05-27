local diff = require("mini.diff")

diff.setup({
  view = {
    style = "sign",
    signs = { add = "+", change = "~", delete = "-" },
    priority = 199,
  },
  source = nil,
  delay = {
    text_change = 200,
  },
  mappings = {
    apply = "gh",
    reset = "gH",
    textobject = "gh",
    goto_first = "[H",
    goto_prev = "[h",
    goto_next = "]h",
    goto_last = "]H",
  },

  -- Various options
  options = {
    algorithm = "histogram",
    indent_heuristic = true,
    linematch = 60,
    wrap_goto = false,
  },
})

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

au("User", {
  group = augroup("minidiff_summary", { clear = true }),
  pattern = "MiniDiffUpdated",
  desc = "Format Mini Diff summary string with colors for statusline",
  callback = function(data)
    local summary = vim.b[data.buf] and vim.b[data.buf].minidiff_summary

    if type(summary) ~= "table" then
      return
    end

    local symbols = {
      add = "%#MiniStatuslineDiffAdd#",
      change = "%#MiniStatuslineDiffChange#",
      delete = "%#MiniStatuslineDiffDelete#",
    }

    local t = {}
    for key, icon in pairs(symbols) do
      local count = summary[key]
      if type(count) == "number" and count > 0 then
        table.insert(t, icon .. " " .. count)
      end
    end

    -- Reset highlight after diff summary
    table.insert(t, "%*")

    vim.b[data.buf].minidiff_summary_string = table.concat(t, " ")
  end,
})
