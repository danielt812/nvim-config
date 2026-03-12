vim.diagnostic.config({
  signs = {
    priority = 2,
    severity = { min = "INFO", max = "ERROR" },
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.HINT] = "",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

vim.keymap.set("n", "g?", function()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(0, { lnum = row })
  if #diags == 0 then return end
  local msg = table.concat(vim.tbl_map(function(d) return d.message end, diags), "\n")
  vim.fn.setreg("+", msg)
  vim.notify("Yanked: " .. msg)
end, { desc = "Yank diagnostic" })

-- -- #############################################################################
-- -- #                            Automatic Commands                             #
-- -- #############################################################################

-- --- Create new highlight with inherited fg and bg of two existing groups
-- --- @param fg_name string
-- --- @param bg_name string
-- --- @param new_name string
-- local function merge_hl(fg_name, bg_name, new_name)
--   local fg_hl = vim.api.nvim_get_hl(0, { name = fg_name, link = false })
--   local bg_hl = vim.api.nvim_get_hl(0, { name = bg_name, link = false })
--   local fg, bg = fg_hl.fg, bg_hl.bg
--   vim.api.nvim_set_hl(0, new_name, { fg = fg, bg = bg })
-- end

-- local function gen_hl_groups()
--   merge_hl("BgYellow", "CursorLine" , "CodeAction")
-- end

-- -- Lightbulb: show virtual text when code actions are available
-- local lb_ns = vim.api.nvim_create_namespace("lightbulb")

-- local function clear_lightbulb(buf) vim.api.nvim_buf_clear_namespace(buf, lb_ns, 0, -1) end

-- local function update_lightbulb()
--   local buf = vim.api.nvim_get_current_buf()
--   local row = vim.api.nvim_win_get_cursor(0)[1] - 1

--   clear_lightbulb(buf)

--   local clients = vim.lsp.get_clients({ bufnr = buf, method = "textDocument/codeAction" })
--   if #clients == 0 then return end

--   local params = vim.tbl_extend("force", vim.lsp.util.make_range_params(0, "utf-8"), { context = { diagnostics = {} } })

--   vim.lsp.buf_request_all(buf, "textDocument/codeAction", params, function(results)
--     if not vim.api.nvim_buf_is_valid(buf) then return end
--     if vim.api.nvim_win_get_cursor(0)[1] - 1 ~= row then return end

--     for _, result in pairs(results) do
--       if result.result and #result.result > 0 then
--         vim.api.nvim_buf_set_extmark(buf, lb_ns, row, 0, {
--           virt_text = { { "", "CodeAction" } },
--           virt_text_pos = "eol",
--           priority = 1,
--         })
--         return
--       end
--     end
--   end)
-- end

-- local group = vim.api.nvim_create_augroup("lightbulb", { clear = true })

-- vim.api.nvim_create_autocmd("CursorHold", {
--   pattern = "*",
--   group = group,
--   desc = "Show lightbulb when code actions are available",
--   callback = gen_hl_groups,
-- })

-- vim.api.nvim_create_autocmd("CursorHold", {
--   pattern = "*",
--   group = group,
--   desc = "Show lightbulb when code actions are available",
--   callback = update_lightbulb,
-- })

-- vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter", "BufLeave" }, {
--   pattern = "*",
--   group = group,
--   desc = "Clear lightbulb",
--   callback = function() clear_lightbulb(vim.api.nvim_get_current_buf()) end,
-- })
