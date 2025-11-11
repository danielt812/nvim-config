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
local lua_debug = mason_packages .. "/local-lua-debugger-vscode/extension/extension/debugAdapter.js"

local osv = require("osv")

vim.keymap.set("n", "<leader>dl", function()
  osv.launch({ port = 8086 })
end, { desc = "Launch Nvim debugger" })
-- Lua
dap.configurations.lua = {
  { type = "nlua", request = "attach", name = "Attach to running Neovim instance" },
}

dap.adapters.nlua = function(callback)
  callback({
    type = "server",
    host = "127.0.0.1",
    port = 8086,
  })
end

-- dap.adapters["local-lua"] = {
--   type = "executable",
--   command = "node",
--   args = {
--     lua_debug,
--   },
--   enrich_config = function(config, on_config)
--     if not config["extensionPath"] then
--       local c = vim.deepcopy(config)
--       c.extensionPath = mason_packages .. "/local-lua-debugger-vscode/extension"
--       on_config(c)
--     else
--       on_config(config)
--     end
--   end,
-- }

-- dap.configurations.lua = {
--   {
--     name = "Current file (local-lua-dbg, lua)",
--     type = "local-lua",
--     request = "launch",
--     cwd = "${workspaceFolder}",
--     repl_lang = "lua",
--     program = {
--       lua = "luajit",
--       file = "${file}",
--     },
--   },
-- }

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
