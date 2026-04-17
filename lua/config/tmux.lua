if not os.getenv("TMUX") then return end

-- stylua: ignore start
local socket   = vim.split(os.getenv("TMUX") or "", ",")[1]
local pane     = os.getenv("TMUX_PANE")
local pane_id  = pane and tonumber(pane:sub(2)) or nil

local dirs = { h = "L", j = "D", k = "U", l = "R" }
local opp  = { h = "l", j = "k", k = "j", l = "h" }
-- stylua: ignore end

local function tmux_exec(cmd)
  local h = io.popen("tmux -S " .. socket .. " " .. cmd)
  if not h then return "" end
  local out = h:read("*a")
  h:close()
  return out
end

-- Returns true if the current tmux pane is at the window edge in direction dir
local function is_tmux_border(dir)
  local display = tmux_exec("display-message -p '#{window_layout}'")
  if display == "" then return true end

  local total_w = tonumber(display:match("^%w+,(%d+)x%d+"))
  local total_h = tonumber(display:match("^%w+,%d+x(%d+)"))
  if not total_w or not total_h then return true end

  for entry in display:gmatch("(%d+x%d+,%d+,%d+,%d+)") do
    local id = tonumber(entry:match("%d+x%d+,%d+,%d+,(%d+)"))
    if id == pane_id then
      local x = tonumber(entry:match("%d+x%d+,(%d+),%d+,%d+"))
      local y = tonumber(entry:match("%d+x%d+,%d+,(%d+),%d+"))
      local w = tonumber(entry:match("(%d+)x%d+"))
      local h = tonumber(entry:match("%d+x(%d+)"))
      if dir == "h" then return x == 0 end
      if dir == "j" then return y + h == total_h end
      if dir == "k" then return y == 0 end
      if dir == "l" then return x + w == total_w end
    end
  end

  return true
end

local function navigate(dir)
  if vim.fn.getcmdwintype() ~= "" then return end

  local at_nvim_border = vim.fn.winnr() == vim.fn.winnr("1" .. dir)

  if vim.api.nvim_win_get_config(0).relative ~= "" or at_nvim_border then
    if not is_tmux_border(dir) then
      tmux_exec(string.format("select-pane -t '%s' -%s", pane, dirs[dir]))
      vim.o.laststatus = vim.o.laststatus -- reset statusline (can disappear after pane switch)
    elseif at_nvim_border then
      vim.cmd("999wincmd " .. opp[dir]) -- cycle within nvim
    end
  else
    vim.cmd(vim.v.count .. "wincmd " .. dir)
  end
end

for _, dir in ipairs({ "h", "j", "k", "l" }) do
  vim.keymap.set("n", "<C-" .. dir .. ">", function() navigate(dir) end, { desc = "Navigate " .. dir })
end
