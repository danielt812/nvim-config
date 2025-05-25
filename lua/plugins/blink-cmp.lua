local M = { "saghen/blink.cmp" }

M.enabled = true

M.dependencies = {
  "rafamadriz/friendly-snippets",
  "giuxtaposition/blink-cmp-copilot",
}

M.opts = function()
  return {
    keymap = {
      preset = "none",
      -- stylua: ignore start
      ["<Up>"]   = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-k>"]  = { "select_prev", "fallback" },
      ["<C-j>"]  = { "select_next", "fallback" },
      ["<C-space>"] = {
        function(cmp)
          cmp.show({ providers = { "snippets" } })
        end,
      },
      ["<CR>"] = {
        "accept",
        "fallback",
      },
      -- stylua: ignore end
    },
    completion = {
      menu = {
        enabled = true,
        border = "single",
        draw = {
          treesitter = {
            "lsp",
          },
          columns = {
            {
              "label",
              "label_description",
              gap = 2,
            },
            {
              "kind_icon",
              gap = 1,
              "kind",
            },
          },
          components = {
            kind_icon = {
              text = function(ctx)
                local icon = ctx.kind_icon
                icon = require("lspkind").symbolic(ctx.kind, {
                  mode = "symbol",
                })

                return icon .. ctx.icon_gap
                -- local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                -- return kind_icon
              end,
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
            kind = {
              highlight = function(ctx)
                local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
                return hl
              end,
            },
          },
        },
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
        cycle = {
          from_top = false,
        },
      },
    },

    signature = {
      enabled = true,
      window = { border = "single" },
    },

    appearance = {
      -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
      -- Adjusts spacing to ensure icons are aligned
      nerd_font_variant = "normal",
    },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
      default = { "lsp", "path", "snippets", "buffer", "copilot", "lazydev" },
      providers = {
        copilot = {
          name = "copilot",
          module = "blink-cmp-copilot",
          score_offset = 100,
          async = true,
          enabled = true,
          transform_items = function(_, items)
            for _, item in pairs(items) do
              item.kind_icon = ""
              item.kind_name = "Copilot"
            end
            return items
          end,
        },
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
          enabled = true,
        },
      },
    },
    fuzzy = {
      implementation = "lua",
    },
  }
end

M.config = function(_, opts)
  require("blink.cmp").setup(opts)

  local kind_links = {
    Text = "Statement",
    Method = "Function",
    Function = "Function",
    Constructor = "Type",
    Field = "Structure",
    Variable = "Identifier",
    Class = "Type",
    Interface = "Type",
    Module = "Include",
    Property = "Identifier",
    Unit = "Number",
    Value = "Number",
    Enum = "Type",
    Keyword = "Keyword",
    Snippet = "Special",
    Color = "Special",
    File = "Directory",
    Reference = "Identifier",
    Folder = "Directory",
    EnumMember = "Constant",
    Constant = "Constant",
    Struct = "Structure",
    Event = "Exception",
    Operator = "Operator",
    TypeParameter = "Type",
  }

  for kind, link in pairs(kind_links) do
    vim.api.nvim_set_hl(0, "BlinkCmpKind" .. kind, { link = link })
  end

  vim.api.nvim_set_hl(0, "BlinkCmpMenu", { fg = "#ffffff" })
end

return M
