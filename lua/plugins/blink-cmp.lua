local M = { "saghen/blink.cmp" }

M.enabled = true

M.dependencies = {
  "rafamadriz/friendly-snippets",
  "giuxtaposition/blink-cmp-copilot",
}

M.opts = function()
  local has_words_before = function()
    local col = vim.api.nvim_win_get_cursor(0)[2]
    if col == 0 then
      return false
    end
    local line = vim.api.nvim_get_current_line()
    return line:sub(col, col):match("%s") == nil
  end

  return {
    keymap = {
      preset = "none",
      -- ["<Tab>"] = {
      --   function(cmp)
      --     if has_words_before() then
      --       return cmp.insert_next()
      --     end
      --   end,
      --   "fallback",
      -- },
      -- ["<S-Tab>"] = { "insert_prev" },
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-space>"] = {
        function(cmp)
          cmp.show({ providers = { "snippets" } })
        end,
      },
      ["<CR>"] = {
        "accept",
        "fallback",
      },
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
                if vim.tbl_contains({ "Path" }, ctx.source_name) then
                  local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                  if dev_icon then
                    icon = dev_icon
                  end
                else
                  icon = require("lspkind").symbolic(ctx.kind, {
                    mode = "symbol",
                  })
                end

                return icon .. ctx.icon_gap
                -- local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
                -- return kind_icon
              end,
              -- (optional) use highlights from mini.icons
              -- highlight = function(ctx)
              --   local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
              --   return hl
              -- end,
            },
            -- kind = {
            --   -- (optional) use highlights from mini.icons
            --   highlight = function(ctx)
            --     local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
            --     return hl
            --   end,
            -- },
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
      nerd_font_variant = "mono",
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
            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
            local kind_idx = #CompletionItemKind + 1
            CompletionItemKind[kind_idx] = "Copilot"
            for _, item in ipairs(items) do
              item.kind = kind_idx
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
end

return M
