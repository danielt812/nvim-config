local M = { "echasnovski/mini.diff" }

M.enabled = true

M.event = { "BufReadPost" }

M.opts = function()
  local diff = require("mini.diff")

  return {
    -- Options for how hunks are visualized
    view = {
      -- Visualization style. Possible values are 'sign' and 'number'.
      -- Default: 'number' if line numbers are enabled, 'sign' otherwise.
      style = "sign",

      -- Signs used for hunks with 'sign' view
      signs = { add = "+", change = "~", delete = "-" },

      -- Priority of used visualization extmarks
      priority = 199,
    },

    -- Source(s) for how reference text is computed/updated/etc
    -- Uses content from Git index by default
    source = { diff.gen_source.git(), diff.gen_source.save() },

    -- Delays (in ms) defining asynchronous processes
    delay = {
      -- How much to wait before update following every text change
      text_change = 200,
    },

    -- Module mappings. Use `''` (empty string) to disable one.
    mappings = {
      -- Apply hunks inside a visual/operator region
      apply = "gh",

      -- Reset hunks inside a visual/operator region
      reset = "gH",

      -- Hunk range textobject to be used inside operator
      -- Works also in Visual mode if mapping differs from apply and reset
      textobject = "gh",

      -- Go to hunk range in corresponding direction
      goto_first = "[H",
      goto_prev = "[h",
      goto_next = "]h",
      goto_last = "]H",
    },

    -- Various options
    options = {
      -- Diff algorithm. See `:h vim.diff()`.
      algorithm = "histogram",

      -- Whether to use "indent heuristic". See `:h vim.diff()`.
      indent_heuristic = true,

      -- The amount of second-stage diff to align lines (in Neovim>=0.9)
      linematch = 60,

      -- Whether to wrap around edges during hunk navigation
      wrap_goto = false,
    },
  }
end

M.config = function(_, opts)
  require("mini.diff").setup(opts)

  local mini_diff_augroup = vim.api.nvim_create_augroup("mini_diff_augroup", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = mini_diff_augroup,
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
end

return M
