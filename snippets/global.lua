local author = vim.fn.executable("git") == 1 and vim.fn.system("git config user.name"):gsub("%s+$", "")
  or vim.uv.os_get_passwd().username

local function special_comments(context)
  local cs_left, cs_right = vim.bo[context.buf_id].commentstring:match("^(.*)%%s(.*)$")
  -- stylua: ignore
  if cs_left == nil then return {} end

  cs_left = cs_left:find("%s$") and cs_left or (cs_left .. " ")
  cs_right = cs_left:find("^%s") and cs_right or (" " .. cs_right)

  local function wrap(s)
    if s:match("^%s*$") then
      return (cs_left:gsub("%s*$", "") .. cs_right:gsub("^%s*", ""))
    end
    return (string.format("%s%s%s", cs_left, s, cs_right):gsub("%s$", ""))
  end

  --stylua: ignore
  return {
    {
      { prefix = "fixme", body = wrap("FIXME: ${0:describe the bug or needed fix}"),  desc = "Create a fixme comment" },
      { prefix = "hack",  body = wrap("HACK: ${0:temporary workaround or solution}"), desc = "Create a hack comment" },
      { prefix = "info",  body = wrap("INFO: ${0:relevant context or metadata}"),     desc = "Create a info comment" },
      { prefix = "note",  body = wrap("NOTE: ${0:important detail}"),                 desc = "Create a note comment" },
      { prefix = "todo",  body = wrap("TODO: ${0:describe the task or goal}"),        desc = "Create a todo comment" },
      { prefix = "warn",  body = wrap("WARN: ${0:potential risk or edge case}"),      desc = "Create a warn comment" },
      {
        prefix = "header",
        body = {
          wrap("================================================"),
          wrap(" " .. vim.fn.expand('%:t')),
          wrap(""),
          wrap("Description: ${0:What this file does}"),
          wrap("Author: " .. author),
          wrap("================================================"),
        },
        desc = "Create a file header",
      },
    },
  }
end

return { special_comments }
