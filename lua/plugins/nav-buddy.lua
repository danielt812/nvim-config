local M = { "SmiteshP/nvim-navbuddy" }

M.enabled = true

M.dependencies = {
  "SmiteshP/nvim-navic",
  "MunifTanjim/nui.nvim",
}

M.opts = function()
  return {
    window = {
      border = "single", -- "rounded", "double", "solid", "none"
      size = "60%", -- Or table format example: { height = "40%", width = "100%"}
      position = "50%", -- Or table format example: { row = "100%", col = "0%"}
      scrolloff = nil, -- scrolloff value within navbuddy window
      sections = {
        left = {
          size = "20%",
          border = nil, -- You can set border style for each section individually as well.
        },
        mid = {
          size = "40%",
          border = nil,
        },
        right = {
          -- No size option for right most section. It fills to
          -- remaining area.
          border = nil,
          preview = "leaf", -- Right section can show previews too.
          -- Options: "leaf", "always" or "never"
        },
      },
    },
    node_markers = {
      enabled = true,
      icons = {
        leaf = "  ",
        leaf_selected = " → ",
        branch = " ",
      },
    },
    icons = require("icons.kind"),
    use_default_mappings = true,
    lsp = {
      auto_attach = true, -- You don't need to manually use attach function
      preference = nil, -- List of lsp server names in order of preference
    },
    source_buffer = {
      follow_node = true, -- Keep the current node in focus on the source buffer
      highlight = true, -- Highlight the currently focused node
      reorient = "smart", -- "smart", "top", "mid" or "none"
      scrolloff = nil, -- scrolloff value when navbuddy is open
    },
  }
end

M.config = function(_, opts)
  require("nav-buddy").setup(opts)
end

return M
