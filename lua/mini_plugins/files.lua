local files = require("mini.files")

files.setup({
  content = {
    filter = nil,
    prefix = nil,
    sort = nil,
  },
  mappings = {
    close = "q",
    go_in = "l",
    go_in_plus = "L",
    go_out = "h",
    go_out_plus = "H",
    mark_goto = "'",
    mark_set = "m",
    reset = "<BS>",
    reveal_cwd = "@",
    show_help = "g?",
    synchronize = "=",
    trim_left = "<",
    trim_right = ">",
  },
  options = {
    permanent_delete = true,
    use_as_default_explorer = false,
  },
})

local show_dotfiles = true

-- stylua: ignore start
local filter_show = function() return true end
local filter_hide = function(fs_entry) return not vim.startswith(fs_entry.name, ".") end
-- stylua: ignore end

local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  files.refresh({ content = { filter = new_filter } })
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("mini_files", { clear = true }),
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
  end,
})

local open = function()
  files.open(vim.api.nvim_buf_get_name(0))
end

vim.keymap.set("n", "<leader>ef", open, { desc = "Files" })
