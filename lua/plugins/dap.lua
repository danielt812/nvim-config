-- https://github.com/mfussenegger/nvim-dap
local dap = require("dap")
-- https://github.com/igorlfs/nvim-dap-view
local dap_view = require("dap-view")

local cache = {}

vim.fn.sign_define("DapBreakpoint", {
  text = "",
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "DiagnosticSignError",
  priority = 3,
})
vim.fn.sign_define("DapBreakpointRejected", {
  text = "",
  texthl = "DiagnosticSignError",
  linehl = "",
  numhl = "DiagnosticSignError",
  priority = 3,
})
vim.fn.sign_define("DapStopped", {
  text = "",
  texthl = "DiagnosticSignOk",
  linehl = "Visual",
  numhl = "DiagnosticSignOk",
  priority = 3,
})

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
    },
  },
})

local pkg = vim.fn.stdpath("data") .. "/mason/packages"

-- Bash ------------------------------------------------------------------------
dap.adapters.bashdb = {
  type = "executable",
  command = pkg .. "/bash-debug-adapter/bash-debug-adapter",
  name = "bashdb",
}

dap.configurations.sh = {
  {
    type = "bashdb",
    request = "launch",
    name = "Launch file",
    showDebugOutput = true,
    pathBashdb = pkg .. "/bash-debug-adapter/extension/bashdb_dir/bashdb",
    pathBashdbLib = pkg .. "/bash-debug-adapter/extension/bashdb_dir",
    trace = true,
    file = "${file}",
    program = "${file}",
    cwd = "${workspaceFolder}",
    pathCat = "cat",
    pathBash = "/bin/bash",
    pathMkfifo = "mkfifo",
    pathPkill = "pkill",
    args = {},
    argsString = "",
    env = {},
    terminalKind = "integrated",
  },
}

-- Javascript ------------------------------------------------------------------
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = { pkg .. "/js-debug-adapter/js-debug/src/dapDebugServer.js", "${port}" },
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

-- Virtual Text ----------------------------------------------------------------
cache.vt_ns = cache.vt_ns or vim.api.nvim_create_namespace("dap_virtual_text")
cache.last_frames = cache.last_frames or {}
cache.stopped_frame = cache.stopped_frame or nil

local function variables_from_scopes(scopes)
  local variables = {}
  for _, s in ipairs(scopes or {}) do
    for _, v in pairs(s.variables or {}) do
      if not variables[v.name] or s.presentationHint == "locals" then variables[v.name] = v end
    end
  end
  return variables
end

local function set_virtual_text(frame)
  if not frame or not frame.scopes or not frame.source or not frame.source.path then return end

  local buf = vim.fn.bufnr(frame.source.path, false)
  if buf == -1 then buf = vim.uri_to_bufnr(vim.uri_from_fname(frame.source.path)) end

  local ft = vim.bo[buf].ft
  if ft == "" then ft = vim.filetype.match({ buf = buf }) or "" end
  if ft == "" then return end

  local lang = vim.treesitter.language.get_lang(ft)
  if not lang then return end

  local ok, parser = pcall(vim.treesitter.get_parser, buf, lang)
  if not ok or not parser then return end

  local scope_nodes = {}
  local definition_nodes = {}

  parser:parse()
  parser:for_each_tree(function(tree, ltree)
    local query = vim.treesitter.query.get(ltree:lang(), "locals")
    if not query then return end
    for _, match in query:iter_matches(tree:root(), buf, 0, -1) do
      for id, nodes in pairs(match) do
        if type(nodes) ~= "table" then nodes = { nodes } end
        for _, node in ipairs(nodes) do
          local cap = query.captures[id]
          if cap:find("scope", 1, true) then
            table.insert(scope_nodes, node)
          elseif cap:find("definition", 1, true) then
            table.insert(definition_nodes, node)
          end
        end
      end
    end
  end)

  local variables = variables_from_scopes(frame.scopes)
  local last_scopes = cache.last_frames[frame.id] and cache.last_frames[frame.id].scopes or {}
  local last_variables = variables_from_scopes(last_scopes)

  local seen_names = {}
  local seen_nodes = {}

  for _, node in ipairs(definition_nodes) do
    local name = vim.treesitter.get_node_text(node, buf)
    local var = variables[name]
    if var and not seen_names[name] and not seen_nodes[node:id()] then
      local var_line, var_col = node:start()

      local in_scope = true
      for _, scope in ipairs(scope_nodes) do
        if
          vim.treesitter.is_in_node_range(scope, var_line, var_col)
          and not vim.treesitter.is_in_node_range(scope, frame.line - 1, 0)
        then
          in_scope = false
          break
        end
      end

      if in_scope then
        seen_names[name] = true
        seen_nodes[node:id()] = true

        local last = last_variables[name]
        local changed = last and var.value ~= last.value
        local text = name .. " = " .. var.value:gsub("%s+", " ")

        vim.api.nvim_buf_set_extmark(buf, cache.vt_ns, var_line, 0, {
          hl_mode = "combine",
          virt_text = { { text, changed and "NvimDapVirtualTextChanged" or "NvimDapVirtualText" } },
          virt_text_pos = "eol",
        })
      end
    end
  end

  if
    cache.stopped_frame
    and cache.stopped_frame.line
    and cache.stopped_frame.source
    and cache.stopped_frame.source.path
  then
    local sbuf = vim.uri_to_bufnr(vim.uri_from_fname(cache.stopped_frame.source.path))
    pcall(vim.api.nvim_buf_set_extmark, sbuf, cache.vt_ns, cache.stopped_frame.line - 1, 0, {
      hl_mode = "combine",
      virt_text = { { cache.stopped_frame.error_msg or "", "NvimDapVirtualTextError" } },
      virt_text_pos = "eol",
    })
  end
