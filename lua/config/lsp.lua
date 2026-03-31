local completion = require("mini.completion")

-- Shared capabilities
local capabilities =
  vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), completion.get_lsp_capabilities(), {
    textDocument = {
      foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      },
    },
  })

-- Shared on_attach
local function on_attach(client, buf)
  local function map(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    opts.buffer = buf
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- stylua: ignore start
  map("n", "K", vim.lsp.buf.hover, { desc = "Hover" })

  -- g mappings
  map("n", "gd",  vim.lsp.buf.definition,      { desc = "Go to Definition" })
  map("n", "gla", vim.lsp.buf.code_action,     { desc = "Code Action" })
  map("n", "glc", vim.lsp.buf.declaration,     { desc = "Declaration" })
  map("n", "gld", vim.lsp.buf.definition,      { desc = "Definition" })
  map("n", "glh", vim.lsp.buf.hover,           { desc = "Hover" })
  map("n", "gli", vim.lsp.buf.implementation,  { desc = "Implementation" })
  map("n", "gln", vim.lsp.buf.rename,          { desc = "Rename" })
  map("n", "glr", vim.lsp.buf.references,      { desc = "References" })
  map("n", "gls", vim.lsp.buf.signature_help,  { desc = "Signature Help" })
  map("n", "glt", vim.lsp.buf.type_definition, { desc = "Type Definition" })

  -- leader mappings
  map("n", "<leader>la", vim.lsp.buf.code_action,     { desc = "Code Action" })
  map("n", "<leader>lc", vim.lsp.buf.declaration,     { desc = "Declaration" })
  map("n", "<leader>ld", vim.lsp.buf.definition,      { desc = "Definition" })
  map("n", "<leader>lh", vim.lsp.buf.hover,           { desc = "Hover" })
  map("n", "<leader>li", vim.lsp.buf.implementation,  { desc = "Implementation" })
  map("n", "<leader>ln", vim.lsp.buf.rename,          { desc = "Rename" })
  map("n", "<leader>lr", vim.lsp.buf.references,      { desc = "References" })
  map("n", "<leader>ls", vim.lsp.buf.signature_help,  { desc = "Signature Help" })
  map("n", "<leader>lt", vim.lsp.buf.type_definition, { desc = "Type Definition" })
  -- stylua: ignore end

  -- if client:supports_method("textDocument/semanticTokensProvider") then
  --   client.server_capabilities.semanticTokensProvider = nil
  -- end

  if client:supports_method("textDocument/inlayHint") then
    -- stylua: ignore
    vim.lsp.inlay_hint.enable(false)
  end

  if client:supports_method("textDocument/linkedEditingRange") then
    vim.lsp.linked_editing_range.enable(true, { client_id = client.id })
  end
end

-- List of servers to enable
local servers = {
  "angularls",
  "autotools_ls",
  "basedpyright",
  "bashls",
  "css_variables",
  "cssls",
  "cssmodules_ls",
  "docker_language_server",
  "emmet_language_server",
  "eslint",
  "gopls",
  "html",
  "jsonls",
  "lua_ls",
  "marksman",
  "taplo",
  "tailwindcss",
  "ts_ls",
  -- "tsgo",
  "yamlls",
}

vim.hl.priorities.semantic_tokens = 100

-- Register each server configuration under vim.lsp.configs
for _, server in ipairs(servers) do
  local ok, conf = pcall(require, "lsp." .. server)
  if not ok then
    vim.notify("Failed to load LSP config: lsp." .. server, vim.log.levels.WARN)
    conf = {}
  end

  if server == "emmet_language_server" then
    local kinds = vim.lsp.protocol.CompletionItemKind
    kinds.Emmet = "󰅴 Emmet Abbreviation"
  end

  vim.lsp.config[server] = vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
  }, conf)
end

-- Enable them all
vim.lsp.enable(servers)

