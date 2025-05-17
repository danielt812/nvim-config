local M = { "echasnovski/mini.visits" }

M.enabled = true

M.event = { "VimEnter" }

M.opts = function()
  return {
    {
      list = {
        -- Predicate for which paths to include (all by default)
        filter = nil,

        -- Sort paths based on the visit data (robust frecency by default)
        sort = nil,
      },

      -- Whether to disable showing non-error feedback
      silent = false,

      -- How visit index is stored
      store = {
        -- Whether to write all visits before Neovim is closed
        autowrite = true,

        -- Function to ensure that written index is relevant
        normalize = nil,

        -- Path to store visit index
        path = vim.fn.stdpath("data") .. "/mini-visits-index",
      },

      -- How visit tracking is done
      track = {
        -- Start visit register timer at this event
        -- Supply empty string (`''`) to not do this automatically
        event = "BufEnter",

        -- Debounce delay after event to register a visit
        delay = 1000,
      },
    },
  }
end

M.config = function(_, opts)
  require("mini.visits").setup(opts)
end

return M
