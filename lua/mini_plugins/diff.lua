local diff = require("mini.diff")

diff.setup({
  view = {
    style = "sign",
    signs = { add = "+", change = "~", delete = "-" },
    priority = 1,
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

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local au_group = vim.api.nvim_create_augroup("mini_diff", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniDiffUpdated",
  group = au_group,
  desc = "Format Mini Diff summary string with colors for statusline",
  callback = function(data)
    local summary = vim.b[data.buf] and vim.b[data.buf].minidiff_summary

    if type(summary) ~= "table" then return end

    local symbols = {
      add = "%#MiniStatuslineDiffAdd#",
      change = "%#MiniStatuslineDiffChange#",
      delete = "%#MiniStatuslineDiffDelete#",
    }

    local diffs = {}
    local has_diff = false

    for key, icon in pairs(symbols) do
      local count = summary[key]
      if type(count) == "number" and count > 0 then
        table.insert(diffs, icon .. "%#MiniStatuslineDevinfo#" .. " " .. count)
        has_diff = true
      end
    end

    if not has_diff then
      vim.b[data.buf].minidiff_summary_string = nil
      return
    end

    vim.b[data.buf].minidiff_summary_string = table.concat(diffs, " ")
  end,
})
