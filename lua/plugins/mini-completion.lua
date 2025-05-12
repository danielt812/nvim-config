local M = { "echasnovski/mini.completion" }

M.enabled = false

M.event = { "InsertEnter" }

M.opts = function()
  return {
    {
      -- Delay (debounce type, in ms) between certain Neovim event and action.
      -- This can be used to (virtually) disable certain automatic actions by
      -- setting very high delay time (like 10^7).
      delay = { completion = 100, info = 100, signature = 50 },

      -- Configuration for action windows:
      -- - `height` and `width` are maximum dimensions.
      -- - `border` defines border (as in `nvim_open_win()`; default "single").
      window = {
        info = { height = 25, width = 80, border = nil },
        signature = { height = 25, width = 80, border = nil },
      },

      -- Way of how module does LSP completion
      lsp_completion = {
        -- `source_func` should be one of 'completefunc' or 'omnifunc'.
        source_func = "completefunc",

        -- `auto_setup` should be boolean indicating if LSP completion is set up
        -- on every `BufEnter` event.
        auto_setup = true,

        -- A function which takes LSP 'textDocument/completion' response items
        -- (each with `client_id` field for item's server) and word to complete.
        -- Output should be a table of the same nature as input. Common use case
        -- is custom filter/sort. Default: `default_process_items`
        process_items = nil,

        -- A function which takes a snippet as string and inserts it at cursor.
        -- Default: `default_snippet_insert` which tries to use 'mini.snippets'
        -- and falls back to `vim.snippet.expand` (on Neovim>=0.10).
        snippet_insert = nil,
      },

      -- Fallback action as function/string. Executed in Insert mode.
      -- To use built-in completion (`:h ins-completion`), set its mapping as
      -- string. Example: set '<C-x><C-l>' for 'whole lines' completion.
      fallback_action = "<C-n>",

      -- Module mappings. Use `''` (empty string) to disable one. Some of them
      -- might conflict with system mappings.
      mappings = {
        -- Force two-step/fallback completions
        force_twostep = "<C-Space>",
        force_fallback = "<A-Space>",

        -- Scroll info/signature window down/up. When overriding, check for
        -- conflicts with built-in keys for popup menu (like `<C-u>`/`<C-o>`
        -- for 'completefunc'/'omnifunc' source function; or `<C-n>`/`<C-p>`).
        scroll_down = "<C-f>",
        scroll_up = "<C-b>",
      },
    },
  }
end

M.config = function(_, opts)
  require("mini.completion").setup()
end

return M
