return {
  "folke/twilight.nvim",
  event = { "BufReadPost" },
  cmd = { "Twilight", "TwilightEnable", "TwilightEnable" },
  opts = function()
    return {
      dimming = {
        alpha = 0.25, -- amount of dimming
        -- we try to get the foreground from the highlight groups or fallback color
        color = { "Normal", "#ffffff" },
        term_bg = "#000000", -- if guibg=NONE, this will be used to calculate text color
        inactive = false, -- when true, other windows will be fully dimmed (unless they contain the same buffer)
      },
      context = 10, -- amount of lines we will try to show around the current line
      treesitter = true, -- use treesitter when available for the filetype
      -- treesitter is used to automatically expand the visible text,
      -- but you can further control the types of nodes that should always be fully expanded
      expand = { -- for treesitter, we we always try to expand to the top-most ancestor with these types
        "function",
        "method",
        "table",
        "if_statement",
      },
      exclude = {}, -- exclude these filetypes
    }
  end,
  config = function(_, opts)
    require("twilight").setup(opts)

    local function map(mode, lhs, rhs, key_opts)
      lhs = "<leader>t" .. lhs
      rhs = "<cmd>" .. rhs .. "<CR>"
      key_opts = key_opts or {}
      key_opts.silent = key_opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, key_opts)
    end

    map("n", "i", "Twilight", { desc = "Twilight 󰖚 " })
  end,
}
