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


-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

-- stylua: ignore start
local function open_current() files.open(vim.api.nvim_buf_get_name(0)) end
local open_cwd = function() files.open() end

vim.keymap.set("n", "<leader>ef", open_current, { desc = "Files (current)" })
vim.keymap.set("n", "<leader>eF", open_cwd,     { desc = "Files (cwd)" })
-- stylua: ignore end

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local group = vim.api.nvim_create_augroup("mini_files", { clear = true })

local show_dotfiles = true

-- Toggle hidden files
local function toggle_dotfiles()
  show_dotfiles = not show_dotfiles
  local function filter(fs_entry)
    if show_dotfiles then return true end
    return not vim.startswith(fs_entry.name, ".")
  end
  files.refresh({ content = { filter = filter } })
end

-- Open path with system default handler (useful for non-text files)
local function os_open() vim.ui.open(files.get_fs_entry().path) end

-- Set focused directory as current working directory
local function set_cwd()
  local path = (files.get_fs_entry() or {}).path
  if path == nil then return vim.notify("Cursor is not on valid entry") end
  local entry = files.get_fs_entry()
  if not entry then return end
  local dir = entry.fs_type == "directory" and path or vim.fs.dirname(path)
  vim.fn.chdir(dir)
  vim.notify("cwd: " .. dir)
end

-- Yank in register full path of entry under cursor
local function yank_path()
  local path = (files.get_fs_entry() or {}).path
  if path == nil then return vim.notify("Cursor is not on valid entry") end
  vim.fn.setreg(vim.v.register, path)
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  group = group,
  callback = function(args)
    local buf = args.data.buf_id
    local function map(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc }) end
    -- stylua: ignore start
    map("g.", toggle_dotfiles, "Toggle dotfiles")
    map("g~", set_cwd,         "Set cwd")
    map("gX", os_open,         "OS open")
    map("gy", yank_path,       "Yank path")
    -- stylua: ignore end
  end,
})
