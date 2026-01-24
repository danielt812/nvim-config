local hipatterns = require("mini.hipatterns")
local convert = require("utils.color-convert")
local ts = require("utils.tree-sitter")

local function apply_hipattern_groups()
  -- stylua: ignore
  local colors = {
    { "Fixme", "#fce94f" }, -- FIXME:
    { "Hack",  "#d699b6" }, -- HACK:
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
end

apply_hipattern_groups()

local function color_extmark_opts(_, _, data)
  return {
    virt_text = { { "■ ", data.hl_group } },
    virt_text_pos = "inline", -- eol, eol_right_align, overlay, right_align, inline
    right_gravity = false, -- ensures it stays after the match if text is inserted
  }
end

local comments = {}
local comment_words = {
  "todo",
  "note",
  "hack",
  "fixme",
  "warn",
  "info",
  "link",
}

local function in_comment(base, suffix)
  suffix = suffix or ""
  local name = "MiniHipatterns" .. base:sub(1, 1):upper() .. base:sub(2) .. suffix
  return ts.if_capture("comment", name)
end

for _, word in ipairs(comment_words) do
  local w = type(word) == "table" and word[1] or word
  local hl = type(word) == "table" and word[2] or word
  local colon = w .. "_colon"

  comments[w] = {
    pattern = "() ?" .. w:upper() .. " ?()",
    group = in_comment(hl),
  }
  comments[colon] = {
    pattern = w:upper() .. "()[:-]", -- Mask ":" or "-" after keyword
    group = in_comment(hl, "Mask"),
  }
end

local function get_highlight(cb)
  return function(_, match)
    return hipatterns.compute_hex_color_group(cb(match), "fg")
  end
end

hipatterns.setup({
  highlighters = vim.tbl_extend("force", comments, {
    hex_color = {
      pattern = "#%x%x%x%x%x%x%f[%W]",
      group = get_highlight(convert.get_hex_long),
      extmark_opts = color_extmark_opts,
    },
    hex_color_short = {
      pattern = "#%x%x%x%f[%W]",
      group = get_highlight(convert.get_hex_short),
      extmark_opts = color_extmark_opts,
    },
    rgb_color = {
      pattern = "rgb%(%d+, ?%d+, ?%d+%)",
      group = get_highlight(convert.rgb_color),
      extmark_opts = color_extmark_opts,
    },
    rgba_color = {
      pattern = "rgba%(%d+, ?%d+, ?%d+, ?%d*%.?%d*%)",
      group = get_highlight(convert.rgba_color),
      extmark_opts = color_extmark_opts,
    },
  }),
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = vim.api.nvim_create_augroup("mini_hipatterns", { clear = true }),
  desc = "Create custom highlight groups",
  callback = function()
    apply_hipattern_groups()
  end,
})

-- stylua: ignore
local function toggle_hipatterns() vim.b.minihipatterns_disable = not vim.b.minihipatterns_disable end

vim.keymap.set("n", "<leader>eh", toggle_hipatterns, { desc = "Hipatterns" })
