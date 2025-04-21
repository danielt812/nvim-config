local M = { "windwp/nvim-ts-autotag" }

M.enabled = true

M.event = { "InsertEnter" }

M.opts = function()
  return {
    opts = {
      -- Defaults
      enable_close = true, -- Auto close tags
      enable_rename = true, -- Auto rename pairs of tags
      enable_close_on_slash = false, -- Auto close on trailing </
    },
  }
end

M.config = function(_, opts)
  require("nvim-ts-autotag").setup(opts)
end

return M
