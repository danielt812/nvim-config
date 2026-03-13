---@brief
---
--- https://github.com/docker/docker-language-server
---
--- `docker-langserver-server` can be installed via `go`:
--- ```sh
--- go install github.com/docker/docker-language-server/cmd/docker-language-server@latest
--- ```

---@type vim.lsp.Config
return {
  cmd = { "docker-language-server", "start", "--stdio" },
  filetypes = { "dockerfile", "yaml" },
  get_language_id = function(_, ft)
    if ft == "yaml.docker-compose" or ft:lower():find("ya?ml") then
      return "dockercompose"
    else
      return ft
    end
  end,
  root_dir = function(bufnr, cb)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local root = vim.fs.root(fname, {
      "Dockerfile",
      "docker-compose.yaml",
      "docker-compose.yml",
      "compose.yaml",
      "compose.yml",
      "docker-bake.json",
      "docker-bake.hcl",
      "docker-bake.override.json",
      "docker-bake.override.hcl",
    })
    if root then cb(root) end
  end,
}
