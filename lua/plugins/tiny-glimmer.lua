local glimmer = require("tiny-glimmer")

glimmer.setup({
  -- Disable this if you wants to debug highlighting issues
  disable_warnings = false,
  overwrite = {
    auto_map = true,

    yank = {
      enabled = true,
      default_animation = {
        name = "fade",
        settings = {
          from_color = "BgYellow",
          to_color = "Normal",
          max_duration = 400,
          min_duration = 300,
        },
      },
    },
    search = {
      enabled = true,
      default_animation = {
        "pulse",
        settings = {
          from_color = "BgBlue",
          to_color = "IncSearch",
          max_duration = 800,
          min_duration = 500,
        },
      },
      next_mapping = "n",
      prev_mapping = "N",
    },
    paste = {
      enabled = true,
      default_animation = {
        name = "fade",

        settings = {
          from_color = "BgGreen",
          to_color = "Normal",
          max_duration = 400,
          min_duration = 300,
        },
      },
      paste_mapping = "p",
      Paste_mapping = "P",
    },
    undo = {
      enabled = true,

      default_animation = {
        name = "fade",

        settings = {
          from_color = "BgRed",
          to_color = "Normal",
          max_duration = 400,
          min_duration = 300,
        },
      },
      undo_mapping = "u",
    },
    redo = {
      enabled = true,

      default_animation = {
        name = "fade",

        settings = {
          from_color = "BgGreen",
          to_color = "Normal",
          max_duration = 400,
          min_duration = 300,
        },
      },

      redo_mapping = "<c-r>",
    },
  },
  hijack_ft_disabled = {
    "ministarter",
  },
})
