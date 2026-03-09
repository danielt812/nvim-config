local pick = require("mini.pick")
local extra = require("mini.extra")

-- Side preview
local preview_state = { win = nil, buf = nil, last_item = nil, hidden = false }
local preview_cache = {}

local function preview_create(win_opts)
  preview_state.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(preview_state.buf, "minipick://" .. preview_state.buf .. "/preview")
  vim.bo[preview_state.buf].bufhidden = "wipe"
  vim.bo[preview_state.buf].matchpairs = ""

  win_opts = vim.tbl_extend("force", win_opts, { style = "minimal", footer = " Preview ", footer_pos = "left" })
  preview_state.win = vim.api.nvim_open_win(preview_state.buf, false, win_opts)
  vim.wo[preview_state.win].linebreak = true
  vim.wo[preview_state.win].scrolloff = 0
  vim.wo[preview_state.win].winhighlight = "NormalFloat:MiniPickNormal,FloatBorder:MiniPickBorder"
end

local function preview_close()
  pcall(vim.api.nvim_win_close, preview_state.win, true)
  pcall(vim.api.nvim_buf_delete, preview_state.buf, { force = true })
  preview_state.win, preview_state.buf, preview_state.last_item = nil, nil, nil
  preview_cache = {}
end

local function preview_layout(win_config, preview_config)
  local preview_ratio = 0.618
  local padding = 2
  if win_config.width > 75 then
    local preview_width = math.floor(preview_ratio * win_config.width)
    local picker_width = win_config.width - preview_width - padding
    win_config.width = picker_width
    preview_config.width = preview_width
    preview_config.col = win_config.col + picker_width + padding
  else
    local preview_height = math.floor(preview_ratio * win_config.height)
    local picker_height = win_config.height - preview_height
    preview_config.height = preview_height
    win_config.height = picker_height
    preview_config.row = win_config.row - picker_height - padding
  end
end

local function preview_scroll(direction)
  if not preview_state.win then return end
  local map = { up = "<C-b>", down = "<C-f>", left = "zH", right = "zL" }
  vim.api.nvim_set_current_win(preview_state.win)
  vim.api.nvim_input(map[direction])
end

local function preview_cache_config()
  local picker_state = pick.get_picker_state()
  if not (picker_state.windows and picker_state.windows.main) then return end
  local config = vim.api.nvim_win_get_config(picker_state.windows.main)
  for _, key in ipairs({ "anchor", "border", "col", "height", "relative", "row", "width", "zindex" }) do
    preview_cache[key] = config[key]
  end
end

local function preview_update()
  if preview_state.hidden then return preview_close() end

  local picker_state = pick.get_picker_state()
  if not (picker_state.windows and picker_state.windows.main) then return end

  local win_config = vim.deepcopy(preview_cache)
  local preview_config = vim.deepcopy(preview_cache)
  preview_layout(win_config, preview_config)
  vim.api.nvim_win_set_config(picker_state.windows.main, win_config)

  if not preview_state.win then
    preview_create(preview_config)
  else
    vim.api.nvim_win_set_config(preview_state.win, preview_config)
  end

  local item = pick.get_picker_matches().current
  if item ~= preview_state.last_item then
    preview_state.last_item = item
    if item then
      pcall(pick.get_picker_opts().source.preview, preview_state.buf, item)
    else
      vim.api.nvim_buf_set_lines(preview_state.buf, 0, -1, false, {})
    end
  end
end

-- Wrap pick.refresh to update preview
local refresh = pick.refresh
pick.refresh = function()
  refresh()
  if pick.is_picker_active() then
    preview_cache_config()
    vim.schedule(preview_update)
  end
end

pick.setup({
  mappings = {
    caret_left = "<C-h>",
    caret_right = "<C-l>",
    move_down_picker = {
      char = "<C-j>",
      func = function()
        vim.api.nvim_input("<C-n>")
        vim.schedule(preview_update)
      end,
    },
    move_up_picker = {
      char = "<C-k>",
      func = function()
        vim.api.nvim_input("<C-p>")
        vim.schedule(preview_update)
      end,
    },
    scroll_side_preview_left = {
      char = "<Left>",
      func = function() preview_scroll("left") end,
    },
    scroll_side_preview_right = {
      char = "<Right>",
      func = function() preview_scroll("right") end,
    },
    scroll_side_preview_up = {
      char = "<Up>",
      func = function() preview_scroll("up") end,
    },
    scroll_side_preview_down = {
      char = "<Down>",
      func = function() preview_scroll("down") end,
    },
    sys_paste = {
      char = "<C-v>",
      func = function() pick.set_picker_query({ vim.fn.getreg("+") }) end,
    },
    toggle_preview = "",
    toggle_side_preview = {
      char = "<Tab>",
      func = function()
        pick.refresh()
        preview_state.hidden = not preview_state.hidden
        preview_update()
      end,
    },
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

-- NOTE: Only filter colorschemes in my runtime
local function pick_colorschemes()
  local config = vim.fn.stdpath("config")
  local names = vim.tbl_filter(function(name)
    local files = vim.list_extend(
      vim.api.nvim_get_runtime_file("colors/" .. name .. ".vim", false),
      vim.api.nvim_get_runtime_file("colors/" .. name .. ".lua", false)
    )
    for _, path in ipairs(files) do
      if vim.startswith(path, config) then return true end
    end
    return false
  end, vim.fn.getcompletion("", "color"))
  extra.pickers.colorschemes({ names = names })
end

-- stylua: ignore start
vim.keymap.set("n", "<leader>fc", pick_colorschemes,         { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>fe", "<cmd>Pick explorer<cr>",  { desc = "Explorer" })
vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>",     { desc = "Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Pick grep_live<cr>", { desc = "Livegrep" })
vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>",      { desc = "Help" })
vim.keymap.set("n", "<leader>fi", "<cmd>Pick hl_groups<cr>", { desc = "Highlights" })
vim.keymap.set("n", "<leader>fk", "<cmd>Pick keymaps<cr>",   { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fl", "<cmd>Pick buf_lines<cr>", { desc = "Lines" })
vim.keymap.set("n", "<leader>fm", "<cmd>Pick marks<cr>",     { desc = "Marks" })
-- stylua: ignore end

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_pick", { clear = true })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniPickStart",
  group = group,
  callback = function()
    preview_cache_config()
    vim.schedule(preview_update)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniPickMatch",
  group = group,
  callback = function()
    -- stylua: ignore
    vim.schedule(preview_update)
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniPickStop",
  group = group,
  callback = function()
    preview_close()
    preview_state.hidden = false
  end,
})
