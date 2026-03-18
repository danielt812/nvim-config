-- https://neovim.getkulala.net/docs/getting-started/configuration-options
-- https://neovim.getkulala.net/docs/usage
-- https://neovim.getkulala.net/docs/scripts/overview

local kulala = require("kulala")
local config = require("kulala.config")
local ui = require("kulala.ui")
local bufremove = require("mini.bufremove")

-- stylua: ignore start
local scratchpad       = function() kulala.scratchpad() end
local open             = function() kulala.open() end
local close            = function() kulala.close() end
local copy             = function() kulala.copy() end
local from_curl        = function() kulala.from_curl() end
local inspect          = function() kulala.inspect() end
local open_cookies_jar = function() kulala.open_cookies_jar() end
local function run_auth()
  local auth_file = vim.fs.find("1_auth.http", { upward = true, path = vim.fn.expand("%:p:h") })[1]
  if not auth_file then return end

  local cur_buf = vim.api.nvim_get_current_buf()
  vim.cmd.edit(auth_file)
  vim.cmd("normal! gg")
  kulala.run()

  vim.defer_fn(function()
    if vim.api.nvim_buf_is_valid(cur_buf) then vim.api.nvim_set_current_buf(cur_buf) end
  end, 2000)
end

local set_selected_env = function()
  local prev_env = vim.g.kulala_selected_env
  kulala.set_selected_env()

  vim.defer_fn(function()
    if vim.g.kulala_selected_env ~= prev_env then run_auth() end
  end, 100)
end
local run_all          = function() kulala.run_all() end
local download_gql     = function() kulala.download_graphql_schema() end
local jump_next        = function() kulala.jump_next() end
local jump_prev        = function() kulala.jump_prev() end
local search           = function() kulala.search() end
local toggle_view      = function() kulala.toggle_view() end
local show_stats       = function() kulala.show_stats() end
local clear_globals    = function() kulala.scripts_clear_global() end
local clear_cached     = function() kulala.clear_cached_files() end
local run              = function() kulala.run() end
-- stylua: ignore end

kulala.setup({
  global_keymaps = {
    -- stylua: ignore start
    ["Open scratchpad"]          = { "<leader>rs", scratchpad,       prefix = false },
    ["Open kulala"]              = { "<leader>ro", open,             prefix = false },
    ["Close window"]             = { "<leader>rq", close,            ft = { "http", "rest" }, prefix = false },
    ["Copy as cURL"]             = { "<leader>rc", copy,             ft = { "http", "rest" }, prefix = false },
    ["Paste from curl"]          = { "<leader>rC", from_curl,        ft = { "http", "rest" }, prefix = false },
    ["Inspect current request"]  = { "<leader>ri", inspect,          ft = { "http", "rest" }, prefix = false },
    ["Open cookies jar"]         = { "<leader>rj", open_cookies_jar, ft = { "http", "rest" }, prefix = false },
    ["Select environment"]       = { "<leader>re", set_selected_env, ft = { "http", "rest" }, prefix = false },
    ["Download GraphQL schema"]  = { "<leader>rg", download_gql,     ft = { "http", "rest" }, prefix = false },
    ["Jump to next request"]     = { "<leader>rn", jump_next,        ft = { "http", "rest" }, prefix = false },
    ["Jump to previous request"] = { "<leader>rN", jump_prev,        ft = { "http", "rest" }, prefix = false },
    ["Find request"]             = { "<leader>rf", search,           ft = { "http", "rest" }, prefix = false },
    ["Toggle headers/body"]      = { "<leader>rt", toggle_view,      ft = { "http", "rest" }, prefix = false },
    -- ["Show stats"]               = { "<leader>rS", show_stats,       ft = { "http", "rest" }, prefix = false },
    ["Clear globals"]            = { "<leader>rx", clear_globals,    ft = { "http", "rest" }, prefix = false },
    ["Clear cached files"]       = { "<leader>rX", clear_cached,     ft = { "http", "rest" }, prefix = false },
    ["Send all requests"]        = { "<leader>ra", run_all,          mode = { "n", "v" }, prefix = false },
    ["Send request <cr>"]        = { "<CR>",       run,              mode = { "n", "v" }, ft = { "http", "rest" }, prefix = false },
    ["Show stats"]               = false,
    ["Manage Auth Config"]       = false,
    ["Send request"]             = false,
    ["Replay the last request"]  = false,
    -- stylua: ignore end
  },
  global_keymaps_prefix = "<leader>r",
  kulala_keymaps_prefix = "g",
  default_winbar_panes = { "body", "headers_body", "verbose", "script_output", "report" },
  ui = {
    max_response_size = 1048576 * 2, -- 2 MB
    winbar_labels_keymaps = true,
    win_opts = {
      wo = { number = true },
    },
  },
})

-- #############################################################################
-- #                            Automatic Commands                             #
-- #############################################################################

-- Cycle through response panes with <S-h> / <S-l>
local panes = { "body", "headers_body", "verbose", "script_output", "report" }

local show_fns = {
  body = ui.show_body,
  headers_body = ui.show_headers_body,
  verbose = ui.show_verbose,
  script_output = ui.show_script_output,
  report = ui.show_report,
}

local function get_current_pane_idx()
  local current_view = config.options.default_view
  for i, pane in ipairs(panes) do
    if pane == current_view then return i end
  end
  return 1
end

local function cycle_pane(direction)
  local idx = get_current_pane_idx() + direction
  if idx < 1 then idx = #panes end
  if idx > #panes then idx = 1 end
  local fn = show_fns[panes[idx]]
  if fn then pcall(fn) end
end

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "kulala://ui",
  callback = function(ev)
    vim.keymap.set(
      "n",
      "<S-l>",
      function() cycle_pane(1) end,
      { buffer = ev.buf, desc = "Kulala next tab", silent = true }
    )
    vim.keymap.set(
      "n",
      "<S-h>",
      function() cycle_pane(-1) end,
      { buffer = ev.buf, desc = "Kulala prev tab", silent = true }
    )
  end,
})

vim.api.nvim_create_autocmd("BufDelete", {
  desc = "Close kulala response buffer when it's the last buffer",
  callback = function()
    vim.schedule(function()
      local dominated_by_kulala = true
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.fn.buflisted(buf) == 1 then
          local ft = vim.bo[buf].filetype
          if ft ~= "" and not ft:match("kulala_ui$") then
            dominated_by_kulala = false
            break
          end
        end
      end

      if not dominated_by_kulala then return end

      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype:match("kulala_ui$") then
          bufremove.wipeout(buf, true)
        end
      end

      vim.cmd("only")
      open_starter()
    end)
  end,
})
