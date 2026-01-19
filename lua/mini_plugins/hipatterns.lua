local hipatterns = require("mini.hipatterns")
local patterns = require("utils.string-patterns")

-- stylua: ignore start
local function apply_custom_highlights()
  vim.api.nvim_set_hl(0, "MiniHipatternsWarn",  { fg = "#000000", bg = "#ff2d00" }) -- WARN  example
  vim.api.nvim_set_hl(0, "MiniHipatternsFixme", { fg = "#000000", bg = "#fce94f" }) -- FIX  example
  vim.api.nvim_set_hl(0, "MiniHipatternsTodo",  { fg = "#000000", bg = "#ff8c00" }) -- TODO  example
  vim.api.nvim_set_hl(0, "MiniHipatternsHack",  { fg = "#000000", bg = "#d699b6" }) -- HACK  example
  vim.api.nvim_set_hl(0, "MiniHipatternsNote",  { fg = "#000000", bg = "#3498db" }) -- NOTE  example
  vim.api.nvim_set_hl(0, "MiniHipatternsInfo",  { fg = "#000000", bg = "#98c379" }) -- INFO  example
  vim.api.nvim_set_hl(0, "MiniHipatternsLink",  { fg = "#000000", bg = "#8be9fd" }) -- LINK  example
end
-- stylua: ignore end

-- Url examples...
-- https://www.google.com
-- www.google.com
-- http://localhost:3000

local function highlight_if_ts_capture(capture, hl_group)
  return function(buf_id, _, data)
    local captures = vim.treesitter.get_captures_at_pos(buf_id, data.line - 1, data.from_col - 1)

    local pred = function(t)
      return t.capture == capture
    end

    local not_in_capture = vim.tbl_isempty(vim.tbl_filter(pred, captures))

    if not_in_capture then
      return nil
    end

    return hl_group
  end
end

local function get_highlight(cb)
  return function(_, match)
    return hipatterns.compute_hex_color_group(cb(match), "fg")
  end
end

local function extmark_opts_color(_, _, data)
  return {
    virt_text = { { "■ ", data.hl_group } },
    virt_text_pos = "inline", -- eol, eol_right_align, overlay, right_align, inline
    right_gravity = false, -- ensures it stays after the match if text is inserted
  }
end

local comments = {}

for _, word in ipairs({
  "todo",
  "note",
  "hack",
  "fixme",
  "warn",
  "info",
  "link",
  { "bug", "warn" },
  { "fix", "fixme" },
}) do
  local w = type(word) == "table" and word[1] or word
  local hl = type(word) == "table" and word[2] or word

  comments[w] = {
    pattern = {
      " " .. w:upper() .. " ",
    },
    group = highlight_if_ts_capture("comment", string.format("MiniHipatterns%s", hl:sub(1, 1):upper() .. hl:sub(2))),
  }
end

apply_custom_highlights()

hipatterns.setup({
  highlighters = vim.tbl_extend("force", comments, {
    hex_color = {
      pattern = "#%x%x%x%x%x%x%f[%X]",
      group = get_highlight(patterns.get_hex_long),
      extmark_opts = extmark_opts_color,
    },
    hex_color_short = {
      pattern = "#%x%x%x%f[%X]",
      group = get_highlight(patterns.get_hex_short),
      extmark_opts = extmark_opts_color,
    },
    rgb_color = {
      pattern = "rgb%(%d+, ?%d+, ?%d+%)",
      group = get_highlight(patterns.rgb_color),
      extmark_opts = extmark_opts_color,
    },
    rgba_color = {
      pattern = "rgba%(%d+, ?%d+, ?%d+, ?%d*%.?%d*%)",
      group = get_highlight(patterns.rgba_color),
      extmark_opts = extmark_opts_color,
    },
    url = {
      pattern = {
        "%f[%S]()https?://[%w%-%._~:/%?#%[%]@!$&'()*+,;=%%]+",
        "%f[%S]()www%.[%w%-%._~:/%?#%[%]@!$&'()*+,;=%%]+",
      },
      group = "MiniHipatternsUrl",
    },
  }),
})
