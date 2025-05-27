local oil = require("oil")

oil.setup({
  default_file_explorer = true,
  columns = {
    "icon",
    -- "permissions",
    -- "size",
    -- "mtime"
  },
  delete_to_trash = true,
  skip_confirm_for_simple_edits = false,
  prompt_save_on_select_new_entry = true,
  lsp_file_methods = {
    autosave_changes = false,
  },
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<cr>"] = "actions.select",
    ["<C-s>"] = "actions.select_vsplit",
    ["<C-h>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["<C-l>"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
  },
  use_default_keymaps = false,
  view_options = {
    show_hidden = false, -- Show hidden files by default
  },
})
