local cmdline = require("mini.cmdline")

cmdline.setup({
  -- Autocompletion: show `:h 'wildmenu'` as you type
  autocomplete = {
    enable = true,

    -- Delay (in ms) after which to trigger completion
    -- Neovim>=0.12 is recommended for positive values
    delay = 0,

    -- Custom rule of when to trigger completion
    predicate = nil,

    -- Whether to map arrow keys for more consistent wildmenu behavior
    map_arrows = true,
  },

  -- Autocorrection: adjust non-existing words (commands, options, etc.)
  autocorrect = {
    enable = true,

    -- Custom autocorrection rule
    func = nil,
  },

  -- Autopeek: show command's target range in a floating window
  autopeek = {
    enable = true,

    -- Number of lines to show above and below range lines
    n_context = 5,

    -- Custom rule of when to show peek window
    predicate = function(data)
      local line = vim.fn.getcmdline()
      if not line:match("%d") then return false end
      return cmdline.default_autopeek_predicate(data)
    end,

    -- Window options
    window = {
      -- Floating window config
      config = function()
        local peek_mark = vim.g.peek_mark
        if peek_mark then return { title = " Peek mark " .. peek_mark .. " " } end
        return {}
      end,

      -- Function to render statuscolumn
      statuscolumn = function(data)
        local n, l, r = vim.v.lnum, data.left, data.right
        local hl = (n >= l and n <= r) and "MiniCmdlinePeekSign" or "LineNr"
        return "%#" .. hl .. "#" .. n .. " "
      end,
    },
  },
})

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_cmdline", { clear = true })

vim.api.nvim_create_autocmd("CmdlineLeave", {
  group = group,
  desc = "Clear peek_mark",
  callback = function() vim.g.peek_mark = nil end,
})

-- #############################################################################
-- #                               User Commands                               #
-- #############################################################################

vim.api.nvim_create_user_command("Peek", function(opts)
  local args = vim.split(opts.args, "%s+", { trimempty = true })
  if #args < 1 or #args > 2 then
    vim.notify("Peek requires 1 or 2 local marks (a-z)", vim.log.levels.WARN)
    return
  end
  for _, char in ipairs(args) do
    if not char:match("^[a-z]$") then
      vim.notify("Peek requires local marks (a-z), got '" .. char .. "'", vim.log.levels.WARN)
      return
    end
    if vim.api.nvim_buf_get_mark(0, char)[1] == 0 then
      vim.notify("Mark '" .. char .. "' not set", vim.log.levels.WARN)
      return
    end
  end
  local pos1 = vim.api.nvim_buf_get_mark(0, args[1])[1]
  if #args == 1 then
    vim.g.peek_mark = args[1]
    vim.api.nvim_input(":" .. pos1)
  else
    local pos2 = vim.api.nvim_buf_get_mark(0, args[2])[1]
    vim.g.peek_mark = args[1] .. "-" .. args[2]
    vim.api.nvim_input(":" .. pos1 .. "," .. pos2)
  end
end, { nargs = "+" })