-- #############################################################################
-- #                               User Commands                               #
-- #############################################################################
do
  local group = vim.api.nvim_create_augroup("lsp", { clear = true })

  local function lsp_restart(opts)
    local filter = { bufnr = 0 }
    if opts.args ~= "" then filter = { name = opts.args } end
    for _, client in ipairs(vim.lsp.get_clients(filter)) do
      local name = client.name
      client:stop()
      vim.defer_fn(function() vim.lsp.enable(name) end, 500)
      vim.notify("Restarting " .. name)
    end
  end

  local function lsp_restart_cmp()
    return vim.tbl_map(function(c) return c.name end, vim.lsp.get_clients({ bufnr = 0 }))
  end

  local function lsp_info() vim.cmd("checkhealth lsp") end

  local function lsp_log() vim.cmd("edit " .. vim.lsp.get_log_path()) end

  local function lsp_semantic_hl() vim.api.nvim_set_hl(0, "@lsp.type.variable", {}) end

  vim.api.nvim_create_user_command(
    "LspRestart",
    lsp_restart,
    { desc = "Lsp restart", nargs = "?", complete = lsp_restart_cmp }
  )
  vim.api.nvim_create_user_command("LspInfo", lsp_info, { desc = "Lsp checkhealth" })
  vim.api.nvim_create_user_command("LspLog", lsp_log, { desc = "Lsp log" })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    desc = "Semantic highlighting",
    callback = lsp_semantic_hl,
  })
end

-- #############################################################################
-- #                                Breadcrumbs                                #
-- #############################################################################