end

local function clear_virtual_text()
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    vim.api.nvim_buf_clear_namespace(buf, cache.vt_ns, 0, -1)
  end
end

local function refresh(session)
  session = session or dap.session()
  clear_virtual_text()
  if session and session.current_frame then set_virtual_text(session.current_frame) end
end

-- stylua: ignore start
dap.listeners.before.event_stopped["virtual_text"]   = function(session) cache.last_frames = {}; for _, t in pairs(session.threads or {}) do for _, f in pairs(t.frames or {}) do if f and f.id then cache.last_frames[f.id] = f end end end end
dap.listeners.after.event_stopped["virtual_text"]    = function(_, event) if event and event.reason == "exception" then cache.stopped_frame = cache.stopped_frame or {}; cache.stopped_frame.error_msg = "  " .. (event.description or "Exception") end end
dap.listeners.after.variables["virtual_text"]        = refresh
dap.listeners.after.stackTrace["virtual_text"]       = function(session) if session.stopped_thread_id and session.threads[session.stopped_thread_id] then local frames = vim.tbl_filter(function(f) return f.source and f.source.path end, session.threads[session.stopped_thread_id].frames or {}); cache.stopped_frame = frames[1] end end
dap.listeners.before.event_continued["virtual_text"] = function() cache.stopped_frame = nil; clear_virtual_text() end
dap.listeners.before.continue["virtual_text"]        = function() cache.stopped_frame = nil; clear_virtual_text() end
dap.listeners.after.event_terminated["virtual_text"] = function() cache.stopped_frame = nil; cache.last_frames = {}; clear_virtual_text() end
dap.listeners.after.event_exited["virtual_text"]     = function() cache.stopped_frame = nil; cache.last_frames = {}; clear_virtual_text() end
dap.listeners.after.exceptionInfo["virtual_text"]    = function(_, _, response) if response then cache.stopped_frame = cache.stopped_frame or {}; local t = response.details and response.details.typeName; cache.stopped_frame.error_msg = "  " .. (t or "") .. (response.description and ((t and ": " or "") .. response.description) or "") end end
-- stylua: ignore end

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

-- stylua: ignore start
vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue,          { desc = "Continue"   })
vim.keymap.set("n", "<leader>dh", dap.step_out,          { desc = "Step out"   })
vim.keymap.set("n", "<leader>di", dap.step_into,         { desc = "Step into"  })
vim.keymap.set("n", "<leader>dl", dap.step_over,         { desc = "Step over"  })
vim.keymap.set("n", "<leader>dv", dap_view.toggle,       { desc = "View"       })
-- stylua: ignore end

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

local function gen_hl_groups()
  -- stylua: ignore start
  vim.api.nvim_set_hl(0, "NvimDapVirtualText",        { link = "Comment" })
  vim.api.nvim_set_hl(0, "NvimDapVirtualTextChanged", { link = "DiagnosticVirtualTextWarn" })
  vim.api.nvim_set_hl(0, "NvimDapVirtualTextError",   { link = "DiagnosticVirtualTextError" })
  -- stylua: ignore end
end

gen_hl_groups() -- Call this now if colorscheme was already set

local function filetype_cb(args)
  -- stylua: ignore start
  local function next_section() dap_view.navigate({ count = 1,  wrap = true }) end
  local function prev_section() dap_view.navigate({ count = -1, wrap = true }) end
  vim.keymap.set("n", "<S-l>", next_section, { buffer = args.buf, desc = "Next section" })
  vim.keymap.set("n", "<S-h>", prev_section, { buffer = args.buf, desc = "Previous section" })

  local function close() dap_view.close() end
  vim.keymap.set("n", "q", close, { buffer = args.buf, desc = "Close dap-view" })
  -- stylua: ignore end
end

local group = vim.api.nvim_create_augroup("dap", { clear = true })

vim.api.nvim_create_autocmd("ColorScheme", {
  group = group,
  desc = "Create highlight groups",
  callback = gen_hl_groups,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-view",
  group = group,
  desc = "Set dap-view buffer keymaps",
  callback = filetype_cb,
})
