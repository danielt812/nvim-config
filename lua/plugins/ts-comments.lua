local M = { "folke/ts-comments.nvim" }

M.enabled = true

M.event = { "BufReadPost" }

M.opts = function()
  return {
    lang = {
      astro = "<!-- %s -->",
      axaml = "<!-- %s -->",
      blueprint = "// %s",
      c = "// %s",
      c_sharp = "// %s",
      clojure = { ";; %s", "; %s" },
      cpp = "// %s",
      cs_project = "<!-- %s -->",
      cue = "// %s",
      fsharp = "// %s",
      fsharp_project = "<!-- %s -->",
      gleam = "// %s",
      glimmer = "{{! %s }}",
      graphql = "# %s",
      handlebars = "{{! %s }}",
      hcl = "# %s",
      html = "<!-- %s -->",
      hyprlang = "# %s",
      ini = "; %s",
      ipynb = "# %s",
      javascript = {
        "// %s", -- default commentstring when no treesitter node matches
        "/* %s */",
        call_expression = "// %s", -- specific commentstring for call_expression
        jsx_attribute = "// %s",
        jsx_element = "{/* %s */}",
        jsx_fragment = "{/* %s */}",
        spread_element = "// %s",
        statement_block = "// %s",
      },
      kdl = "// %s",
      php = "// %s",
      rego = "# %s",
      rescript = "// %s",
      rust = { "// %s", "/* %s */" },
      sql = "-- %s",
      styled = "/* %s */",
      svelte = "<!-- %s -->",
      templ = {
        "// %s",
        component_block = "<!-- %s -->",
      },
      terraform = "# %s",
      tsx = {
        "// %s", -- default commentstring when no treesitter node matches
        "/* %s */",
        call_expression = "// %s", -- specific commentstring for call_expression
        jsx_attribute = "// %s",
        jsx_element = "{/* %s */}",
        jsx_fragment = "{/* %s */}",
        spread_element = "// %s",
        statement_block = "// %s",
      },
      twig = "{# %s #}",
      typescript = { "// %s", "/* %s */" }, -- langs can have multiple commentstrings
      vue = "<!-- %s -->",
      xaml = "<!-- %s -->",
    },
  }
end

M.config = function(_, opts)
  require("ts-comments").setup(opts)
end

return M
