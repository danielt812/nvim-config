-- The quick brown fox jumps over the lazy dog and door another door

local M = {}
local H = {}

M.config = {
  -- Module mappings. Use `''` (empty string) to disable one.
  mappings = {
    forward = "f",
    backward = "F",
    forward_till = "t",
    backward_till = "T",
    repeat_ft = ";",
    backward_repeat_ft = ",",
  },
}

M.setup = function(config)
  -- Setup config
  config = H.setup_config(config)

  -- Apply config
  H.apply_config(config)
end

-- Helper data ================================================================
-- Module default config
H.default_config = vim.deepcopy(M.config)

-- Cache for various operations
H.cache = {
  -- Counter of number of CursorMoved events
  n_cursor_moved = 0,

  -- Latest cursor position data
  latest_cursor = nil,

  -- Whether helper message was shown
  msg_shown = false,
}

-- Helper functionality =======================================================
-- Settings -------------------------------------------------------------------
H.setup_config = function(config)
  config = vim.tbl_deep_extend("force", vim.deepcopy(H.default_config), config or {})

  return config
end

H.apply_config = function(config)
  M.config = config

  local mappings = config.mappings

  -- Map each non-empty key to a placeholder function (you’ll implement these later)
  H.map("n", mappings.forward, function()
    H.handle_motion("forward")
  end, { desc = "Jump forward (eyeline)" })
  H.map("n", mappings.backward, function()
    H.handle_motion("backward")
  end, { desc = "Jump backward (eyeline)" })
  H.map("n", mappings.forward_till, function()
    H.handle_motion("forward_till")
  end, { desc = "Jump forward till (eyeline)" })
  H.map("n", mappings.backward_till, function()
    H.handle_motion("backward_till")
  end, { desc = "Jump backward till (eyeline)" })
  H.map("n", mappings.repeat_ft, function()
    H.repeat_last("forward")
  end, { desc = "Repeat last jump (eyeline)" })
  H.map("n", mappings.backward_repeat_ft, function()
    H.repeat_last("backward")
  end, { desc = "Repeat last jump backward (eyeline)" })

  H.setup_highlights()
end

H.map = function(mode, lhs, rhs, opts)
  if lhs == "" then
    return
  end
  opts = vim.tbl_deep_extend("force", { silent = true }, opts or {})
  vim.keymap.set(mode, lhs, rhs, opts)
end

H.check_type = function(name, val, ref, allow_nil)
  if type(val) == ref or (ref == "callable" and vim.is_callable(val)) or (allow_nil and val == nil) then
    return
  end
  H.error(string.format("`%s` should be %s, not %s", name, ref, type(val)))
end

H.handle_motion = function(direction)
  H.clear_highlights()
  H.dim_line_direction(direction)
  H.highlight_cword_heads(direction)

  vim.schedule(function()
    -- local char = vim.fn.nr2char(vim.fn.getchar())
    local char = vim.fn.getcharstr()
    print("Would jump " .. direction .. " to: " .. char)
    H.clear_highlights()
  end)
end

H.ns = vim.api.nvim_create_namespace("foretell")

H.dim_line_direction = function(direction)
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  -- local row = vim.fn.row(".")
  -- local col = vim.fn.col(".")
  row = row - 1

  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]

  if not line then
    return
  end

  local start_col, end_col
  if direction == "forward" or direction == "forward_till" then
    start_col = col + 1
    end_col = #line
  elseif direction == "backward" or direction == "backward_till" then
    start_col = 0
    end_col = col
  else
    return
  end

  for c = start_col, end_col - 1 do
    -- Ensure we're not highlighting past line length
    if c + 1 <= #line then
      vim.api.nvim_buf_set_extmark(bufnr, H.ns, row, c, {
        hl_group = "ForetellDim",
        end_col = c + 1,
        priority = 1000,
      })
    end
  end
end

H.setup_highlights = function()
  vim.api.nvim_set_hl(0, "ForetellDim", { link = "Comment" }) -- dimmed characters
  vim.api.nvim_set_hl(0, "ForetellTarget", { link = "MiniIconsGreen", italic = true }) -- jump target first
  vim.api.nvim_set_hl(0, "ForetellAltTarget", { link = "MiniIconsAzure", italic = true }) -- jump target subsequent
end

H.setup_autocmds = function()
  vim.api.nvim_create_autocmd("CursorMoved", {
    group = vim.api.nvim_create_augroup("ForeTell", { clear = true }),
    callback = function()
      H.clear_highlights()
    end,
  })
end

H.clear_highlights = function()
  vim.api.nvim_buf_clear_namespace(0, H.ns, 0, -1)
end

H.highlight_cword_heads = function(direction)
  local bufnr = vim.api.nvim_get_current_buf()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  row = row - 1

  local line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1]
  if not line then
    return
  end

  local start_col, end_col
  if direction == "forward" or direction == "forward_till" then
    start_col = col + 1
    end_col = #line
  elseif direction == "backward" or direction == "backward_till" then
    start_col = 0
    end_col = col
  else
    return
  end

  local seen = {}

  for c = start_col, end_col - 1 do
    local char = line:sub(c + 1, c + 1)
    local prev = c == 0 and " " or line:sub(c, c)
    local is_word_start = prev:match("%W") and char:match("%w")

    if is_word_start then
      local first_letter = char -- Case-sensitive tracking
      seen[first_letter] = (seen[first_letter] or 0) + 1

      local hl = seen[first_letter] == 1 and "ForetellTarget" or "ForetellAltTarget"

      vim.api.nvim_buf_set_extmark(bufnr, H.ns, row, c, {
        hl_group = hl,
        end_col = c + 1,
        priority = 1001,
      })
    end
  end
end

return M
