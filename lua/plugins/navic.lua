local M = { "SmiteshP/nvim-navic" }

M.enabled = true

M.dependencies = { "onsails/lspkind.nvim" }

M.event = { "LspAttach" }

M.opts = function()
  return {
    -- icons = require("lspkind").symbol_map, -- Indicate the type of symbol captured.
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
  }
end

M.config = function(_, opts)
  require("nvim-navic").setup(opts)

  -- function _G.get_navic_winbar()
  --   local ok, navic = pcall(require, "nvim-navic")
  --   if not ok then
  --     return ""
  --   end
  --
  --   if navic.is_available() then
  --     return navic.get_location()
  --   end
  --   return ""
  -- end

  -- vim.opt.winbar = "%{%v:lua.get_navic_winbar()%}"
end

return M
