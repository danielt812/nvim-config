local copilot_chat = require("CopilotChat")
local copilot = require("copilot")

copilot.setup({})

copilot_chat.setup({
  window = {
    layout = "float", -- 'vertical', 'horizontal', 'float', 'replace', or a function that returns the layout
    width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
    height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
    -- Options below only apply to floating windows
    relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
    border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
    row = nil, -- row position of the window, default is centered
    col = nil, -- column position of the window, default is centered
    title = " Copilot Chat ", -- title of chat window
    footer = nil, -- footer of chat window
    zindex = 1, -- determines if window is on top or below other floating windows
  },

  show_help = true, -- Shows help message as virtual lines when waiting for user input
  highlight_selection = true, -- Highlight selection
  highlight_headers = true, -- Highlight headers in chat, disable if using markdown renderers (like render-markdown.nvim)
  references_display = "virtual", -- 'virtual', 'write', Display references in chat as virtual text or write to buffer
  auto_follow_cursor = true, -- Auto-follow cursor in chat
  auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
  insert_at_end = false, -- Move cursor to end of buffer when inserting text
  clear_chat_on_new_prompt = false, -- Clears chat on every new prompt

  chat_autocomplete = false, -- Enable chat autocompletion (when disabled, requires manual `mappings.complete` trigger)
})

-- stylua: ignore start
vim.keymap.set("n", "<leader>cc", "<cmd>CopilotChatToggle<cr>",  { desc = "Chat" })
vim.keymap.set("v", "<leader>ce", "<cmd>CopilotChatExplain<cr>", { desc = "Explain" })
vim.keymap.set("v", "<leader>cr", "<cmd>CopilotChatReview<cr>",  { desc = "Review" })
vim.keymap.set("v", "<leader>cf", "<cmd>CopilotChatFix<cr>",     { desc = "Fix" })
vim.keymap.set("v", "<leader>ct", "<cmd>CopilotChatTests<cr>",   { desc = "Generate Tests" })
vim.keymap.set("v", "<leader>cx", "<cmd>CopilotChatRefactor<cr>",{ desc = "Refactor" })
vim.keymap.set("v", "<leader>cc", "<cmd>CopilotChatToggle<cr>",  { desc = "Toggle Chat" })
-- stylua: ignore end
