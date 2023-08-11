return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "rcarriga/nvim-dap-ui",
      opts = function()
        return {
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
                { id = "repl", size = 0.55 },
                { id = "console", size = 0.45 },
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
        }
      end,
      config = function(_, opts)
        local dap = require("dap")
        local dapui = require("dapui")

        dapui.setup(opts)

        dap.listeners.after.event_initialized["dapui_config"] = function()
          dapui.open({})
        end
        dap.listeners.before.event_terminated["dapui_config"] = function()
          dapui.close({})
        end
        dap.listeners.before.event_exited["dapui_config"] = function()
          dapui.close({})
        end
      end,
    },
    {
      "mfussenegger/nvim-dap-python",
      config = function()
        -- require("dap-python").setup(vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python")
        require("dap-python").setup("/usr/local/bin/python3.11") -- use global pip
        -- require("dap-python").setup("~/.virtualenvs/debugpy/bin/python")
      end,
    },
    {
      "jbyuki/one-small-step-for-vimkind",
      -- stylua: ignore
      keys = {
        { "<leader>daL", function() require("osv").launch({ port = 8086 }) end, desc = "Lua Server 󰢱 " },
        { "<leader>dal", function() require("osv").run_this() end, desc = "Lua 󰢱 " },
      },
      config = function()
        local dap = require("dap")

        dap.adapters.nlua = function(callback)
          callback({ type = "server", host = "127.0.0.1", port = 8086 })
        end

        dap.configurations.lua = {
          {
            type = "nlua",
            request = "attach",
            name = "Attach to running Neovim instance",
          },
        }
      end,
    },
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
    }
  end,
  config = function(_, opts)
    local dap = require("dap")

    vim.fn.sign_define("DapBreakpoint", opts.breakpoint)
    vim.fn.sign_define("DapBreakpointRejected", opts.breakpoint_rejected)
    vim.fn.sign_define("DapStopped", opts.stopped)

    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          require("mason-registry").get_package("js-debug-adapter"):get_install_path()
            .. "/js-debug/src/dapDebugServer.js",
          "${port}",
        },
      },
    }

    for _, language in ipairs({ "javascript", "typescript" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
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
  end,
}
