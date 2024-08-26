local M = { "rcarriga/nvim-dap-ui" }

M.enabled = true

M.event = { "VeryLazy" }

M.dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }

M.opts = function()
  return {
    ui = {
      controls = {
        element = "repl",
        enabled = true,
        icons = {
          disconnect = "",
          pause = "",
          play = "",
          run_last = "",
          step_back = "",
          step_into = "",
          step_out = "",
          step_over = "",
          terminate = "",
        },
      },
      element_mappings = {},
      expand_lines = true,
      floating = {
        border = "single",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
      force_buffers = true,
      icons = {
        collapsed = "",
        current_frame = "",
        expanded = "",
      },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.25 },
            { id = "breakpoints", size = 0.25 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            { id = "repl", size = 0.5 },
            { id = "console", size = 0.5 },
          },
          position = "bottom",
          size = 10,
        },
      },
      mappings = {
        edit = "e",
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        repl = "r",
        toggle = "t",
      },
      render = {
        indent = 1,
        max_value_lines = 100,
      },
    },
    dap = {
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
        texthl = "DiagnosticSignOk",
        linehl = "Visual",
        numhl = "DiagnosticSignOk",
      },
      log = {
        level = "info",
      },
    },
  }
end

M.config = function(_, opts)
  local dap = require("dap")
  local dapui = require("dapui")

  vim.fn.sign_define("DapBreakpoint", opts.dap.breakpoint)
  vim.fn.sign_define("DapBreakpointRejected", opts.dap.breakpoint_rejected)
  vim.fn.sign_define("DapStopped", opts.dap.stopped)

  dapui.setup(opts.ui)

  dap.listeners.before.attach.dapui_config = function()
    dapui.open()
  end
  dap.listeners.before.launch.dapui_config = function()
    dapui.open()
  end
  -- dap.listeners.before.event_terminated.dapui_config = function()
  --   dapui.close()
  -- end
  -- dap.listeners.before.event_exited.dapui_config = function()
  --   dapui.close()
  -- end

  local js_debug_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path()

  dap.adapters["pwa-node"] = {
    type = "server",
    host = "localhost",
    port = "${port}",
    executable = {
      command = "node",
      args = {
        js_debug_path .. "/js-debug/src/dapDebugServer.js",
        "${port}",
      },
    },
  }

  dap.configurations.javascript = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch file",
      program = "${file}",
      cwd = "${workspaceFolder}",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Mocha Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/mocha/bin/mocha.js",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Debug Jest Tests",
      -- trace = true, -- include debugger info
      runtimeExecutable = "node",
      runtimeArgs = {
        "./node_modules/jest/bin/jest.js",
        "--runInBand",
      },
      rootPath = "${workspaceFolder}",
      cwd = "${workspaceFolder}",
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
    },
  }
end

return M

