local M = { "SmiteshP/nvim-navic" }

M.enabled = true

M.event = { "LspAttach" }

M.opts = function()
  local icons = require("icons")
  return {
    icons = icons.kind, -- Indicate the type of symbol captured.
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
end

return M
