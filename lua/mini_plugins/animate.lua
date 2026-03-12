local animate = require("mini.animate")

local duration = 100

animate.setup({
  cursor = {
    enable = true,
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),

    -- Animate with shortest line for any cursor move
    path = animate.gen_path.line({
      predicate = function(args)
        local delta_line = math.abs(args[1] or 0)
        local delta_col = math.abs(args[2] or 0)
        if delta_line == 1 and delta_col == 0 then return false end
        if delta_col == 1 and delta_line == 0 then return false end
        return true
      end,
    }),
  },
  scroll = {
    enable = true,
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),
    subscroll = animate.gen_subscroll.equal({
      predicate = function(total_scroll)
        -- Skip animation if only 1 line up/down
        return math.abs(total_scroll) > 1
      end,
    }),
  },
  resize = {
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),
  },
  open = {
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),
  },
  close = {
    timing = animate.gen_timing.linear({ duration = duration, unit = "total" }),
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local function toggle_animate()
  vim.b.minianimate_disable = not vim.b.minianimate_disable
  vim.cmd("redrawstatus")
end

vim.keymap.set("n", "\\1", toggle_animate, { desc = "Toggle 'mini.animate'" })

--- Move the cursor by a full page or half page of lines in the given direction.
--- Uses `j`/`k` motions so mini.animate can animate the cursor, then
--- opens any folds under the cursor and centers the screen (`zvzz`).
--- @param size "full"|"half" full page or half page
--- @param dir "up"|"down" scroll direction
local function move_lines(size, dir)
  local height = vim.api.nvim_win_get_height(0)
  local count = size == "half" and math.floor(height / 2) or height - 2
  if count > 0 then vim.cmd("normal! " .. count .. (dir == "down" and "j" or "k")) end
  vim.cmd("normal! zvzz")
end

-- stylua: ignore start
vim.keymap.set({ "n", "v" }, "<PageDown>", function() move_lines("full", "down") end, { desc = "Move page down" })
vim.keymap.set({ "n", "v" }, "<C-f>",      function() move_lines("full", "down") end, { desc = "Move page down" })
vim.keymap.set({ "n", "v" }, "<C-d>",      function() move_lines("half", "down") end, { desc = "Move half page down" })
vim.keymap.set({ "n", "v" }, "<PageUp>",   function() move_lines("full", "up") end,   { desc = "Move page up" })
vim.keymap.set({ "n", "v" }, "<C-b>",      function() move_lines("full", "up") end,   { desc = "Move page up" })
vim.keymap.set({ "n", "v" }, "<C-u>",      function() move_lines("half", "up") end,   { desc = "Move half page up" })
-- stylua: ignore end
