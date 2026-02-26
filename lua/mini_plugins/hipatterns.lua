local hipatterns = require("mini.hipatterns")
local ts_utils = require("utils.ts")

local function in_comment(base, suffix)
  suffix = suffix or ""
  local name = "MiniHipatterns" .. base:sub(1, 1) .. base:sub(2) .. suffix
  return ts_utils.if_capture("comment", name)
end

local function in_string(base)
  local name = base:sub(1, 1) .. base:sub(2)
  return ts_utils.if_capture("string", name)
end

-- stylua: ignore
local comments = {
  info       = { pattern = "() ?INFO ?()", group = in_comment("INFO") },
  info_colon = { pattern = "INFO()[:-]",   group = in_comment("INFO", "Mask") },
  note       = { pattern = "() ?NOTE ?()", group = in_comment("NOTE") },
  note_colon = { pattern = "NOTE()[:-]",   group = in_comment("NOTE", "Mask") },
  perf       = { pattern = "() ?PERF ?()", group = in_comment("PERF") },
  perf_colon = { pattern = "PERF()[:-]",   group = in_comment("PERF", "Mask") },
  todo       = { pattern = "() ?TODO ?()", group = in_comment("TODO") },
  todo_colon = { pattern = "TODO()[:-]",   group = in_comment("TODO", "Mask") },
  warn       = { pattern = "() ?WARN ?()", group = in_comment("WARN") },
  warn_colon = { pattern = "WARN()[:-]",   group = in_comment("WARN", "Mask") },
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

-- stylua: ignore
local http = {
  get    = { pattern = "%f[%a]GET%f[%A]",    group = "GreenItalic" },
  post   = { pattern = "%f[%a]POST%f[%A]",   group = "BlueItalic" },
  put    = { pattern = "%f[%a]PUT%f[%A]",    group = "OrangeItalic" },
  patch  = { pattern = "%f[%a]PATCH%f[%A]",  group = "PurpleItalic" },
  delete = { pattern = "%f[%a]DELETE%f[%A]", group = "RedItalic" },
}

local test_extmark = function(symbol)
  return function(_, _, data)
    return {
      hl_group = data.hl_group,
      hl_mode = "combine",
      end_col = data.to_col,
      virt_text = { { symbol .. " ", data.hl_group } },
      virt_text_pos = "inline",
      right_gravity = false,
    }
  end
end

local link_extmark = function(icon)
  return function(_, _, data)
    return {
      hl_group = data.hl_group,
      hl_mode = "combine",
      end_col = data.to_col,
      virt_text = { { icon .. " ", data.hl_group } },
      virt_text_pos = "inline",
      right_gravity = false,
    }
  end
end

-- stylua: ignore
local links = {
  url           = { pattern = "https?://[%w%-%._~:/%?#%[%]@!$&'()*+,;=]+",                            group = in_comment("Link") },
  arch          = { pattern = "https://[%w%-%._]*archlinux%.org[%w%-%._~:/%?#%[%]@!$&'()*+,;=]*",     group = in_comment("Arch"),      extmark_opts = link_extmark("󰣇") },
  atlassian     = { pattern = "https://[%w%-%._]*atlassian%.net[%w%-%._~:/%?#%[%]@!$&'()*+,;=]*",     group = in_comment("Atlassian"), extmark_opts = link_extmark("") },
  azure         = { pattern = "https://[%w%-%._]*azure[%w%-%._]*[%w%-%._~:/%?#%[%]@!$&'()*+,;=]*",    group = in_comment("Azure"),     extmark_opts = link_extmark("") },
  fedora        = { pattern = "https://[%w%-%._]*fedoraproject%.org[%w%-%._~:/%?#%[%]@!$&'()*+,;=]*", group = in_comment("Fedora"),    extmark_opts = link_extmark("") },
  github        = { pattern = "https://[%w%-%._]*github%.com[%w%-%._~:/%?#%[%]@!$&'()*+,;=]*",        group = in_comment("Github"),    extmark_opts = link_extmark("󰊤") },
  mdn           = { pattern = "https://[%w%-%._]*mozilla%.org[%w%-%._~:/%?#%[%]@!$&'()*+,;=]*",       group = in_comment("Mdn"),       extmark_opts = link_extmark("󰖟") },
  reddit        = { pattern = "https://[%w%-%._]*reddit%.com[%w%-%._~:/%?#%[%]@!$&'()*+,;=]*",        group = in_comment("Reddit"),    extmark_opts = link_extmark("󰑍") },
  redhat        = { pattern = "https://[%w%-%._]*redhat%.com[%w%-%._~:/%?#%[%]@!$&'()*+,;=]*",        group = in_comment("Redhat"),    extmark_opts = link_extmark("") },
  stackoverflow = { pattern = "https://[%w%-%._]*stackoverflow%.com[%w%-%._~:/%?#%[%]@!$&'()*+,;=]*", group = in_comment("SO"),        extmark_opts = link_extmark("󰓌") },
}

local tests = {
  pass = { pattern = "%f[%a]PASS%f[%A]", group = in_comment("Pass"), extmark_opts = test_extmark("✓") },
  fail = { pattern = "%f[%a]FAIL%f[%A]", group = in_comment("Fail"), extmark_opts = test_extmark("✗") },
}

local strings = {
  double_quote_open  = { pattern = '()"()[^"]*"',   group = in_string("Grey") },
  double_quote_close = { pattern = '"[^"]*()"()',   group = in_string("Grey") },
  single_quote_open  = { pattern = "()'()[^']*'",   group = in_string("Grey") },
  single_quote_close = { pattern = "'[^']*()'()",   group = in_string("Grey") },
  backtick_open      = { pattern = "()`()[^`]*`",   group = in_string("Grey") },
  backtick_close     = { pattern = "`[^`]*()`()",   group = in_string("Grey") },
}

local highlighters = {}
local highlight_tables = { colors, comments, http, links, strings, tests }

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

local apply_hl = function()
  local prefix = "MiniHipatterns"

  -- Comment keywords
  local comment_colors = {
    Info = "#98c379", -- INFO:
    Note = "#3498db", -- NOTE:
    Perf = "#d699b6", -- PERF:
    Todo = "#ff8c00", -- TODO:
    Warn = "#ff2d00", -- WARN:
  }

  for name, hex in pairs(comment_colors) do
    vim.api.nvim_set_hl(0, prefix .. name, { fg = "#000000", bg = hex, italic = true })
    vim.api.nvim_set_hl(0, prefix .. name .. "Mask", { fg = hex, bg = hex, italic = true })
  end

  -- General links https://www.google.com
  vim.api.nvim_set_hl(0, prefix .. "Link", { fg = "#8be9fd", underline = true })

  -- Vendor links
  -- stylua: ignore
  local link_colors = {
    Arch          = "#4591cb", -- https://archlinux.org/foo/bar
    Atlassian     = "#356bd6", -- https://atlassian.net/foo/bar
    Azure         = "#0078d4", -- https://azure.com/foo/bar
    Fedora        = "#65a0d6", -- https://fedoraproject.org/foo/bar
    Github        = "#f2f5f3", -- https://github.com/foo/bar
    Mdn           = "#54ffbd", -- https://developer.mozilla.org/foo/bar
    Reddit        = "#ff4500", -- https://reddit.com/foo/bar
    Redhat        = "#da2f21", -- https://redhat.com/foo/bar
    SO            = "#f48024", -- https://stackoverflow.com/foo/bar
  }

  for name, hex in pairs(link_colors) do
    vim.api.nvim_set_hl(0, prefix .. name, { fg = hex, underline = true })
  end

  -- Test markers
  local test_colors = {
    Pass = "#00ff00", -- PASS
    Fail = "#ff0000", -- FAIL
  }

  for name, hex in pairs(test_colors) do
    vim.api.nvim_set_hl(0, prefix .. name, { fg = hex, italic = true })
  end
end

-- Call once when this module is loaded
apply_hl()

local group = vim.api.nvim_create_augroup("mini_hipatterns", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  desc = "Create custom highlight groups",
  callback = apply_hl,
})
