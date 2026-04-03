local overseer = require("overseer")

overseer.setup({
  -- Patch nvim-dap to support preLaunchTask and postDebugTask
  dap = true,
  -- Configure the task output buffer and window
  output = {
    -- Use a terminal buffer to display output. If false, a normal buffer is used
    use_terminal = true,
    -- If true, don't clear the buffer when a task restarts
    preserve_output = false,
  },
  -- Configure the task list
  task_list = {
    -- Default direction. Can be "left", "right", or "bottom"
    direction = "bottom",
    -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_width and max_width can be a single value or a list of mixed integer/float types.
    -- max_width = {100, 0.2} means "the lesser of 100 columns or 20% of total"
    max_width = { 100, 0.2 },
    -- min_width = {40, 0.1} means "the greater of 40 columns or 10% of total"
    min_width = { 40, 0.1 },
    max_height = { 20, 0.3 },
    min_height = { 10, 0.2 },
    -- You can add custom keymaps here as well (anything vim.keymap.set accepts)
    keymaps = {
      ["?"] = "keymap.show_help",
      ["g?"] = "keymap.show_help",
      ["<CR>"] = "keymap.run_action",
      ["dd"] = { "keymap.run_action", opts = { action = "dispose" }, desc = "Dispose task" },
      ["<C-e>"] = { "keymap.run_action", opts = { action = "edit" }, desc = "Edit task" },
      ["o"] = "keymap.open",
      ["<C-v>"] = { "keymap.open", opts = { dir = "vsplit" }, desc = "Open task output in vsplit" },
      ["<C-s>"] = { "keymap.open", opts = { dir = "split" }, desc = "Open task output in split" },
      ["<C-t>"] = { "keymap.open", opts = { dir = "tab" }, desc = "Open task output in tab" },
      ["<C-f>"] = { "keymap.open", opts = { dir = "float" }, desc = "Open task output in float" },
      ["<C-q>"] = {
        "keymap.run_action",
        opts = { action = "open output in quickfix" },
        desc = "Open task output in the quickfix",
      },
      ["p"] = "keymap.toggle_preview",
      ["{"] = "keymap.prev_task",
      ["}"] = "keymap.next_task",
      ["<C-k>"] = "keymap.scroll_output_up",
      ["<C-j>"] = "keymap.scroll_output_down",
      ["g."] = "keymap.toggle_show_wrapped",
      ["q"] = { "<cmd>close<cr>", desc = "Close task list" },
      ["<esc>"] = { "<cmd>close<cr>", desc = "Close task list" },
    },
  },
  -- Custom actions for tasks. See :help overseer-actions
  actions = {},
  -- Configure the floating window used for task templates that require input
  -- and the floating window used for editing tasks
  form = {
    zindex = 40,
    -- Dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
    -- min_X and max_X can be a single value or a list of mixed integer/float types.
    min_width = 80,
    max_width = 0.9,
    min_height = 10,
    max_height = 0.9,
    border = nil,
    -- Set any window options here (e.g. winhighlight)
    win_opts = {},
  },
  -- Configuration for task floating output windows
  task_win = {
    -- How much space to leave around the floating window
    padding = 2,
    border = nil,
    -- Set any window options here (e.g. winhighlight)
    win_opts = {},
  },
  -- Aliases for bundles of components. Redefine the builtins, or create your own.
  component_aliases = {
    -- Most tasks are initialized with the default components
    default = {
      "on_exit_set_status",
      "on_complete_notify",
      { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
    },
    -- Tasks from tasks.json use these components
    default_vscode = {
      "default",
      "on_result_diagnostics",
    },
    -- Tasks created from experimental_wrap_builtins
    default_builtin = {
      "on_exit_set_status",
      "on_complete_dispose",
      { "unique", soft = true },
    },
  },
  -- List of other directories to search for task templates.
  -- This will search under the runtimepath, so for example
  -- "foo/bar" will search "<runtimepath>/lua/foo/bar/*"
  template_dirs = {},
  -- List of module names or lua patterns that match modules (must start with '^')
  -- to disable. This can be used to disable built in task providers.
  disable_template_modules = {
    -- "overseer.template.make",
    -- "^.*cargo",
  },
})

overseer.register_template({
  name = "live-server",
  builder = function()
    local root = vim.fn.expand("%:p:h")

    -- Print it for debugging
    print("Live Server root:", root)

    return {
      cmd = { "live-server", root, "--port=5555" },
      cwd = root,
      components = { "default", "on_complete_notify" },
    }
  end,
  condition = {
    filetype = { "html", "css", "javascript", "typescript" },
  },
})

overseer.register_template({
  name = "run script",
  builder = function()
    local file = vim.fn.expand("%:p")
    local cmd = { file }
    if vim.bo.filetype == "go" then
      cmd = { "go", "run", file }
    elseif vim.bo.filetype == "python" then
      cmd = { "python", file }
    end
    return {
      cmd = cmd,
      -- add some components that will pipe the output to quickfix,
      -- parse it using errorformat, and display any matching lines as diagnostics.
      components = {
        { "on_output_quickfix", set_diagnostics = true },
        "on_result_diagnostics",
        "default",
      },
    }
  end,
  condition = {
    filetype = { "sh", "python", "go" },
  },
})

-- stylua: ignore start
local open        = function() overseer.open() end
-- local close       = function() overseer.close() end
-- local toggle      = function() overseer.toggle() end
local run         = function() overseer.run_task() end
local task_action = function() overseer.run_action() end
-- stylua: ignore end

-- stylua: ignore start
vim.keymap.set("n", "<leader>oo", open,        { desc = "Open" })
-- vim.keymap.set("n", "<leader>oc", close,       { desc = "Close" })
-- vim.keymap.set("n", "<leader>ot", toggle,      { desc = "Toggle" })
vim.keymap.set("n", "<leader>or", run,         { desc = "Run" })
vim.keymap.set("n", "<leader>oa", task_action, { desc = "Action" })
-- stylua: ignore end

vim.api.nvim_create_user_command("OverseerWatch", function()
  overseer.run_task({ name = "run script", autostart = false }, function(task)
    if task then
      task:add_component({ "restart_on_save", paths = { vim.fn.expand("%:p") } })
      task:start()
      task:open_output("vertical")
    else
      vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
    end
  end)
end, {})