do
  local state = {}

  local function pos_in_range(range, row, col)
    if not range or not range.start or not range["end"] then return false end
    if row < range.start.line or row > range["end"].line then return false end
    if row == range.start.line and col < range.start.character then return false end
    if row == range["end"].line and col > range["end"].character then return false end
    return true
  end

  local function find_flat_symbols_at_pos(symbols, row, col)
    local path = {}
    for _, symbol in ipairs(symbols) do
      local range = symbol.location and symbol.location.range
      if pos_in_range(range, row, col) then table.insert(path, symbol) end
    end
    table.sort(path, function(a, b)
      local ra, rb = a.location.range, b.location.range
      if ra.start.line ~= rb.start.line then return ra.start.line < rb.start.line end
      if ra.start.character ~= rb.start.character then return ra.start.character < rb.start.character end
      if ra["end"].line ~= rb["end"].line then return ra["end"].line > rb["end"].line end
      return ra["end"].character > rb["end"].character
    end)
    return path
  end

  local function find_symbols_at_pos(symbols, row, col)
    if #symbols > 0 and not symbols[1].range then return find_flat_symbols_at_pos(symbols, row, col) end
    local path = {}
    for _, symbol in ipairs(symbols) do
      if pos_in_range(symbol.range, row, col) then
        table.insert(path, symbol)
        if symbol.children then vim.list_extend(path, find_symbols_at_pos(symbol.children, row, col)) end
        return path
      end
    end
    return path
  end

  local function request_symbols(buf)
    if state[buf].cancel_request then
      pcall(state[buf].cancel_request)
      state[buf].cancel_request = nil
    end

    local method = "textDocument/documentSymbol"
    local skip = { ["mini.snippets"] = true, kulala = true }
    local clients = vim.lsp.get_clients({ bufnr = buf, method = method })
    clients = vim.tbl_filter(function(c) return not skip[c.name] end, clients)
    if #clients == 0 then return end

    local params = { textDocument = vim.lsp.util.make_text_document_params(buf) }
    local function request_symbols_cb(err, result)
      state[buf].cancel_request = nil
      state[buf].lsp_result = (not err and result and #result > 0) and result or nil
      local winid = vim.fn.win_findbuf(buf)[1]
      if winid then
        local cursor = vim.api.nvim_win_get_cursor(winid)
        local row, col = cursor[1] - 1, cursor[2]
        state[buf].symbol_path = state[buf].lsp_result and find_symbols_at_pos(state[buf].lsp_result, row, col) or {}
      end
      vim.cmd.redrawstatus()
    end

    local _, cancel = vim.lsp.buf_request(buf, method, params, request_symbols_cb)

    state[buf].cancel_request = cancel
  end

  -- stylua: ignore start
  local kinds = {
    [1]  = { hl = "Normal",     icon = "" }, -- File
    [2]  = { hl = "Include",    icon = "󰏗" }, -- Module
    [3]  = { hl = "Include",    icon = "" }, -- Namespace
    [4]  = { hl = "Include",    icon = "" }, -- Package
    [5]  = { hl = "Type",       icon = "" }, -- Class
    [6]  = { hl = "Function",   icon = "" }, -- Method
    [7]  = { hl = "Identifier", icon = "" }, -- Property
    [8]  = { hl = "Identifier", icon = "" }, -- Field
    [9]  = { hl = "Function",   icon = "" }, -- Constructor
    [10] = { hl = "Type",       icon = "" }, -- Enum
    [11] = { hl = "Type",       icon = "" }, -- Interface
    [12] = { hl = "Function",   icon = "" }, -- Function
    [13] = { hl = "Identifier", icon = "" }, -- Variable
    [14] = { hl = "Constant",   icon = "" }, -- Constant
    [15] = { hl = "String",     icon = "" }, -- String
    [16] = { hl = "Number",     icon = "" }, -- Number
    [17] = { hl = "Boolean",    icon = "" }, -- Boolean
    [18] = { hl = "Type",       icon = "" }, -- Array
    [19] = { hl = "Type",       icon = "" }, -- Object
    [20] = { hl = "Identifier", icon = "" }, -- Key
    [21] = { hl = "Special",    icon = "" }, -- Null
    [22] = { hl = "Constant",   icon = "" }, -- EnumMember
    [23] = { hl = "Type",       icon = "" }, -- Struct
    [24] = { hl = "Type",       icon = "" }, -- Event
    [25] = { hl = "Operator",   icon = "" }, -- Operator
    [26] = { hl = "Type",       icon = "" }, -- TypeParameter
  }
  -- stylua: ignore end

  _G.render_symbols = function()
    local buf = vim.api.nvim_get_current_buf()
    if not state[buf] or not state[buf].enabled then return "" end
    local symbol_path = state[buf].symbol_path
    if not symbol_path or #symbol_path == 0 then return " " end
    if #symbol_path > 5 then symbol_path = vim.list_slice(symbol_path, #symbol_path - 4) end
    local parts = {}
    for _, symbol in ipairs(symbol_path) do
      local kind = kinds[symbol.kind]
      if kind then
        table.insert(parts, "%#" .. kind.hl .. "#" .. kind.icon .. "%* " .. symbol.name)
      else
        table.insert(parts, symbol.name)
      end
    end
    return " " .. table.concat(parts, "%#SpecialKey# > %*")
  end

  local group = vim.api.nvim_create_augroup("breadcrumbs", { clear = true })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    desc = "Set up breadcrumbs for documentSymbol",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      local buf = args.buf
      if client and client:supports_method("textDocument/documentSymbol", buf) then
        state[buf] = { enabled = true }
        for _, winid in ipairs(vim.fn.win_findbuf(buf)) do
          vim.wo[winid].winbar = "%{%v:lua.render_symbols()%}"
        end
        request_symbols(buf)
      end
    end,
  })

  vim.api.nvim_create_autocmd("WinNew", {
    group = group,
    desc = "Clear winbar on floating windows",
    callback = function()
      local win = vim.api.nvim_get_current_win()
      if vim.api.nvim_win_get_config(win).relative ~= "" then vim.wo[win].winbar = "" end
    end,
  })

  vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    desc = "Update symbols path",
    callback = function(args)
      if not state[args.buf] or not state[args.buf].enabled then return end
      if not state[args.buf].lsp_result then return end
      local cursor = vim.api.nvim_win_get_cursor(0)
      local row, col = cursor[1] - 1, cursor[2]
      if state[args.buf].last_row == row then return end
      state[args.buf].last_row = row
      state[args.buf].symbol_path = find_symbols_at_pos(state[args.buf].lsp_result, row, col)
    end,
  })

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    group = group,
    desc = "Re-request symbols after buffer change",
    callback = function(args)
      if not state[args.buf] or not state[args.buf].enabled then return end
      request_symbols(args.buf)
    end,
  })
