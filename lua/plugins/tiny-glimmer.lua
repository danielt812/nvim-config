local M = { "rachartier/tiny-glimmer.nvim" }

M.enabled = true

M.event = { "BufReadPost" }

M.opts = function()
  return {
    -- Disable this if you wants to debug highlighting issues
    disable_warnings = false,

    refresh_interval_ms = 8,

    overwrite = {
      -- Automatically map keys to overwrite operations
      -- If set to false, you will need to call the API functions to trigger the animations
      -- WARN: You should disable this if you have already mapped these keys
      --        or if you want to use the API functions to trigger the animations
      auto_map = true,

      -- For search and paste, you can easily modify the animation to suit your needs
      -- For example you can set a table to default_animation with custom parameters:
      -- default_animation = {
      --     name = "fade",
      --
      --     settings = {
      --         max_duration = 1000,
      --         min_duration = 1000,
      --
      --         from_color = "DiffDelete",
      --         to_color = "Normal",
      --     },
      -- },
      -- settings needs to respect the animation you choose settings
      --
      -- All "mapping" needs to have a correct lhs.
      -- It will try to automatically use what you already defined before.
      yank = {
        enabled = true,
        default_animation = "fade",
      },
      search = {
        enabled = true,
        default_animation = "pulse",

        -- Keys to navigate to the next match
        next_mapping = "n",

        -- Keys to navigate to the previous match
        prev_mapping = "N",
      },
      paste = {
        enabled = true,
        default_animation = "reverse_fade",

        -- Keys to paste
        paste_mapping = "p",

        -- Keys to paste above the cursor
        Paste_mapping = "P",
      },
      undo = {
        enabled = false,

        default_animation = {
          name = "fade",

          settings = {
            from_color = "DiffDelete",

            max_duration = 500,
            min_duration = 500,
          },
        },
        undo_mapping = "u",
      },
      redo = {
        enabled = false,

        default_animation = {
          name = "fade",

          settings = {
            from_color = "DiffAdd",

            max_duration = 500,
            min_duration = 500,
          },
        },

        redo_mapping = "<c-r>",
      },
    },

    support = {
      -- Enable support for gbprod/substitute.nvim
      -- You can use it like so:
      -- require("substitute").setup({
      --     on_substitute = require("tiny-glimmer.support.substitute").substitute_cb,
      --     highlight_substituted_text = {
      --         enabled = false,
      --     },
      --})
      substitute = {
        enabled = false,

        -- Can also be a table. Refer to overwrite.search for more information
        default_animation = "fade",
      },
    },

    -- Only use if you have a transparent background
    -- It will override the highlight group background color for `to_color` in all animations
    transparency_color = nil,
    -- Animation configurations
    animations = {
      fade = {
        max_duration = 600,
        min_duration = 400,
        easing = "outQuad",
        chars_for_max_duration = 10,
        from_color = "Visual", -- Highlight group or hex color
        to_color = "Normal", -- Same as above
      },
      reverse_fade = {
        max_duration = 380,
        min_duration = 300,
        easing = "outBack",
        chars_for_max_duration = 10,
        from_color = "Visual",
        to_color = "Normal",
      },
      bounce = {
        max_duration = 500,
        min_duration = 400,
        chars_for_max_duration = 20,
        oscillation_count = 1,
        from_color = "Visual",
        to_color = "Normal",
      },
      left_to_right = {
        max_duration = 350,
        min_duration = 350,
        min_progress = 0.85,
        chars_for_max_duration = 25,
        lingering_time = 50,
        from_color = "Visual",
        to_color = "Normal",
      },
      pulse = {
        max_duration = 600,
        min_duration = 400,
        chars_for_max_duration = 15,
        pulse_count = 2,
        intensity = 1.2,
        from_color = "Visual",
        to_color = "Normal",
      },
      rainbow = {
        max_duration = 600,
        min_duration = 350,
        chars_for_max_duration = 20,
      },
      hijack_ft_disabled = {
        "alpha",
        "snacks_dashboard",
      },
    },
  }
end

M.config = function(_, opts)
  require("tiny-glimmer").setup(opts)
end

return M
