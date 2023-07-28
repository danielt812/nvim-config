return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = function()
    local hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end

    local diagnostics = {
      "diagnostics",
      sources = { "nvim_diagnostic" },
      sections = { "error", "warn", "info", "hint" },
      symbols = { error = " ", warn = " ", info = " ", hint = " " },
      colored = false,
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

    local lspstatus = {}

    -- local progress = function()
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
        return "%P/%L"
      end,
      color = {},
    }

    local spaces = function()
      return "󰌒 " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
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
        disabled_filetypes = { "alpha" },
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { mode },
        lualine_b = { branch, diagnostics },
        lualine_c = {},
        lualine_x = { diff, spaces, "encoding", filetype },
        lualine_y = { location },
        lualine_z = { "progress" },
      },
      -- inactive_sections = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = { "filename" },
      --   lualine_x = { "location" },
      --   lualine_y = {},
      --   lualine_z = {},
      -- },
      tabline = {},
      extensions = {},
    }
  end,
  config = function(_, opts)
    require("lualine").setup(opts)
  end,
}
