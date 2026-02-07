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
    use_as_default_explorer = true,
  },
})

local show_dotfiles = true

local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles

  local filter = function(fs_entry)
    if show_dotfiles then
      return true
    end
    return not vim.startswith(fs_entry.name, ".")
  end

  files.refresh({ content = { filter = filter } })
end

local open_current = function()
  files.open(vim.api.nvim_buf_get_name(0))
end

vim.api.nvim_create_autocmd("User", {
  group = vim.api.nvim_create_augroup("mini_files", { clear = true }),
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
  end,
})

vim.keymap.set("n", "<leader>ef", open_current, { desc = "Files" })
