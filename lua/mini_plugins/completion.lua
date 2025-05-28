local completion = require("mini.completion")

local kind_priority = { Text = -1, Snippet = 99 }
local opts = { filtersort = "fuzzy", kind_priority = kind_priority }
local process_items = function(items, base)
  local processed = completion.default_process_items(items, base, opts)

  for _, item in ipairs(processed) do
    print(item.menu)
    if item.menu and item.menu:sub(-2) == " S" then
      item.menu = item.menu:sub(1, -3) -- strip trailing " S"
    end
  end

  return processed
end

completion.setup({
  lsp_completion = {
    source_func = "completefunc",
    auto_setup = true,
    process_items = process_items,
    snippet_insert = nil,
  },
  fallback_action = "<C-n>",
  mappings = {
    force_twostep = "<C-Space>",
    force_fallback = "<A-Space>",
    scroll_up = "<PageUp>", -- <C-f> default
    scroll_down = "<PageDown>", -- <C-b> default
  },
  window = {
    info = { border = "rounded" },
    signature = { border = "rounded" },
  },
})

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

-- LINK - https://github.com/echasnovski/mini.nvim/issues/690
local term = vim.api.nvim_replace_termcodes("<C-z>", true, true, true)
vim.opt.wildmenu = true
vim.opt.wildoptions = "pum,fuzzy"
vim.opt.wildmode = "noselect:lastused,full"
vim.opt.wildcharm = vim.fn.char2nr(term)

-- vim.keymap.set("c", "<Up>", "<End><C-U><Up>", { silent = true })
-- vim.keymap.set("c", "<Down>", "<End><C-U><Down>", { silent = true })

au("CmdlineChanged", {
  group = augroup("wildmenu_group", { clear = true }),
  pattern = ":",
  callback = function()
    local cmdline = vim.fn.getcmdline()
    local curpos = vim.fn.getcmdpos()
    local last_char = cmdline:sub(-1)

    if
      curpos == #cmdline + 1
      and vim.fn.pumvisible() == 0
      and last_char:match("[%w%/%: ]")
      and not cmdline:match("^%d+$")
    then
      vim.opt.eventignore:append("CmdlineChanged")
      vim.api.nvim_feedkeys(term, "ti", false)
      vim.schedule(function()
        vim.opt.eventignore:remove("CmdlineChanged")
      end)
    end
  end,
})
