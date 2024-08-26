local M = { "aserowy/tmux.nvim" }

M.enabled = true

M.event = { "VeryLazy" }

M.opts = function()
  return {
    copy_sync = {
      -- enables copy sync. by default, all registers are synchronized.
      -- to control which registers are synced, see the `sync_*` options.
      enable = true,

      -- ignore specific tmux buffers e.g. buffer0 = true to ignore the
      -- first buffer or named_buffer_name = true to ignore a named tmux
      -- buffer with name named_buffer_name :)
      ignore_buffers = { empty = false },

      -- TMUX >= 3.2: all yanks (and deletes) will get redirected to system
      -- clipboard by tmux
      redirect_to_clipboard = true,

      -- offset controls where register sync starts
      -- e.g. offset 2 lets registers 0 and 1 untouched
      register_offset = 0,

      -- overwrites vim.g.clipboard to redirect * and + to the system
      -- clipboard using tmux. If you sync your system clipboard without tmux,
      -- disable this option!
      sync_clipboard = false,
      sync_registers = true, -- synchronizes registers *, +, unnamed, and 0 till 9 with tmux buffers.
      -- syncs deletes with tmux clipboard as well, it is adviced to
      -- do so. Nvim does not allow syncing registers 0 and 1 without
      -- overwriting the unnamed register. Thus, ddp would not be possible.
      sync_deletes = true,
      sync_unnamed = true, -- syncs the unnamed register with the first buffer entry from tmux.
    },
    navigation = {
      cycle_navigation = true, -- cycles to opposite pane while navigating into the border
      enable_default_keybindings = true, -- enables default keybindings (C-hjkl) for normal mode
      persist_zoom = false, -- prevents unzoom tmux when navigating beyond vim border
    },
    resize = {
      enable_default_keybindings = false, -- enables default keybindings (A-hjkl) for normal mode
      resize_step_x = 1, -- sets resize steps for x axis
      resize_step_y = 1, -- sets resize steps for y axis
    },
  }
end

M.config = function(_, opts)
  require("tmux").setup(opts)
end

return M
