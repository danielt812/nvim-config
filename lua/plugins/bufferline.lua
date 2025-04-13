local M = { "akinsho/bufferline.nvim" }

M.enabled = true

M.dependencies = { "echasnovski/mini.icons" }

M.event = { "BufRead" }

M.keys = {
  { "<S-h>", "<cmd>BufferLineCyclePrev<cr>" },
  { "<S-l>", "<cmd>BufferLineCycleNext<cr>" },
  -- Pin
  { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Pin  " },
  -- Go to
  { "<leader>bgl", "<cmd>BufferLineCycleNext<cr>", desc = "Next 󰮱 " },
  { "<leader>bgh", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev 󰮳 " },
  { "<leader>bgp", "<cmd>BufferLinePick<cr>", desc = "Pick  " },
  -- Close
  { "<leader>bcc", "<cmd>BufferClose<cr>", desc = "Current  " },
  { "<leader>bch", "<cmd>BufferLineCloseLeft<cr>", desc = "Left 󰳞 " },
  { "<leader>bcp", "<cmd>BufferLinePickClose<cr>", desc = "Prev  " },
  { "<leader>bcl", "<cmd>BufferLineCloseRight<cr>", desc = "Right 󰳠 " },
  { "<leader>bco", "<cmd>BufferLineCloseOthers<cr>", desc = "Others  " },
  { "<leader>bcp", "<cmd>BufferLineGroupClose pinned<cr>", desc = "Pinned 󰤱 " },
  { "<leader>bcu", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Unpinned 󰤰 " },
}

M.opts = function()
  local function is_ft(b, ft)
    return vim.bo[b].filetype == ft
  end

  local function custom_filter(buf, buf_nums)
    local logs = vim.tbl_filter(function(b)
      return is_ft(b, "log")
    end, buf_nums or {})
    if vim.tbl_isempty(logs) then
      return true
    end
    local tab_num = vim.fn.tabpagenr()
    local last_tab = vim.fn.tabpagenr("$")
    local is_log = is_ft(buf, "log")
    if last_tab == 1 then
      return true
    end
    -- only show log buffers in secondary tabs
    return (tab_num == last_tab and is_log) or (tab_num ~= last_tab and not is_log)
  end

  return {
    highlights = {
      background = {
        italic = true,
      },
      buffer_selected = {
        bold = true,
      },
    },
    options = {
      mode = "buffers",
      themable = true, -- whether or not bufferline highlights can be overridden externally
      numbers = "none",
      buffer_close_icon = "",
      modified_icon = "●",
      close_icon = "",
      close_command = function(bufnr) -- can be a string | function, see "Mouse actions"
        require("utils.buf_kill").buf_kill("bd", bufnr, false)
      end,
      left_mouse_command = "buffer %d",
      right_mouse_command = "vert sbuffer %d",
      middle_mouse_command = nil,
      indicator = "▎",
      left_trunc_marker = "",
      right_trunc_marker = "",
      separator_style = "thin",
      name_formatter = nil,
      truncate_names = true,
      tab_size = 18,
      max_name_length = 18,
      color_icons = true,
      show_buffer_icons = true,
      show_buffer_close_icons = true,
      get_element_icon = nil,
      show_close_icon = false,
      show_tab_indicators = true,
      show_duplicate_prefix = true,
      enforce_regular_tabs = false,
      always_show_bufferline = true,
      persist_buffer_sort = true,
      move_wraps_at_ends = false,
      max_prefix_length = 15,
      sort_by = "id",
      diagnostics = false,
      diagnostics_indicator = nil,
      diagnostics_update_in_insert = true,
      custom_filter = custom_filter,
      offsets = {
        {
          filetype = "NvimTree",
          text = "Explorer",
          highlight = "PanelHeading",
          padding = 0,
        },

        {
          filetype = "DiffviewFiles",
          text = "Diff View",
          highlight = "PanelHeading",
          padding = 0,
        },
        {
          filetype = "lazy",
          text = "Lazy",
          highlight = "PanelHeading",
          padding = 0,
        },
      },
      groups = { items = {}, options = { toggle_hidden_on_enter = true } },
      hover = { enabled = false, reveal = { "close" }, delay = 200 },
      debug = { logging = false },
    },
  }
end

M.config = function(_, opts)
  require("bufferline").setup(opts)
end

return M
