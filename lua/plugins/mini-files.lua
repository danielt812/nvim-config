local M = { "echasnovski/mini.files" }

M.enabled = true

M.keys = {
  { "<leader>ef", "<cmd>lua MiniFiles.open(vim.fn.expand('%:p:h'))<cr>", desc = "Files" },
}

M.event = { "VeryLazy" }

M.opts = function()
  local files = require("mini.files")

  return {
    -- Customization of shown content
    content = {
      -- Predicate for which file system entries to show
      filter = nil,
      -- What prefix to show to the left of file system entry
      prefix = nil,
      -- In which order to show file system entries
      sort = nil,
    },

    -- Module mappings created only inside explorer.
    -- Use `''` (empty string) to not create one.
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

    -- General options
    options = {
      -- Whether to delete permanently or move into module-specific trash
      permanent_delete = true,
      -- Whether to use for editing directories
      use_as_default_explorer = false,
    },

    -- Customization of explorer windows
    windows = {
      -- Maximum number of windows to show side by side
      max_number = math.huge,
      -- Whether to show preview of file/directory under cursor
      preview = false,
      -- Width of focused window
      width_focus = 50,
      -- Width of non-focused window
      width_nofocus = 15,
      -- Width of preview window
      width_preview = 25,
    },
  }
end

M.config = function(_, opts)
  require("mini.files").setup(opts)
  local minifiles_settings_group = vim.api.nvim_create_augroup("minifiles_settings_group", { clear = true })
  vim.api.nvim_create_autocmd("User", {
    group = minifiles_settings_group,
    pattern = "MiniFilesWindowOpen",
    callback = function(args)
      local win_id = args.data.win_id

      -- Customize window-local settings
      vim.wo[win_id].winblend = 10
    end,
  })

  local show_dotfiles = true

  local filter_show = function(fs_entry)
    return true
  end

  local filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, ".")
  end

  local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    MiniFiles.refresh({ content = { filter = new_filter } })
  end

  vim.api.nvim_create_autocmd("User", {
    pattern = "MiniFilesBufferCreate",
    callback = function(args)
      local buf_id = args.data.buf_id
      -- Tweak left-hand side of mapping to your liking
      vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
    end,
  })
end
return M
