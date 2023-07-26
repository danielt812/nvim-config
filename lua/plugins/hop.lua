return {
  "phaazon/hop.nvim",
  event = { "VeryLazy" },
  config = function(_, opts)
    require("hop").setup()
    -- place this in one of your configuration file(s)
    local hop = require("hop")
    local directions = require("hop.hint").HintDirection
    vim.keymap.set("", "f", function()
      hop.hint_char2({ direction = directions.AFTER_CURSOR })
    end, { remap = true })
    vim.keymap.set("", "F", function()
      hop.hint_char2({ direction = directions.BEFORE_CURSOR })
    end, { remap = true })
  end,
}
