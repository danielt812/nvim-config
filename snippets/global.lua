return {
  function()
    local cs = vim.bo.commentstring:gsub("%%s", ""):gsub("%s*$", "")

    local filename = vim.fn.expand("%:t")

    local function is_git_repo()
      return vim.fn.system("git rev-parse --is-inside-work-tree 2>/dev/null"):match("true") ~= nil
    end

    local function git_author_or_placeholder()
      if not is_git_repo() then
        return "${2:Author}"
      end

      local author = vim.fn.system("git config user.name"):gsub("%s+$", "")
      if author == "" then
        return "${2:Author}"
      end

      return author
    end

    local author = git_author_or_placeholder()

    return {
      {
        -- stylua: ignore start
        { prefix = "fixme", body = cs .. " FIXME  ${1:describe the bug or needed fix}",  desc = "Create a fixme comment" },
        { prefix = "hack",  body = cs .. " HACK  ${1:temporary workaround or solution}", desc = "Create a hack comment" },
        { prefix = "info",  body = cs .. " INFO  ${1:relevant context or metadata}",     desc = "Create a info comment" },
        { prefix = "note",  body = cs .. " NOTE  ${1:important detail}",                 desc = "Create a note comment" },
        { prefix = "todo",  body = cs .. " TODO  ${1:describe the task or goal}",        desc = "Create a todo comment" },
        { prefix = "warn",  body = cs .. " WARN  ${1:potential risk or edge case}",      desc = "Create a warn comment" },
        {
          prefix = "box",
          body = {
            cs .. " ┌──────────────────────────────────────┐",
            cs .. " │ ${1:TITLE} │",
            cs .. " └──────────────────────────────────────┘",
          },
          desc = "Create a boxed comment",
        },
        {
          prefix = "section",
          body = cs
            .. " ── ${1:Section name} ─────────────────────────────",
          desc = "Create a section divider",
        },
        {
          prefix = "header",
          body = {
            cs .. " ================================================",
            cs .. " " .. filename,
            cs .. "",
            cs .. " Description: ${1:What this file does}",
            cs .. " Author: " .. author,
            cs .. " ================================================",
          },
          desc = "Create a file header",
        },
        -- stylua: ignore end
      },
    }
  end,
}
