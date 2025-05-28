local commentstring = vim.bo.commentstring:gsub("%%s", ""):gsub("%s*$", "")
return {
  {
    -- stylua: ignore start
    { prefix = "fixme", body = commentstring .. " FIXME - ${1:describe the bug or needed fix}",   desc = "Create a fix comment" },
    { prefix = "hack",  body = commentstring .. " HACK - ${1:temporary workaround  or solution}", desc = "Create a hack comment" },
    { prefix = "info",  body = commentstring .. " INFO - ${1:relevant context or metadata}",      desc = "Create a info comment" },
    { prefix = "link",  body = commentstring .. " LINK - ${1:href to issue or documentation}",    desc = "Create a link to external resource" },
    { prefix = "note",  body = commentstring .. " NOTE - ${1:important detail or clarification}", desc = "Create a note comment" },
    { prefix = "todo",  body = commentstring .. " TODO - ${1:describe the task or goal}",         desc = "Create a todo comment" },
    { prefix = "warn",  body = commentstring .. " WARN - ${1:potential risk or edge case}",       desc = "Create a warn comment" },
    -- stylua: ignore end
  },
}
