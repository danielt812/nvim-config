return {
  {
    cmd = "args <glob>",
    desc = "load files into arglist",
    example = ":args `fd -t f` or :args `find . -type f`",
  },
  {
    cmd = "argdo <cmd>",
    desc = "run cmd on each file in arglist",
    example = ":argdo retab | write",
  },
  {
    cmd = "earlier <time>",
    desc = "undo all changes from time period",
    example = ":earlier 1m or :later 1m",
  },
  {
    cmd = "cdo <cmd>",
    desc = "run cmd on each quickfix entry",
    example = ":cdo s/foo/bar/g or :cdo g/foo/d",
  },
  {
    cmd = "cfdo <cmd> | up(date)",
    desc = "run cmd across quickfix files",
    example = ":cfdo %s/foo/bar/g | write",
  },
  {
    cmd = "g/<pattern>/d",
    desc = "delete all lines matching pattern",
    example = ":g/foobar/d",
  },
  {
    cmd = "v/<pattern>/d",
    desc = "keep only lines matching pattern",
    example = ":v/foo/d",
  },
  {
    cmd = "sort u",
    desc = "sort and deduplicate lines",
    example = ":sort u or :sort! or :sort n",
  },
  {
    cmd = "tab split",
    desc = "open current buffer in a new tab",
    example = ":tab split",
  },
  {
    cmd = "read !<cmd>",
    desc = "insert shell output below cursor",
    example = ":r !ls -la",
  },
  {
    cmd = "windo diffthis",
    desc = "diff all visible windows",
    example = ":windo diffthis or :diffoff!",
  },
  {
    cmd = "verbose map <key>",
    desc = "find where a mapping was defined",
    example = ":verbose nmap <leader>f",
  },
  {
    cmd = "filter /<pattern>/ ls",
    desc = "filter buffer list by pattern",
    example = ":filter /lua/ ls",
  },
  {
    cmd = "put =range(<start>,<end>)",
    desc = "insert a sequence of numbers",
    example = ":put =range(1,10)",
  },
  {
    cmd = "normal <cmd>",
    desc = "run normal cmd on selected lines",
    example = ":'<,'>norm @q",
  },
  {
    cmd = "changes",
    desc = "show the changelist for current buffer",
    example = ":changes",
  },
  {
    cmd = "marks <?mark>",
    desc = "list all marks",
    example = ":marks a",
  },
  {
    cmd = "undofile",
    desc = "show persistent undo file path",
    example = ":echo undofile(expand('%'))",
  },
  {
    cmd = "messages",
    desc = "show recent echo/error messages",
    example = ":messages",
  },
  {
    cmd = "scriptnames",
    desc = "list all sourced scripts in load order",
    example = ":scriptnames",
  },
  {
    cmd = "highlight <group>",
    desc = "show highlight group definition",
    example = ":highlight Comment",
  },
  {
    cmd = "syntax list",
    desc = "show syntax items for current buffer",
    example = ":syntax list",
  },
  {
    cmd = "checkhealth <module>",
    desc = "run diagnostic checks",
    example = ":checkhealth vim.lsp",
  },
  {
    cmd = "lua =<expr>",
    desc = "inspect any lua expression",
    example = ":lua =vim.bo.filetype",
  },
  {
    cmd = "profile start <path>",
    desc = "profile all functions",
    example = ":profile start /tmp/prof.log | profile func *",
  },
  {
    cmd = "retab",
    desc = "convert tabs to spaces",
    example = ":retab",
  },
  {
    cmd = "keeppattern /<pattern>",
    desc = "search without polluting search history",
    example = ":keeppattern /foo",
  },
  {
    cmd = "g/<pattern>/normal <cmd>",
    desc = "run normal cmd on all matching lines",
    example = ":g/return/normal A;",
  },
  {
    cmd = "%!<cmd>",
    desc = "filter buffer through shell command",
    example = ":%!jq . / :%!sort / :%!column -t",
  },
  {
    cmd = "w !diff % -",
    desc = "diff unsaved changes against disk",
    example = ":w !diff % -",
  },
  {
    cmd = "w !sudo tee %",
    desc = "save a file opened without sudo",
    example = ":w !sudo tee %",
  },
  {
    cmd = "saveas <path>",
    desc = "save current buffer to a new file",
    example = ":saveas backup.lua",
  },
  {
    cmd = "file <name>",
    desc = "rename current buffer without writing",
    example = ":file renamed.lua",
  },
  {
    cmd = "read !<cmd>",
    desc = "insert command output below cursor",
    example = ":read !date",
  },
  {
    cmd = ".!sh",
    desc = "execute current line as shell cmd",
    example = ":.!sh",
  },
  {
    cmd = "let @a='' | g/<pattern>/y A",
    desc = "yank all matching lines into register",
    example = ":let @a='' | g/foo/y A",
  },
  {
    cmd = "bufdo <cmd> | up(date)",
    desc = "run cmd across all buffers and save",
    example = ":bufdo %s/foo/bar/ge | update",
  },
  {
    cmd = "windo <cmd>",
    desc = "run cmd in all visible windows",
    example = ":windo set number",
  },
  {
    cmd = "tabdo windo <cmd>",
    desc = "run cmd in all tabs and windows",
    example = ":tabdo windo set cursorline",
  },
  {
    cmd = "mksession",
    desc = "save session",
    example = ":mksession / :source Session.vim",
  },
  {
    cmd = "mkview",
    desc = "save fold/cursor state",
    example = ":mkview / :loadview",
  },
  {
    cmd = "only",
    desc = "close all windows except current",
    example = ":only",
  },
  {
    cmd = "tabonly",
    desc = "close all tabs except current",
    example = ":tabonly",
  },
  {
    cmd = "ball",
    desc = "open all buffers in splits",
    example = ":ball / :tab ball",
  },
  {
    cmd = "vertical sbuffer <n>",
    desc = "open buffer n in a vertical split",
    example = ":vertical sbuffer 3",
  },
  {
    cmd = "topleft vnew",
    desc = "open new buffer in leftmost split",
    example = ":topleft vnew",
  },
  {
    cmd = "rightbelow split",
    desc = "open split below current window",
    example = ":rightbelow split",
  },
  {
    cmd = "resize <n>",
    desc = "set window height",
    example = ":resize +5 / :vertical resize +10",
  },
  {
    cmd = "wincmd =",
    desc = "equalize all window sizes",
    example = ":wincmd =",
  },
  {
    cmd = "set scrollbind",
    desc = "sync scrolling between windows",
    example = ":set scrollbind / :set noscrollbind",
  },
  {
    cmd = "diffget",
    desc = "pull changes from other diff window",
    example = ":diffget / :diffput",
  },
  {
    cmd = "diffupdate",
    desc = "refresh diff highlighting after edits",
    example = ":diffupdate",
  },
  {
    cmd = "jumps",
    desc = "list the jump stack",
    example = ":jumps",
  },
  {
    cmd = "registers",
    desc = "show contents of all registers",
    example = ":registers",
  },
  {
    cmd = "oldfiles",
    desc = "list recently opened files",
    example = ":oldfiles / :browse oldfiles",
  },
  {
    cmd = "set list",
    desc = "show whitespace characters",
    example = ":set list / :set nolist",
  },
  {
    cmd = "set colorcolumn=<n>",
    desc = "show a vertical ruler",
    example = ":set colorcolumn=80,120",
  },
  {
    cmd = "match <group> /<pattern>/",
    desc = "highlight pattern with group",
    example = ":match ErrorMsg /\\s\\+$/",
  },
  {
    cmd = "sort /<pattern>/",
    desc = "sort by text matching pattern",
    example = ":sort /.*\\%2v/",
  },
  {
    cmd = "sort n",
    desc = "sort numerically",
    example = ":sort n / :sort /\\d\\+/ r",
  },
  {
    cmd = "%normal <cmd>",
    desc = "run normal cmd on every line",
    example = ":%normal >>",
  },
  {
    cmd = "'<,'>!<cmd>",
    desc = "filter selection through shell",
    example = ":'<,'>!tac / :'<,'>!sort / :'<,'>!uniq",
  },
  {
    cmd = "set fileformat=<fmt>",
    desc = "convert line endings",
    example = ":set fileformat=unix",
  },
  {
    cmd = "e!",
    desc = "revert buffer to last saved state",
    example = ":e!",
  },
  {
    cmd = "recover",
    desc = "recover from a swap file",
    example = ":recover",
  },
  {
    cmd = "set undofile",
    desc = "enable persistent undo across sessions",
    example = ":set undofile",
  },
  {
    cmd = "wshada",
    desc = "write shared data",
    example = ":wshada / :rshada",
  },
  {
    cmd = "lua =vim.lsp.get_clients()",
    desc = "list active LSP clients",
    example = ":lua =vim.lsp.get_clients()",
  },
  {
    cmd = "lua vim.lsp.buf.format()",
    desc = "format with LSP",
    example = ":lua vim.lsp.buf.format({ async = true })",
  },
  {
    cmd = "lua vim.diagnostic.setqflist()",
    desc = "send all diagnostics to quickfix",
    example = ":lua vim.diagnostic.setqflist()",
  },
  {
    cmd = "copen",
    desc = "open quickfix window",
    example = ":cope / :ccl",
  },
  {
    cmd = "cnext",
    desc = "next quickfix entry",
    example = ":cnext / :cprev",
  },
  {
    cmd = "colder",
    desc = "older quickfix list",
    example = ":colder / :cnewer",
  },
  {
    cmd = "lopen",
    desc = "open location list",
    example = ":lopen / :lnext",
  },
  {
    cmd = "vimgrep /<pattern>/ <glob>",
    desc = "search files into quickfix",
    example = ":vimgrep /foo/ **/*.lua",
  },
  {
    cmd = "compiler <name>",
    desc = "set errorformat for a compiler",
    example = ":compiler gcc / :make",
  },
  {
    cmd = "set makeprg=<cmd>",
    desc = "set what :make runs",
    example = ":set makeprg=npm\\ test",
  },
  {
    cmd = "terminal <?bin>",
    desc = "open terminal in current window",
    example = ":terminal lazygit",
  },
  {
    cmd = "help quickref",
    desc = "the ultimate vim cheat sheet",
    example = ":help quickref",
  },
  {
    cmd = "help <help-tag>",
    desc = "open help for any topic",
    example = ":help help-tags",
  },
  {
    cmd = "helpgrep <pattern>",
    desc = "search across all help files",
    example = ":helpgrep treesitter",
  },
  {
    cmd = "enew",
    desc = "open a new empty buffer",
    example = ":enew | set ft=lua",
  },
  {
    cmd = "uniq",
    desc = "deduplicate text in current buffer",
    example = ":uniq",
  },
  {
    cmd = "iput",
    desc = "put text from register and adjust indent",
    example = ":iput / :iput a",
  },
}
