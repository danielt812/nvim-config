local pick = require("mini.pick")
local extra = require("mini.extra")

pick.setup({
  window = {
    config = function()
      local width = vim.o.columns
      if width <= 110 then return { width = math.floor(width * 0.8) } end
      return {}
    end,
  },
  mappings = {
    mark = "<C-x>",
    mark_all = "<C-a>",
    move_down = "<C-j>",
    move_start = "<C-g>",
    move_up = "<C-k>",
    sys_paste = {
      char = "<C-v>",
      func = function() pick.set_picker_query({ vim.fn.getreg("+") }) end,
    },
  },
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

-- NOTE: Only filter colorschemes in my runtime
local function pick_colorschemes()
  local config = vim.fn.stdpath("config")
  local names = vim.tbl_filter(function(name)
    local files = vim.list_extend(
      vim.api.nvim_get_runtime_file("colors/" .. name .. ".vim", false),
      vim.api.nvim_get_runtime_file("colors/" .. name .. ".lua", false)
    )
    for _, path in ipairs(files) do
      if vim.startswith(path, config) then return true end
    end
    return false
  end, vim.fn.getcompletion("", "color"))
  extra.pickers.colorschemes({ names = names })
end

local function pick_git_checkout(remote)
  local cmd = remote and "git branch -r" or "git branch"
  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("git branch failed", vim.log.levels.ERROR)
    return
  end

  local local_branches = {}
  if remote then
    for _, line in ipairs(vim.fn.systemlist("git branch")) do
      local b = line:match("^%*?%s*(.+)$")
      if b then local_branches[b] = true end
    end
  end

  local branches = {}
  for _, line in ipairs(lines) do
    local branch = line:match("^%*?%s*(.+)$")
    if branch and not line:match("^%*") and not branch:match("^%S+ %->") then
      if remote then branch = branch:gsub("^%S+/", "", 1) end
      if not local_branches[branch] then
        table.insert(branches, branch)
      end
    end
  end

  pick.start({
    source = {
      name = remote and "Git branches (remote)" or "Git branches (local)",
      items = branches,
      choose = function(item) vim.cmd("Git checkout " .. item) end,
    },
  })
end

local function pick_git_delete(remote)
  local cmd = remote and "git branch -r" or "git branch"
  local lines = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("git branch failed", vim.log.levels.ERROR)
    return
  end

  local branches = {}
  for _, line in ipairs(lines) do
    local branch = line:match("^%*?%s*(.+)$")
    if branch and not line:match("^%*") and not branch:match("^%S+ %->") then
      if remote then branch = branch:gsub("^%S+/", "", 1) end
      table.insert(branches, branch)
    end
  end

  local function delete_branch(items)
    local label = #items == 1 and items[1] or (#items .. " branches")
    local choice = vim.fn.confirm("Delete " .. label .. "?", "&Yes\n&No", 2)
    if choice ~= 1 then return end
    for _, branch in ipairs(items) do
      if remote then
        vim.cmd("Git push origin --delete " .. branch)
      else
        vim.cmd("Git branch -d " .. branch)
      end
    end
  end

  pick.start({
    source = {
      name = remote and "Delete remote branches" or "Delete local branches",
      items = branches,
      choose = function(item) delete_branch({ item }) end,
      choose_marked = function(items) delete_branch(items) end,
    },
  })
end

pick.registry.colorschemes = pick_colorschemes
pick.registry.git_checkout_local  = function() pick_git_checkout(false) end
pick.registry.git_checkout_remote = function() pick_git_checkout(true) end
pick.registry.git_delete_local    = function() pick_git_delete(false) end
pick.registry.git_delete_remote   = function() pick_git_delete(true) end

-- stylua: ignore start
vim.keymap.set("n", "<leader>fc", "<cmd>Pick colorschemes<cr>",        { desc = "Colorschemes" })
vim.keymap.set("n", "<leader>fe", "<cmd>Pick explorer<cr>",            { desc = "Explorer" })
vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>",               { desc = "Files" })
vim.keymap.set("n", "<leader>fg", "<cmd>Pick grep_live<cr>",           { desc = "Livegrep" })
vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>",                { desc = "Help" })
vim.keymap.set("n", "<leader>fi", "<cmd>Pick hl_groups<cr>",           { desc = "Highlights" })
vim.keymap.set("n", "<leader>fk", "<cmd>Pick keymaps<cr>",             { desc = "Keymaps" })
vim.keymap.set("n", "<leader>fl", "<cmd>Pick buf_lines<cr>",           { desc = "Lines" })
vim.keymap.set("n", "<leader>fm", "<cmd>Pick marks<cr>",               { desc = "Marks" })
vim.keymap.set("n", "<leader>fv", "<cmd>Pick visit_labels<cr>",        { desc = "Visits" })
vim.keymap.set("n", "<leader>gc", "<cmd>Pick git_checkout_local<cr>",  { desc = "Checkout (local)" })
vim.keymap.set("n", "<leader>gC", "<cmd>Pick git_checkout_remote<cr>", { desc = "Checkout (remote)" })
vim.keymap.set("n", "<leader>gd", "<cmd>Pick git_delete_local<cr>",    { desc = "Delete branch (local)" })
vim.keymap.set("n", "<leader>gD", "<cmd>Pick git_delete_remote<cr>",   { desc = "Delete branch (remote)" })
-- stylua: ignore end
