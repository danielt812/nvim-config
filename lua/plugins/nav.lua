local navic = require("nvim-navic")
local navbuddy = require("nvim-navbuddy")

local utils = require("utils")

navic.setup({
  lsp = {
    auto_attach = false, -- Enable to have nvim-navic automatically attach to every LSP for current buffer
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
    auto_attach = false,
  },
})

function _G.get_navic_winbar()
  if navic.is_available() then
    return navic.get_location()
  end

  return ""
end

local au = vim.api.nvim_create_autocmd
local augroup = vim.api.nvim_create_augroup

au("LspAttach", {
  group = augroup("navic_attach", { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.server_capabilities.documentSymbolProvider then
      navic.attach(client, args.buf)
      navbuddy.attach(client, args.buf)
    end
  end,
})

au("CursorMoved", {
  group = augroup("navic_winbar", { clear = true }),
  desc = "Toggle winbar based on buffer filetype",
  callback = function(args)
    local ft = vim.bo[args.buf].filetype

    -- Don't touch winbar in DAP UI buffers or Kulala buffers
    if ft:match("^dap") or ft:match("kulala") or ft == "http" then
      return
    end

    if navic.is_available(args.buf) then
      vim.wo.winbar = "%{%v:lua.get_navic_winbar()%}"
    else
      vim.wo.winbar = ""
    end
  end,
})

au({ "WinEnter", "WinResized" }, {
  group = augroup("navic_winbar_toggle", { clear = true }),
  desc = "Hide winbar when any blame window is open",
  callback = function()
    vim.schedule(function()
      local has_blame = false

      -- Check if any window has a blame buffer
      for _, win_id in ipairs(vim.api.nvim_list_wins()) do
        local buf_id = vim.api.nvim_win_get_buf(win_id)
        local ft = vim.api.nvim_get_option_value("filetype", { buf = buf_id })
        if ft == "blame" or ft == "gitblame" then
          has_blame = true
          break
        end
      end

      if has_blame then
        for _, win_id in ipairs(vim.api.nvim_list_wins()) do
          pcall(vim.api.nvim_set_option_value, "winbar", "", { win = win_id })
        end
      else
        for _, win_id in ipairs(vim.api.nvim_list_wins()) do
          local buf_id = vim.api.nvim_win_get_buf(win_id)
          if navic.is_available(buf_id) then
            vim.api.nvim_set_option_value("winbar", "%{%v:lua.get_navic_winbar()%}", { win = win_id })
          else
            vim.api.nvim_set_option_value("winbar", "", { win = win_id })
          end
        end
      end
    end)
  end,
})

utils.map("n", "<leader>en", "<cmd>Navbuddy<cr>", { desc = "Navbuddy" })
