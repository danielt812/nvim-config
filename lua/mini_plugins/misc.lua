local misc = require("mini.misc")

local cache = {}

misc.setup({
  make_global = { "put", "put_text" },
})

misc.setup_restore_cursor()
misc.setup_termbg_sync()

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local function zoom()
  misc.zoom()
  -- stylua: ignore
  if vim.api.nvim_win_get_config(0).relative == "" then return end

  vim.wo.number = true
  vim.wo.relativenumber = true
  vim.wo.winhighlight = "NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal"
end

-- NOTE: Uses nvim_open_win directly instead of misc.zoom because zoom clamps
-- height to (lines - cmdheight - border) ignoring row offset, which prevents
-- the float from being short enough to reveal the global statusline (laststatus=3).
-- See compute_config in misc.lua: line 845
local function centered_zoom()
  local is_float = vim.api.nvim_win_get_config(0).relative ~= ""

  -- Closing: restore the source window
  if is_float then
    vim.api.nvim_win_close(0, true)
    if cache.dim_win and vim.api.nvim_win_is_valid(cache.dim_win) then
      vim.api.nvim_set_current_win(cache.dim_win)
      if cache.dim_id then vim.fn.matchdelete(cache.dim_id, cache.dim_win) end
      for k, v in pairs(cache.dim_opts) do
        vim.wo[cache.dim_win][k] = v
      end
    end
    vim.opt.laststatus = cache.laststatus
    cache.zoom_win = nil
    cache.dim_id = nil
    cache.dim_win = nil
    cache.dim_opts = nil
    cache.laststatus = nil
    return
  end

  -- Opening: dim and minimalize the source window
  cache.dim_win = vim.api.nvim_get_current_win()
  local bg = vim.api.nvim_get_hl(0, { name = "Normal", link = false }).bg
  vim.api.nvim_set_hl(0, "ZoomBlank", { fg = bg, bg = bg })
  cache.dim_id = vim.fn.matchadd("ZoomBlank", ".*", 0)
  cache.dim_opts = {
    number = vim.wo[cache.dim_win].number,
    relativenumber = vim.wo[cache.dim_win].relativenumber,
    cursorline = vim.wo[cache.dim_win].cursorline,
    cursorcolumn = vim.wo[cache.dim_win].cursorcolumn,
    foldcolumn = vim.wo[cache.dim_win].foldcolumn,
    signcolumn = vim.wo[cache.dim_win].signcolumn,
    colorcolumn = vim.wo[cache.dim_win].colorcolumn,
    statuscolumn = vim.wo[cache.dim_win].statuscolumn,
    winbar = vim.wo[cache.dim_win].winbar,
  }

  local row = 1
  local width = math.ceil(vim.o.columns / 2)
  local height = vim.o.lines - vim.o.cmdheight - row - 3

  cache.zoom_win = vim.api.nvim_open_win(0, true, {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = row,
    title = " Zoom (centered) ",
  })

  vim.wo.winhighlight = "NormalFloat:Normal,FloatBorder:Normal,FloatTitle:Normal"

  vim.api.nvim_set_hl(0, "None", { fg = bg, bg = bg, blend = 100 })

  -- Minimalize the source window after zoom opens the float
  local w = cache.dim_win
  vim.wo[w].number = false
  vim.wo[w].relativenumber = false
  vim.wo[w].cursorline = false
  vim.wo[w].cursorcolumn = false
  vim.wo[w].foldcolumn = "0"
  vim.wo[w].signcolumn = "no"
  vim.wo[w].colorcolumn = ""
  vim.wo[w].statuscolumn = ""
  vim.wo[w].winbar = ""
  -- stylua: ignore
  local mask = {
    "MiniAnimateCursor",
    "MiniIndentscopeSymbol",
    "MiniIndentscopeSymbolOff",
    "MiniJump2dSpot",
    "MiniJump2dSpotAhead",
    "MiniJump2dSpotUnique",
    "NonText",
  }
  vim.wo[w].winhighlight = table.concat(vim.tbl_map(function(hl) return hl .. ":None" end, mask), ",")
  vim.wo[cache.zoom_win].winbar = cache.dim_opts.winbar
  cache.laststatus = vim.opt.laststatus
  vim.opt.laststatus = 3
end

local function put_messages() put_text(vim.split(vim.api.nvim_exec2("messages", { output = true }).output, "\n")) end

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

-- stylua: ignore start
vim.keymap.set("n", "<C-z>",      zoom,          { desc = "Zoom" })
vim.keymap.set("n", "<leader>ep", put_messages,  { desc = "Put messages" })
vim.keymap.set("n", "<leader>ez", zoom,          { desc = "Zoom (full)" })
vim.keymap.set("n", "<leader>eZ", centered_zoom, { desc = "Zoom (centered)" })
-- stylua: ignore end

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_misc", { clear = true })

vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
  group = group,
  desc = "Re-center zoom window on resize",
  callback = function()
    vim.defer_fn(function()
      if not cache.zoom_win or not vim.api.nvim_win_is_valid(cache.zoom_win) then return end
      local row = 1
      local w = math.ceil(vim.o.columns / 2)
      local h = vim.o.lines - vim.o.cmdheight - row - 3
      vim.api.nvim_win_set_config(
        cache.zoom_win,
        { relative = "editor", width = w, height = h, col = math.floor((vim.o.columns - w) / 2), row = row }
      )
    end, 50)
  end,
})
