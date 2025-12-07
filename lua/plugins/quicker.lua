local quicker = require("quicker")

local expand = function()
  quicker.expand()
end

local collapse = function()
  quicker.collapse()
end

quicker.setup({
  -- Local options to set for quickfix
  opts = {
    buflisted = false,
    number = false,
    relativenumber = false,
    signcolumn = "auto",
    winfixheight = true,
    wrap = false,
  },
  -- Set to false to disable the default options in `opts`
  use_default_opts = true,
  -- Keymaps to set for the quickfix buffer
  keys = {
    { "<cr>", "<cr>", desc = "Jump to position" },
    { ">", expand, desc = "Expand quickfix content" },
    { "<", collapse, desc = "Expand quickfix content" },
  },
  edit = {
    -- Enable editing the quickfix like a normal buffer
    enabled = true,
    -- Set to true to write buffers after applying edits.
    -- Set to "unmodified" to only write unmodified buffers.
    autosave = "unmodified",
  },
  -- Keep the cursor to the right of the filename and lnum columns
  constrain_cursor = true,
  highlight = {
    -- Use treesitter highlighting
    treesitter = true,
    -- Use LSP semantic token highlighting
    lsp = true,
    -- Load the referenced buffers to apply more accurate highlights (may be slow)
    load_buffers = false,
  },
  follow = {
    -- When quickfix window is open, scroll to closest item to the cursor
    enabled = true,
  },
  -- Map of quickfix item type to icon
  type_icons = {
    E = "󰅚 ",
    W = "󰀪 ",
    I = " ",
    N = " ",
    H = " ",
  },
  -- How to trim the leading whitespace from results. Can be 'all', 'common', or false
  trim_leading_whitespace = "common",
  -- Maximum width of the filename column
  max_filename_width = function()
    return math.floor(math.min(95, vim.o.columns / 2))
  end,
  -- How far the header should extend to the right
  header_length = function(type, start_col)
    return vim.o.columns - start_col
  end,
})

local open_diagnostics = function()
  vim.diagnostic.setqflist({ bufnr = 0 })
end

vim.keymap.set("n", "<leader>qd", open_diagnostics, { desc = "Diagnostics" })
