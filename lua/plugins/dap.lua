return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "mfussenegger/nvim-dap-python",
  },
  opts = function()
    return {
      active = true,
      on_config_done = nil,
      breakpoint = {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      },
      breakpoint_rejected = {
        text = "",
        texthl = "DiagnosticSignError",
        linehl = "",
        numhl = "",
      },
      stopped = {
        text = "",
        texthl = "DiagnosticSignWarn",
        linehl = "Visual",
        numhl = "DiagnosticSignWarn",
      },
      log = {
        level = "info",
      },
      ui = {
        icons = { expanded = "", collapsed = "", current_frame = "" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        element_mappings = {},
        expand_lines = true,
        force_buffers = true,
        layouts = {
          {
            -- You can change the order of elements in the sidebar
            elements = {
              -- Provide IDs as strings or tables with "id" and "size" keys
              {
                id = "scopes",
                size = 0.25, -- Can be float or integer > 1
              },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left", -- Can be "left" or "right"
          },
          {
            elements = {
              { id = "repl", size = 0.45 },
              { id = "console", size = 0.55 },
            },
            size = 9,
            position = "bottom", -- Can be "bottom" or "top"
          },
        },
        floating = {
          max_height = nil,
          max_width = nil,
          border = "single",
          mappings = {
            ["close"] = { "q", "<Esc>" },
          },
        },
        controls = {
          enabled = true,
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "",
            terminate = "",
            disconnect = "",
          },
        },
        -- windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
          indent = 1,
        },
      },
    }
  end,
  config = function(_, opts)
    local dap = require("dap")
    vim.fn.sign_define("DapBreakpoint", opts.breakpoint)
    vim.fn.sign_define("DapBreakpointRejected", opts.breakpoint_rejected)
    vim.fn.sign_define("DapStopped", opts.stopped)

    -- require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
    require("dap-python").setup("/usr/local/bin/python3.11") -- use global pip
    -- require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")

    local dapui = require("dapui")

    dap.adapters.node2 = {
      type = "executable",
      command = "node-debug2-adapter",
      args = {},
    }

    for _, language in ipairs({ "javascript", "typescript" }) do
      dap.configurations[language] = {
        {
          type = "node2",
          name = "Launch",
          request = "launch",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
        {
          type = "node2",
          name = "Attach",
          request = "attach",
          program = "${file}",
          cwd = vim.fn.getcwd(),
          sourceMaps = true,
          protocol = "inspector",
          console = "integratedTerminal",
        },
      }
    end

    dapui.setup(opts.ui)

    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({})
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close({})
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close({})
    end

    local function map(mode, lhs, rhs, key_opts)
      lhs = "<leader>d" .. lhs
      rhs = "<cmd>" .. rhs .. "<CR>"
      key_opts = key_opts or {}
      key_opts.silent = key_opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, key_opts)
    end

    map("n", "sb", "lua require('dap').step_back()", { desc = "Back  " })
    map("n", "si", "lua require('dap').step_into()", { desc = "Into  " })
    map("n", "sv", "lua require('dap').step_over()", { desc = "Over  " })
    map("n", "so", "lua require('dap').step_out()", { desc = "Out  " })

    map("n", "rt", "lua require('dap').repl.toggle()", { desc = "Toggle Repl  " })
    map("n", "rr", "lua require('dap').repl.toggle()", { desc = "Run Last  " })

    map("n", "b", "lua require('dap').toggle_breakpoint()", { desc = "Breakpoint  " })
    map("n", "c", "lua require('dap').continue()", { desc = "Continue  " })
    map("n", "p", "lua require('dap').pause()", { desc = "Pause  " })
    map("n", "q", "lua require('dap').close()", { desc = "Quit  " })
    map("n", "t", "lua require('dapui').toggle({reset = true})", { desc = "Toggle UI  " })
    -- map("n", "C", "lua require('dap').run_to_cursor()", { desc = "Run To Cursor 󰆿 " })
    -- map("n", "d", "lua require('dap').disconnect()", { desc = "Disconnect  " })
    -- map("n", "s", "lua require('dap').session()", { desc = "" })
  end,
}
