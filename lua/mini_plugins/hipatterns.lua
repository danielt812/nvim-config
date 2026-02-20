local hipatterns = require("mini.hipatterns")
local ts_utils = require("utils.ts")

local apply_hipattern_groups = function()
  -- stylua: ignore
  local colors = {
    { "Info",  "#98c379" }, -- INFO:
    { "Note",  "#3498db" }, -- NOTE:
    { "Todo",  "#ff8c00" }, -- TODO:
    { "Warn",  "#ff2d00" }, -- WARN:
  }
  local prefix = "MiniHipatterns"
  for _, pair in ipairs(colors) do
    local word, hex = pair[1], pair[2]
    vim.api.nvim_set_hl(0, prefix .. word, { fg = "#000000", bg = hex })
    vim.api.nvim_set_hl(0, prefix .. word .. "Mask", { fg = hex, bg = hex })
  end
  vim.api.nvim_set_hl(0, prefix .. "Link", { fg = "#8be9fd", underline = true })
end

local function in_comment(base, suffix)
  suffix = suffix or ""
  local name = "MiniHipatterns" .. base:sub(1, 1):upper() .. base:sub(2) .. suffix
  return ts_utils.if_capture("comment", name)
end

local comments = {
  info = {
    pattern = "() ?INFO ?()",
    group = in_comment("info"),
  },
  info_colon = {
    pattern = "INFO()[:-]",
    group = in_comment("info", "Mask"),
  },
  note = {
    pattern = "() ?NOTE ?()",
    group = in_comment("note"),
  },
  note_colon = {
    pattern = "NOTE()[:-]",
    group = in_comment("note", "Mask"),
  },
  todo = {
    pattern = "() ?TODO ?()",
    group = in_comment("todo"),
  },
  todo_colon = {
    pattern = "TODO()[:-]",
    group = in_comment("todo", "Mask"),
  },
  warn = {
    pattern = "() ?WARN ?()",
    group = in_comment("warn"),
  },
  warn_colon = {
    pattern = "WARN()[:-]",
    group = in_comment("warn", "Mask"),
  },
}

--- Return long hex color (#rrggbb)
local get_hex_long = function(pattern) return pattern end

--- Expand a short hex color (#rgb) -> (#rrggbb)
local get_hex_short = function(pattern)
  local r, g, b = pattern:sub(2, 2), pattern:sub(3, 3), pattern:sub(4, 4)
  return string.format("#%s%s%s%s%s%s", r, r, g, g, b, b):lower()
end

--- Convert rgb(r, g, b) to hex (#rrggbb)
local rgb_color = function(pattern)
  local r, g, b = pattern:match("rgb%((%d+), ?(%d+), ?(%d+)%)")
  return string.format("#%02x%02x%02x", tonumber(r), tonumber(g), tonumber(b))
end

--- Convert rgba(r, g, b, a) to hex (#rrggbb), applying alpha
local rgba_color = function(pattern)
  local r, g, b, a = pattern:match("rgba?%((%d+), ?(%d+), ?(%d+), ?(%d*%.?%d*)%)")
  a = tonumber(a)
  if not a or a < 0 or a > 1 then return false end
  return string.format("#%02x%02x%02x", tonumber(r) * a, tonumber(g) * a, tonumber(b) * a)
end

local get_highlight = function(cb)
  return function(_, match) return hipatterns.compute_hex_color_group(cb(match), "fg") end
end

local color_extmark_opts = function(_, _, data)
  return {
    virt_text = { { "■ ", data.hl_group } },
    virt_text_pos = "inline", -- eol, eol_right_align, overlay, right_align, inline
    right_gravity = false, -- ensures it stays after the match if text is inserted
  }
end

local colors = {
  hex_long = {
    pattern = "#%x%x%x%x%x%x%f[%W]", -- #ffffff
    group = get_highlight(get_hex_long),
    extmark_opts = color_extmark_opts,
  },
  hex_short = {
    pattern = "#%x%x%x%f[%W]", -- #fff
    group = get_highlight(get_hex_short),
    extmark_opts = color_extmark_opts,
  },
  rgb = {
    pattern = "rgb%(%d+, ?%d+, ?%d+%)", -- rgb(225, 225, 225)
    group = get_highlight(rgb_color),
    extmark_opts = color_extmark_opts,
  },
  rgba = {
    pattern = "rgba?%(%d+, ?%d+, ?%d+, ?%d*%.?%d*%)", -- rgb(225, 225, 225, 1)
    group = get_highlight(rgba_color),
    extmark_opts = color_extmark_opts,
  },
}

local http = {
  get = {
    pattern = "%f[%a]GET%f[%A]",
    group = "GreenItalic",
  },
  post = {
    pattern = "%f[%a]POST%f[%A]",
    group = "BlueItalic",
  },
  put = {
    pattern = "%f[%a]PUT%f[%A]",
    group = "OrangeItalic",
  },
  patch = {
    pattern = "%f[%a]PATCH%f[%A]",
    group = "PurpleItalic",
  },
  delete = {
    pattern = "%f[%a]DELETE%f[%A]",
    group = "RedItalic",
  },
}

local function in_string(name) return ts_utils.if_capture("string", name) end

local extras = {
  url = {
    pattern = "https?://[%w-_%.%?%.:/%+=&]+",
    group = in_comment("Link"),
  },
  quote = {
    pattern = '"',
    group = in_string("Grey"),
  },
  email = {
    pattern = "[%w%.%-_]+@[%w%.%-_]+%.[%a]+",
    group = in_comment("Underline"),
  },
}

local highlighters = {}
local highlight_tables = { comments, colors, http, extras }
for _, tbl in ipairs(highlight_tables) do
  highlighters = vim.tbl_extend("force", tbl, highlighters)
end

hipatterns.setup({
  highlighters = highlighters,
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

local toggle_hipatterns = function() vim.b.minihipatterns_disable = not vim.b.minihipatterns_disable end

vim.keymap.set("n", "<leader>eh", toggle_hipatterns, { desc = "Hipatterns" })

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local au_group = vim.api.nvim_create_augroup("mini_hipatterns", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = au_group,
  desc = "Create custom highlight groups",
  callback = apply_hipattern_groups,
})
