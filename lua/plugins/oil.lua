local M = { "stevearc/oil.nvim" }

M.enabled = true

M.cmd = { "Oil" }

M.keys = {
  { "<leader>eo", "<cmd>Oil<cr>", desc = "Oil" },
}

M.opts = function()
  return {
    default_file_explorer = true,
    columns = {
      "icon",
      -- "permissions",
      -- "size",
      -- "mtime"
    },
    delete_to_trash = true, -- Send deleted files to the trash instead of permanently deleting them
    skip_confirm_for_simple_edits = false, -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
    prompt_save_on_select_new_entry = true, -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
    lsp_file_methods = {
      -- Set to true to autosave buffers that are updated with LSP willRenameFiles
      -- Set to "unmodified" to only save unmodified buffers
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
  }
end

M.config = function(_, opts)
  require("oil").setup(opts)
end

return M
