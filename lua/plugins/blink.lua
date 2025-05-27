local blink = require("blink.cmp")
local icons = require("mini.icons")
local copilot = require("copilot")

copilot.setup()

blink.setup({
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
              local kind_icon, _, _ = icons.get("lsp", ctx.kind)
              return kind_icon
            end,
            highlight = function(ctx)
              local _, hl, _ = icons.get("lsp", ctx.kind)
              return hl
            end,
          },
          kind = {
            highlight = function(ctx)
              local _, hl, _ = icons.get("lsp", ctx.kind)
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
  snippets = {
    preset = "mini_snippets",
  },
  sources = {
    default = {
      "lazydev",
      "lsp",
      "path",
      "snippets",
      "buffer",
      "copilot",
    },
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
})
