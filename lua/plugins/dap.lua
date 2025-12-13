-- https://github.com/mfussenegger/nvim-dap
local dap = require("dap")
-- https://github.com/igorlfs/nvim-dap-view
local dap_view = require("dap-view")
-- https://github.com/theHamsta/nvim-dap-virtual-text
local dap_virtual_text = require("nvim-dap-virtual-text")

vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "DiagnosticSignError",
  priority = 11,
})
vim.fn.sign_define("DapBreakpointRejected", {
  text = "",
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "DiagnosticSignError",
  priority = 11,
})
vim.fn.sign_define("DapStopped", {
  text = "",
  texthl = "DiagnosticSignOk",
  linehl = "Visual",
  numhl = "DiagnosticSignOk",
  priority = 11,
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue,          { desc = "Continue"   })
vim.keymap.set("n", "<leader>do", dap.step_over,         { desc = "Step over"  })
vim.keymap.set("n", "<leader>dO", dap.step_out,          { desc = "Step out"   })
vim.keymap.set("n", "<leader>di", dap.step_into,         { desc = "Step into"  })
vim.keymap.set("n", "<leader>dv", dap_view.toggle,       { desc = "View"       })
-- stylua: ignore end

-- stylua: ignore start
dap.listeners.after.event_initialized["dapview"] = function() dap_view.open()  end
dap.listeners.before.event_terminated["dapview"] = function() dap_view.close() end
dap.listeners.before.event_exited["dapview"]     = function() dap_view.close() end
-- stylua: ignore end

dap_view.setup({
  winbar = {
    sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl" },
    default_section = "watches",
    controls = {
      enabled = true,
      -- position = "right",
      -- buttons = {
      --   "play",
      --   "step_into",
      --   "step_over",
      --   "step_out",
      --   "step_back",
      --   "run_last",
      --   "terminate",
      --   "disconnect",
      -- },
      -- custom_buttons = {},
    },
  },
  windows = {
    terminal = {
      hide = { "pwa-node", "local-lua" },
      start_hidden = true,
    },
  },
})

dap_virtual_text.setup({
  virt_text_pos = "eol",
})

local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
local js_debug = mason_packages .. "/js-debug-adapter/js-debug/src/dapDebugServer.js"

-- Javascript
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { js_debug, "${port}" },
  },
}

dap.configurations.javascript = {
  {
    name = "Launch file",
    type = "pwa-node",
    request = "launch",
    cwd = "${workspaceFolder}",
    program = "${file}",
  },
}
