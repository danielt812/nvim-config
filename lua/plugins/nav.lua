local navic = require("nvim-navic")
local navbuddy = require("nvim-navbuddy")

local utils = require("utils")

navic.setup({
  lsp = {
    auto_attach = true, -- Enable to have nvim-navic automatically attach to every LSP for current buffer
    preference = nil, -- Table ranking lsp_servers. Lower the index, higher the priority of the server.
  },
  highlight = true, -- Add colors to icons and text as defined by highlight groups NavicIcons*
  separator = " > ",
  depth_limit = 0, -- Maximum depth of context to be shown. If the context hits this depth limit, it is truncated.
  depth_limit_indicator = "..", -- Icon to indicate that depth_limit was hit and the shown context is truncated.
  safe_output = true, -- Sanitize the output for use in statusline and winbar.
  lazy_update_context = false, -- Turns off context updates for the "CursorMoved" event.
  click = true, -- Single click to goto element, double click to open nvim-navbuddy on the clicked element.
})

navbuddy.setup({
  lsp = {
    auto_attach = true,
  },
})

function _G.get_navic_winbar()
  if navic.is_available() then
    return navic.get_location()
  end

  return ""
end

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.bo[bufnr].filetype

    -- Don't touch winbar in DAP UI buffers
    if ft:match("^dap") then
      return
    end

    if require("nvim-navic").is_available(bufnr) then
      vim.wo.winbar = "%{%v:lua.get_navic_winbar()%}"
    else
      vim.wo.winbar = ""
    end
  end,
})

utils.map("n", "<leader>en", "<cmd>Navbuddy<cr>", { desc = "Navbuddy" })
