local hipatterns = require("mini.hipatterns")

-- stylua: ignore start
local apply_custom_highlights = function()
  vim.api.nvim_set_hl(0, "MiniHipatternsWarn",  { fg = "#ff2d00" }) -- WARN example
  vim.api.nvim_set_hl(0, "MiniHipatternsFixme", { fg = "#fce94f" }) -- FIX  example
  vim.api.nvim_set_hl(0, "MiniHipatternsTodo",  { fg = "#ff8c00" }) -- TODO example
  vim.api.nvim_set_hl(0, "MiniHipatternsHack",  { fg = "#d699b6" }) -- HACK example
  vim.api.nvim_set_hl(0, "MiniHipatternsNote",  { fg = "#3498db" }) -- NOTE example
  vim.api.nvim_set_hl(0, "MiniHipatternsInfo",  { fg = "#98c379" }) -- INFO example
  vim.api.nvim_set_hl(0, "MiniHipatternsLink",  { fg = "#8be9fd" }) -- INFO example
end
-- stylua: ignore end

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

local function get_hex_long(match)
  return match
end

local function get_hex_short(match)
  local r, g, b = match:sub(2, 2), match:sub(3, 3), match:sub(4, 4)
  return string.format("#%s%s%s%s%s%s", r, r, g, g, b, b)
end

local function rgb_color(match)
  local red, green, blue = match:match("rgb%((%d+), ?(%d+), ?(%d+)%)")
  return string.format("#%02x%02x%02x", red, green, blue)
end

local function rgba_color(match)
  local red, green, blue, alpha = match:match("rgba%((%d+), ?(%d+), ?(%d+), ?(%d*%.?%d*)%)")
  alpha = tonumber(alpha)
  if alpha == nil or alpha < 0 or alpha > 1 then
    return false
  end
  return string.format("#%02x%02x%02x", red * alpha, green * alpha, blue * alpha)
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
  { "link", "hack" },
}) do
  local w = type(word) == "table" and word[1] or word
  local hl = type(word) == "table" and word[2] or word

  comments[w] = {
    -- Highlights patterns like FOO, @FOO, @FOO: FOO: both upper and lowercase
    pattern = {
      -- "%f[%w]()" .. w .. "%f[%W].*",
      "%f[%w]()"
        .. w:upper()
        .. "%f[%W].*",
    },
    group = highlight_if_ts_capture("comment", string.format("MiniHipatterns%s", hl:sub(1, 1):upper() .. hl:sub(2))),
  }
end

apply_custom_highlights()

hipatterns.setup({
  highlighters = vim.tbl_extend("force", comments, {
    hex_color = {
      pattern = "#%x%x%x%x%x%x%f[%X]",
      group = get_highlight(get_hex_long),
      extmark_opts = extmark_opts_color,
    },
    hex_color_short = {
      pattern = "#%x%x%x%f[%X]",
      group = get_highlight(get_hex_short),
      extmark_opts = extmark_opts_color,
    },
    rgb_color = {
      pattern = "rgb%(%d+, ?%d+, ?%d+%)",
      group = get_highlight(rgb_color),
      extmark_opts = extmark_opts_color,
    },
    rgba_color = {
      pattern = "rgba%(%d+, ?%d+, ?%d+, ?%d*%.?%d*%)",
      group = get_highlight(rgba_color),
      extmark_opts = extmark_opts_color,
    },
  }),
})
