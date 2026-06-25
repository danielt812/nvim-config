local input = require("mini.input")

-- #############################################################################
-- #                                  Handlers                                 #
-- #############################################################################

-- -- View -- --
-- Show the input in a floating window, positioned by scope: small-scope inputs
-- (rename, "at cursor" prompts) appear next to the cursor, larger-scope inputs
-- are anchored to the top-middle of the editor.

-- Force a rounded border to match `win_borders` set in `mini.basics`.
local adjust_config = function(_, config)
  config.border = "rounded"
  return config
end

local floatwin = input.gen_view.floatwin
local view_cursor = floatwin({ style = "BL", adjust_config = adjust_config })
local view_editor = floatwin({ style = "TM", adjust_config = adjust_config })

local view_handler = function(state)
  local scope = state.opts.scope
  if scope == "cursor" or scope == "line" then return view_cursor(state) end
  return view_editor(state)
end

-- -- Key -- --
-- Use the default Command-line-style editing, with autopair enabled to mirror
-- `mini.pairs`. Honour the same `vim.g.minipairs_disable` toggle so disabling
-- pairs in buffers also disables them in the input prompt.
local key_handler = function(state, key)
  -- Paste the system clipboard at the caret, mirroring `sys_paste` in mini.pick.
  if key == vim.keycode("<C-v>") then
    local paste = vim.fn.getreg("+"):gsub("[\r\n]+", " ")
    local caret, value = state.caret, state.input
    local before = vim.fn.strcharpart(value, 0, caret - 1)
    local after = vim.fn.strcharpart(value, caret - 1)
    state.input = before .. paste .. after
    state.caret = caret + vim.fn.strchars(paste)
    return state
  end

  local autopair = not vim.g.minipairs_disable
  return input.default_key(state, key, { autopair = autopair })
end

-- #############################################################################
-- #                                   Setup                                   #
-- #############################################################################

input.setup({
  handlers = {
    complete = nil,
    -- `nil` highlight uses `default_highlight`, which colours
    -- completion-added characters. None of the prompts here are Vim code,
    -- so no tree-sitter highlighting is applied.
    highlight = nil,
    key = key_handler,
    view = view_handler,
  },

  -- Default input scope: cursor/line/buffer/window/tabpage/editor/project
  scope = "editor",
})
