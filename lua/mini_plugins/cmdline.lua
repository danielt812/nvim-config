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
    predicate = nil,

    -- Window options
    window = {
      -- Floating window config
      config = function()
        local peek_mark = vim.g.peek_mark
        if peek_mark then return { title = " Peek (mark) " .. peek_mark .. " " } end
        return {}
      end,

      -- Function to render statuscolumn
      statuscolumn = nil,
    },
  },
})

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_cmdline", { clear = true })

vim.api.nvim_create_autocmd("CmdlineLeave", {
  pattern = "*",
  group = group,
  desc = "Clear peek_mark",
  callback = function() vim.g.peek_mark = nil end,
})

-- #############################################################################
-- #                               User Commands                               #
-- #############################################################################

vim.api.nvim_create_user_command("Peek", function(opts)
  local char = opts.args
  if not char:match("^[a-z]$") then
    vim.notify("Peek requires a local mark (a-z)", vim.log.levels.WARN)
    return
  end
  local pos = vim.api.nvim_buf_get_mark(0, char)
  if pos[1] == 0 then
    vim.notify("Mark '" .. char .. "' not set", vim.log.levels.WARN)
    return
  end
  vim.g.peek_mark = char
  vim.api.nvim_input(":" .. pos[1])
end, { nargs = 1 })
