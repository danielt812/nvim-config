local cache = {}

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

local pos_in_range = function(range, row, col)
  if not range or not range.start or not range["end"] then return false end
  if row < range.start.line or row > range["end"].line then return false end
  if row == range.start.line and col < range.start.character then return false end
  if row == range["end"].line and col > range["end"].character then return false end
  return true
end

local find_flat_symbols_at_pos = function(symbols, row, col)
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

local find_symbols_at_pos
find_symbols_at_pos = function(symbols, row, col)
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

local request_symbols = function(buf)
  if cache[buf].cancel_request then
    pcall(cache[buf].cancel_request)
    cache[buf].cancel_request = nil
  end

  local method = "textDocument/documentSymbol"
  local params = { textDocument = vim.lsp.util.make_text_document_params(buf) }
  local request_symbols_cb = function(err, result)
    cache[buf].cancel_request = nil
    cache[buf].lsp_result = (not err and result and #result > 0) and result or nil
    local winid = vim.fn.win_findbuf(buf)[1]
    if winid then
      local cursor = vim.api.nvim_win_get_cursor(winid)
      local row, col = cursor[1] - 1, cursor[2]
      cache[buf].symbol_path = cache[buf].lsp_result and find_symbols_at_pos(cache[buf].lsp_result, row, col) or {}
    end
    vim.cmd.redrawstatus()
  end

  local _, cancel = vim.lsp.buf_request(buf, method, params, request_symbols_cb)

  cache[buf].cancel_request = cancel
end

-- Shared on_attach
local on_attach = function(client, buf)
  local map = function(mode, lhs, rhs, opts)
    opts = opts or {}
    opts.silent = opts.silent ~= false
    opts.buffer = buf
    vim.keymap.set(mode, lhs, rhs, opts)
  end

  -- stylua: ignore start
  map("n", "K",          vim.lsp.buf.hover,           { desc = "Hover" })

  -- g mappings
  map("n", "gd",         vim.lsp.buf.definition,      { desc = "Go to Definition" })
  map("n", "gla",        vim.lsp.buf.code_action,     { desc = "Code Action" })
  map("n", "glc",        vim.lsp.buf.declaration,     { desc = "Declaration" })
  map("n", "gld",        vim.lsp.buf.definition,      { desc = "Definition" })
  map("n", "glh",        vim.lsp.buf.hover,           { desc = "Hover" })
  map("n", "gli",        vim.lsp.buf.implementation,  { desc = "Implementation" })
  map("n", "gln",        vim.lsp.buf.rename,          { desc = "Rename" })
  map("n", "glr",        vim.lsp.buf.references,      { desc = "References" })
  map("n", "gls",        vim.lsp.buf.signature_help,  { desc = "Signature Help" })
  map("n", "glt",        vim.lsp.buf.type_definition, { desc = "Type Definition" })

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

  if client:supports_method("textDocument/documentSymbol", buf) then
    cache[buf] = { enabled = true }
    for _, winid in ipairs(vim.fn.win_findbuf(buf)) do
      vim.wo[winid].winbar = "%{%v:lua.render_symbols()%}"
    end
    request_symbols(buf)
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
  "taplo",
  "tailwindcss",
  "ts_ls",
  "tsgo",
  "yamlls",
}

vim.highlight.priorities.semantic_tokens = 100

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

vim.api.nvim_create_user_command("LspInfo", function() vim.cmd("checkhealth lsp") end, { desc = "Lsp checkhealth" })
vim.api.nvim_create_user_command(
  "LspLog",
  function() vim.cmd("edit " .. vim.lsp.get_log_path()) end,
  { desc = "Lsp log" }
)

-- #############################################################################
-- #                                Breadcrumbs                                #
-- #############################################################################

-- stylua: ignore start
local kinds = {
  [1]  = { hl = "Normal",     icon = "" },
  [2]  = { hl = "Include",    icon = "󰏗" },
  [3]  = { hl = "Include",    icon = "" },
  [4]  = { hl = "Include",    icon = "" },
  [5]  = { hl = "Type",       icon = "" },
  [6]  = { hl = "Function",   icon = "" },
  [7]  = { hl = "Identifier", icon = "" },
  [8]  = { hl = "Identifier", icon = "" },
  [9]  = { hl = "Function",   icon = "" },
  [10] = { hl = "Type",       icon = "" },
  [11] = { hl = "Type",       icon = "" },
  [12] = { hl = "Function",   icon = "" },
  [13] = { hl = "Identifier", icon = "" },
  [14] = { hl = "Constant",   icon = "" },
  [15] = { hl = "String",     icon = "" },
  [16] = { hl = "Number",     icon = "" },
  [17] = { hl = "Boolean",    icon = "" },
  [18] = { hl = "Type",       icon = "" },
  [19] = { hl = "Type",       icon = "" },
  [20] = { hl = "Identifier", icon = "" },
  [21] = { hl = "Special",    icon = "" },
  [22] = { hl = "Constant",   icon = "" },
  [23] = { hl = "Type",       icon = "" },
  [24] = { hl = "Type",       icon = "" },
  [25] = { hl = "Operator",   icon = "" },
  [26] = { hl = "Type",       icon = "" },
}
-- stylua: ignore end

_G.render_symbols = function()
  local buf = vim.api.nvim_get_current_buf()
  if not cache[buf] or not cache[buf].enabled then return "" end
  local symbol_path = cache[buf].symbol_path
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

local group = vim.api.nvim_create_augroup("lsp", { clear = true })

local moved_cb = function(args)
  if not cache[args.buf] or not cache[args.buf].enabled then return end
  if not cache[args.buf].lsp_result then return end
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row, col = cursor[1] - 1, cursor[2]
  if cache[args.buf].last_row == row then return end
  cache[args.buf].last_row = row
  cache[args.buf].symbol_path = find_symbols_at_pos(cache[args.buf].lsp_result, row, col)
end

local text_changed_cb = function(args)
  if not cache[args.buf] or not cache[args.buf].enabled then return end
  request_symbols(args.buf)
end

vim.api.nvim_create_autocmd("CursorMoved", {
  pattern = "*",
  group = group,
  desc = "Update symbols path",
  callback = moved_cb,
})

vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
  pattern = "*",
  group = group,
  desc = "Re-request symbols after buffer change",
  callback = text_changed_cb,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  group = group,
  desc = "Semantic highlighting",
  callback = function() vim.api.nvim_set_hl(0, "@lsp.type.variable", {}) end,
})
