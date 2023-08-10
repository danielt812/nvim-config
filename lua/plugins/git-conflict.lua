return {
  "akinsho/git-conflict.nvim",
  event = { "VeryLazy" },
  opts = function()
    return {
      default_mappings = false, -- disable buffer local mapping created by this plugin
      default_commands = true, -- disable commands created by this plugin
      disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
      highlights = { -- They must have background color, otherwise the default color will be used
        incoming = "DiffAdd",
        current = "DiffText",
      },
    }
  end,
  config = function(_, opts)
    require("git-conflict").setup(opts)
    local function map(mode, lhs, rhs, key_opts)
      key_opts = key_opts or {}
      key_opts.silent = key_opts.silent ~= false
      vim.api.nvim_set_keymap.set(mode, lhs, rhs, key_opts)
    end

    local function unmap(mode, lhs)
      vim.api.nvim_del_keymap(mode, lhs)
    end

    local git_conflict_group = vim.api.nvim_create_augroup("git_conflict_keybinds", { clear = true })

    vim.api.nvim_create_autocmd("User", {
      group = git_conflict_group,
      desc = "Bind Git Conflict Keymaps",
      pattern = { "GitConflictDetected" },
      callback = function()
        map("n", "<leader>gca", "<Plug>(git-conflict-ours)", { desc = "Accept Changes 󰯭 " })
        map("n", "<leader>gci", "<Plug>(git-conflict-theirs)", { desc = "Incoming Changes 󰰅 " })
        map("n", "<leader>gcb", "<Plug>(git-conflict-both)", { desc = "Both Changes 󰯰 " })
        map("n", "<leader>gcn", "<Plug>(git-conflict-none)", { desc = "No Changes 󰰔 " })
        map("n", "]x", "<Plug>(git-conflict-prev-conflict)", { desc = "Previous conflict" })
        map("n", "[x", "<Plug>(git-conflict-next-conflict)", { desc = "Next conflict" })
      end,
    })

    vim.api.nvim_create_autocmd("User", {
      group = git_conflict_group,
      desc = "Unbind Git Conflict Keymaps",
      pattern = { "GitConflictResolved" },
      callback = function()
        unmap("n", "<leader>gca")
        unmap("n", "<leader>gci")
        unmap("n", "<leader>gcb")
        unmap("n", "<leader>gcn")
        unmap("n", "<leader>]x")
        unmap("n", "<leader>[x")
      end,
    })
  end,
}
