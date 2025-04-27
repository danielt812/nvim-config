local M = { "lukas-reineke/indent-blankline.nvim" }

M.enabled = false

M.event = { "BufReadPre" }

M.opts = function()
  return {
    indent = {
      char = "▎",
      tab_char = "▎",
      highlight = "IblIndent",
      smart_indent_cap = false,
      priority = 1,
    },
    whitespace = {
      highlight = "IblWhitespace",
      remove_blankline_trail = true,
    },
    scope = {
      enabled = true,
      char = nil,
      show_start = true,
      show_end = true,
      injected_languages = true,
      highlight = "IblScope",
      priority = 1024,
      include = {
        node_type = {},
      },
      exclude = {
        language = {},
        node_type = {
          ["*"] = {
            "source_file",
            "program",
          },
          lua = {
            "chunk",
          },
          python = {
            "module",
          },
        },
      },
    },
    exclude = {
      filetypes = {
        "lspinfo",
        "lazy",
        "checkhealth",
        "help",
        "man",
        "gitcommit",
        "spectre_panel",
        "mason",
        "markdown",
      },
      buftypes = {
        "terminal",
        "nofile",
        "quickfix",
        "prompt",
      },
    },
  }
end

M.config = function(_, opts)
  require("ibl").setup(opts)
end

return M