end

-- #############################################################################
-- #                                 Lua Libs                                  #
-- #############################################################################

do
  local pack = vim.fn.stdpath("data") .. "/site/pack/deps"
  local pack_dirs = { pack .. "/start", pack .. "/opt" }

  local state = { mod_map = nil, libs = {}, timer = vim.uv.new_timer() }

  local function get_mod_map()
    if state.mod_map then return state.mod_map end
    state.mod_map = {}
    for _, dir in ipairs(pack_dirs) do
      local ok, iter = pcall(vim.fs.dir, dir)
      if ok then
        for name, t in iter do
          if t == "directory" then
            local lua_dir = dir .. "/" .. name .. "/lua"
            if vim.uv.fs_stat(lua_dir) then
              for entry in vim.fs.dir(lua_dir) do
                local mod = entry:gsub("%.lua$", "")
                if not state.mod_map[mod] then state.mod_map[mod] = lua_dir end
              end
            end
          end
        end
      end
    end
    return state.mod_map
  end

  local function scan_requires(buf)
    local mods = {}
    for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
      local mod = line:match("require%s*%(?%s*[\"']([%w_%-%.]+)") or line:match("%-%-%-%s*@module%s+[\"']([%w_%-%.]+)")
      if mod then mods[mod:match("^([%w_%-]+)")] = true end
    end
    return mods
  end

  local function update()
    local clients = vim.lsp.get_clients({ name = "lua_ls" })
    if #clients == 0 then return end

    local map = get_mod_map()
    if not map then return end

    local changed = false

    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype == "lua" then
        for mod in pairs(scan_requires(buf)) do
          local path = map[mod]
          if path and not state.libs[path] then
            state.libs[path] = true
            changed = true
          end
        end
      end
    end

    if not changed then return end

    local libs = { vim.env.VIMRUNTIME, "${3rd}/luv/library" }
    for path in pairs(state.libs) do
      libs[#libs + 1] = path
    end

    for _, client in ipairs(clients) do
      client.settings = vim.tbl_deep_extend("force", client.settings or {}, {
        Lua = { workspace = { library = libs, checkThirdParty = false } },
      })
      client:notify("workspace/didChangeConfiguration", { settings = client.settings })
    end
  end

  local group = vim.api.nvim_create_augroup("lua_libs", { clear = true })

  local function debounced_update(delay)
    state.timer:stop()
    state.timer:start(delay, 0, vim.schedule_wrap(update))
  end

  vim.api.nvim_create_autocmd({ "BufReadPost", "BufEnter" }, {
    pattern = "*.lua",
    group = group,
    desc = "Update lua_ls workspace libraries from require() calls",
    callback = function() debounced_update(100) end,
  })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    desc = "Initial lua_ls library scan",
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client and client.name == "lua_ls" then debounced_update(200) end
    end,
  })
end

-- #############################################################################
-- #                               Auto Suspend                                #
-- #############################################################################

-- TODO: Re-enable once Neovim 0.12 document_color assertion bug is fixed
-- do
--   local state = { stopped = false, grace = 60, timer = vim.uv.new_timer() }
--
--   local function stop()
--     for _, client in ipairs(vim.lsp.get_clients()) do
--       if client.name ~= "mini.snippets" and client.name ~= "kulala" then client:stop() end
--     end
--     state.stopped = true
--   end
--
--   local function start()
--     vim.api.nvim_exec_autocmds("FileType", { buffer = 0 })
--     state.stopped = false
--   end
--
--   local group = vim.api.nvim_create_augroup("auto_suspend", { clear = true })
--
--   vim.api.nvim_create_autocmd("FocusLost", {
--     group = group,
--     desc = "Stop LSP clients after grace period",
--     callback = function() state.timer:start(state.grace * 1000, 0, vim.schedule_wrap(stop)) end,
--   })
--
--   vim.api.nvim_create_autocmd("FocusGained", {
--     group = group,
--     desc = "Restart LSP clients on focus gain",
--     callback = function()
--       state.timer:stop()
--       if state.stopped then start() end
--     end,
--   })
-- end
