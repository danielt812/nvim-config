local root_dir = vim.fn.getcwd()
local node_modules_dir = vim.fs.find("node_modules", { path = root_dir, upward = true })[1]
local project_root = node_modules_dir and vim.fs.dirname(node_modules_dir) or "?"

local function get_probe_dir()
  return project_root and (project_root .. "/node_modules") or ""
end

local function get_angular_core_version()
  if not project_root then
    return ""
  end

  local package_json = project_root .. "/package.json"
  if not vim.uv.fs_stat(package_json) then
    return ""
  end

  local contents = io.open(package_json):read("*a")
  local json = vim.json.decode(contents)
  if not json.dependencies then
    return ""
  end

  local angular_core_version = json.dependencies["@angular/core"]
  angular_core_version = angular_core_version and angular_core_version:match("%d+%.%d+%.%d+")
  return angular_core_version or ""
end

local default_probe_dir = get_probe_dir()
local default_angular_core_version = get_angular_core_version()

local ngserver_exe = vim.fn.exepath("ngserver")
local ngserver_path = #(ngserver_exe or "") > 0 and vim.fs.dirname(vim.uv.fs_realpath(ngserver_exe)) or "?"
local extension_path = vim.fs.normalize(vim.fs.joinpath(ngserver_path, "../../../"))

-- angularls will get module by `require.resolve(PROBE_PATH, MODULE_NAME)` of nodejs
local ts_probe_dirs = vim.iter({ extension_path, default_probe_dir }):join(",")
local ng_probe_dirs = vim
  .iter({ extension_path, default_probe_dir })
  :map(function(p)
    return vim.fs.joinpath(p, "/@angular/language-server/node_modules")
  end)
  :join(",")

-- ✅ only attach if we are in an Angular or Nx workspace
local ROOT_MARKERS = { "angular.json", "nx.json" }

return {
  cmd = {
    "ngserver",
    "--stdio",
    "--tsProbeLocations",
    ts_probe_dirs,
    "--ngProbeLocations",
    ng_probe_dirs,
    "--angularCoreVersion",
    default_angular_core_version,
  },
  filetypes = { "typescript", "html", "htmlangular" }, -- removed react filetypes
  root_markers = ROOT_MARKERS,
  root_dir = function(bufnr, on_dir)
    local filename = vim.api.nvim_buf_get_name(bufnr)
    local match = vim.fs.find(ROOT_MARKERS, { path = filename, upward = true })[1]
    if match then
      on_dir(vim.fs.dirname(match))
    end
  end,
}
