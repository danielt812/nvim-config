return {
  "kylechui/nvim-surround",
  event = { "BufEnter" },
  opts = function()
    return {
      keymaps = {
        insert = "<C-g>s",
        insert_line = "<C-g>S",
        normal = "ys",
        normal_cur = "yss",
        normal_line = "yS",
        normal_cur_line = "ySS",
        visual = "S",
        visual_line = "gS",
        delete = "ds",
        change = "cs",
        change_line = "cS",
      },
      aliases = {
        ["a"] = ">",
        ["b"] = ")",
        ["B"] = "}",
        ["r"] = "]",
        ["q"] = { '"', "'", "`" },
        ["s"] = { "}", "]", ")", ">", '"', "'", "`" },
      },
    }
  end,
  config = function(_, opts)
    require("nvim-surround").setup(opts)

    local function map(mode, lhs, rhs, key_opts)
      key_opts = key_opts or {}
      key_opts.silent = key_opts.silent ~= false
      vim.keymap.set(mode, lhs, rhs, key_opts)
    end

    map("n", "ys", "<Plug>(nvim-surround-normal)", { desc = "Add surround" })
    map("n", "yss", "<Plug>(nvim-surround-normal-cur)", { desc = "Add surround around line" })
    map("n", "yS", "<Plug>(nvim-surround-normal-line)", { desc = "Add surround vertical" })
    map("n", "ySS", "<Plug>(nvim-surround-normal-cur-line)", { desc = "Add surround around line on new lines" })
    map("v", "S", "<Plug>(nvim-surround-visual)", { desc = "Add surround" })
    map("v", "gS", "<Plug>(nvim-surround-visual-line)", { desc = "Add surround vertical" })
    map("n", "cs", "<Plug>(nvim-surround-change)", { desc = "Change surround" })
    map("n", "ds", "<Plug>(nvim-surround-delete)", { desc = "Delete surround" })
  end,
}
