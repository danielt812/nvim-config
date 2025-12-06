local job_cache = {}

-- Set your desired port here:
local PORT = 5555

local function find_cached_dir(dir)
  if not dir then
    vim.notify("live-server.nvim: No directory provided to find_cached_dir()", vim.log.levels.ERROR)
    return
  end

  local cur = dir
  while not job_cache[cur] do
    if cur == "/" then
      return
    end
    cur = vim.fn.fnamemodify(cur, ":h")
  end
  return cur
end

local function is_running(dir)
  local cached_dir = find_cached_dir(dir)
  return cached_dir and job_cache[cached_dir]
end

local function start_live_server(dir)
  if is_running(dir) then
    vim.notify("live-server already running", vim.log.levels.INFO)
    return
  end

  local cmd = { "live-server", dir, "--port=" .. PORT }

  local job_id = vim.fn.jobstart(cmd, {
    on_stderr = function(_, data)
      if not data or data[1] == "" then
        return
      end
      local msg = data[1]:match(".-m(.-)\27") or data[1]
      vim.notify(msg, vim.log.levels.ERROR)
    end,

    on_exit = function(_, exit_code)
      job_cache[dir] = nil

      if exit_code ~= 143 then -- ignore SIGTERM
        vim.notify(string.format("stopped with code %s", exit_code), vim.log.levels.INFO)
      end
    end,
  })

  vim.notify(string.format("live-server started on 127.0.0.1:%d", PORT), vim.log.levels.INFO)
  job_cache[dir] = job_id
end

local function stop_live_server(dir)
  if is_running(dir) then
    local cached_dir = find_cached_dir(dir)
    if cached_dir then
      vim.fn.jobstop(job_cache[cached_dir])
      job_cache[cached_dir] = nil
      vim.notify("live-server stopped", vim.log.levels.INFO)
    end
  end
end

local function toggle_live_server(dir)
  if is_running(dir) then
    stop_live_server(dir)
  else
    start_live_server(dir)
  end
end

---------------------------------------------------------
-- Validate live-server availability
---------------------------------------------------------
if not vim.fn.executable("live-server") then
  vim.notify("live-server: not executable. Install with: npm -g install live-server", vim.log.levels.ERROR)
  return
end

---------------------------------------------------------
-- Directory resolver
---------------------------------------------------------
local function find_dir(args)
  local dir = args ~= "" and args or "%:p:h"
  return vim.fn.expand(vim.fn.fnamemodify(vim.fn.expand(dir), ":p"))
end

---------------------------------------------------------
-- Commands
---------------------------------------------------------
-- vim.api.nvim_create_user_command("LiveServerStart", function(opts)
--   start_live_server(find_dir(opts.args))
-- end, { nargs = "?" })

-- vim.api.nvim_create_user_command("LiveServerStop", function(opts)
--   stop_live_server(find_dir(opts.args))
-- end, { nargs = "?" })

-- vim.api.nvim_create_user_command("LiveServerToggle", function(opts)
--   toggle_live_server(find_dir(opts.args))
-- end, { nargs = "?" })

vim.api.nvim_create_user_command("LiveServer", function(opts)
  toggle_live_server(find_dir(opts.args))
end, { nargs = "?" })
