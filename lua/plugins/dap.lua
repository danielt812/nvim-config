local dap = require("dap")
local utils = require("utils")
local dap_utils = require("dap.utils")

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

utils.map("n", "<leader>db", require("dap").toggle_breakpoint, { desc = "Breakpoint" })
utils.map("n", "<leader>dc", require("dap").continue, { desc = "Continue" })
utils.map("n", "<leader>do", require("dap").step_over, { desc = "Step over" })
utils.map("n", "<leader>di", require("dap").step_into, { desc = "Step into" })
utils.map("n", "<leader>dl", function()
  require("osv").launch({ port = 8086 })
end, { desc = "Launch", noremap = true })
utils.map("n", "<leader>dv", require("dap-view").toggle, { desc = "View" })

dap.adapters.node2 = {
  type = "executable",
  command = "node",
  args = {
    vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js",
  },
}

dap.configurations.lua = {
  {
    type = "nlua",
    request = "attach",
    name = "Attach to running Neovim instance",
  },
}

dap.adapters.nlua = function(callback, config)
  callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
end

dap.configurations.javascript = {
  {
    name = "Launch",
    type = "node2",
    request = "launch",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    console = "integratedTerminal",
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = "Attach to process",
    type = "node2",
    request = "attach",
    processId = dap_utils.pick_process,
  },
}
