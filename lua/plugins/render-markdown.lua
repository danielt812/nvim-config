local M = { "MeanderingProgrammer/render-markdown.nvim" }

M.enabled = true

M.ft = { "markdown" }

M.opts = function()
  return {
    heading = {
      -- Turn on / off heading icon & background rendering
      enabled = true,
      -- Turn on / off any sign column related rendering
      sign = true,
      -- Determines how the icon fills the available space:
      --  inline:  underlying '#'s are concealed resulting in a left aligned icon
      --  overlay: result is left padded with spaces to hide any additional '#'
      position = "overlay",
      -- Replaces '#+' of 'atx_h._marker'
      -- The number of '#' in the heading determines the 'level'
      -- The 'level' is used to index into the array using a cycle
      icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      -- Added to the sign column if enabled
      -- The 'level' is used to index into the array using a cycle
      signs = { "󰫎 " },
      -- Width of the heading background:
      --  block: width of the heading text
      --  full:  full width of the window
      -- Can also be an array of the above values in which case the 'level' is used
      -- to index into the array using a clamp
      width = "full",
      -- Amount of padding to add to the left of headings
      left_pad = 0,
      -- Amount of padding to add to the right of headings when width is 'block'
      right_pad = 0,
      -- Minimum width to use for headings when width is 'block'
      min_width = 0,
      -- Determins if a border is added above and below headings
      border = false,
      -- Highlight the start of the border using the foreground highlight
      border_prefix = false,
      -- Used above heading for border
      above = "▄",
      -- Used below heading for border
      below = "▀",
    },
  }
end

M.config = function(_, opts)
  require("render-markdown").setup(opts)
end

return M
