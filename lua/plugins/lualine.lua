local M = { "nvim-lualine/lualine.nvim" }

M.enabled = true

M.event = { "BufReadPre" }

M.opts = function()
  local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
  end

  local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn", "info", "hint" },
    symbols = { error = " ", warn = " ", info = " ", hint = " " },
    colored = true,
    update_in_insert = false,
    always_visible = false,
  }

  local diff = {
    "diff",
    colored = false,
    symbols = { added = " ", modified = " ", removed = " " }, -- changes diff symbols
    cond = hide_in_width,
  }

  local mode = {
    "mode",
    fmt = function(str)
      return str
    end,
  }

  local filetype = {
    "filetype",
    icons_enabled = true,
    icon = nil,
  }

  local branch = {
    "branch",
    icons_enabled = true,
    icon = "",
  }

  local location = {
    "location",
    padding = 1,
  }

  -- local progressbar = function()
  --   local current_line = vim.fn.line(".")
  --   local total_lines = vim.fn.line("$")
  --   local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
  --   local line_ratio = current_line / total_lines
  --   local index = math.ceil(line_ratio * #chars)
  --   return chars[index]
  -- end

  local progress = {
    "progress",
    fmt = function()
      return "%P"
      -- return "%P/%L"
    end,
    color = {},
  }

  local spaces = function()
    return "󰌒 " .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })
  end

  return {
    options = {
      theme = "auto", -- lualine theme
      component_separators = {
        left = "",
        right = "",
      },
      section_separators = {
        left = "",
        right = "",
      },
      disabled_filetypes = {
        "alpha",
        statusline = {},
        winbar = {
          "dap-repl",
          "dapui_breakpoints",
          "dapui_stacks",
          "dapui_scopes",
          "dapui_watches",
          "dapui_console",
        },
      },
      always_divide_middle = true,
      globalstatus = true,
    },
    sections = {
      lualine_a = { mode },
      lualine_b = { branch, diagnostics },
      lualine_c = {},
      lualine_x = { diff, spaces, "encoding", filetype },
      lualine_y = { location },
      lualine_z = { progress },
    },
    winbar = {
      lualine_c = {
        "navic",
        color_correction = nil,
        navic_opts = nil,
      },
    },
    tabline = {},
    extensions = {
      "aerial",
      "lazy",
      "nerdtree",
      "quickfix",
      "toggleterm",
      "trouble",
    },
  }
end

M.config = function(_, opts)
  require("lualine").setup(opts)
end

return M
