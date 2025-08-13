-- https://github.com/mfussenegger/nvim-dap
local dap = require("dap")
local dap_utils = require("dap.utils")
-- https://github.com/igorlfs/nvim-dap-view
local dap_view = require("dap-view")
-- https://github.com/theHamsta/nvim-dap-virtual-text
local dap_virtual_text = require("nvim-dap-virtual-text")

local utils = require("utils")

vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapBreakpointRejected", {
  text = "",
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "",
})
vim.fn.sign_define("DapStopped", {
  text = "",
  texthl = "DiagnosticSignOk",
  linehl = "Visual",
  numhl = "DiagnosticSignOk",
})

-- stylua: ignore start
utils.map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Breakpoint" })
utils.map("n", "<leader>dc", dap.continue,          { desc = "Continue"   })
utils.map("n", "<leader>do", dap.step_over,         { desc = "Step over"  })
utils.map("n", "<leader>di", dap.step_into,         { desc = "Step into"  })
utils.map("n", "<leader>dv", dap_view.toggle,       { desc = "View"       })
-- stylua: ignore end

dap.listeners.after.event_initialized["dapview"] = function()
  dap_view.open()
end
dap.listeners.before.event_terminated["dapview"] = function()
  dap_view.close()
end
dap.listeners.before.event_exited["dapview"] = function()
  dap_view.close()
end

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
      hide = { "pwa-node" },
      start_hidden = true,
    },
  },
  auto_toggle = false,
})

dap_virtual_text.setup({
  virt_text_pos = "eol",
})

local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
local js_debug = mason_packages .. "/js-debug-adapter/js-debug/src/dapDebugServer.js"

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
  { type = "pwa-node", request = "launch", name = "Launch file", program = "${file}", cwd = "${workspaceFolder}" },
}
