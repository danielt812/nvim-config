return {
  {
    cmd = "ar(gs) <glob>",
    desc = "load files into arglist",
    example = ":args * | :argdo %s/old/new/ge | update",
  },
  {
    cmd = "argdo <cmd>",
    desc = "run cmd on each file in arglist",
    example = ":argdo normal @q",
  },
  {
    cmd = "ea(rlier) <time>",
    desc = "undo all changes from time period",
    example = ":earlier 1m / :later 1m",
  },
  {
    cmd = "cdo <cmd>",
    desc = "run cmd on each quickfix entry",
    example = ":cdo s/foo/bar/g",
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
    cmd = "sor(t) u",
    desc = "sort and deduplicate lines",
    example = ":sort u / :sort! / :sort n",
  },
  {
    cmd = "tab sp(lit)",
    desc = "open current buffer in a new tab",
    example = ":tab split",
  },
  {
    cmd = "r(ead) !<cmd>",
    desc = "insert shell output below cursor",
    example = ":r !ls -la",
  },
  {
    cmd = "se(t) spell",
    desc = "enable spellcheck",
    example = ":set spell / :set nospell",
  },
  {
    cmd = "%s/\\v(<a>|<b>)/<c>/g",
    desc = "very magic regex for alternation",
    example = ":%s/\\v(foo|bar)/baz/g",
  },
  {
    cmd = "cfdo <cmd> | up(date)",
    desc = "run cmd across quickfix files and save",
    example = ":cfdo %s/foo/bar/g | update",
  },
  {
    cmd = "windo diffthis",
    desc = "diff all visible windows",
    example = ":windo diffthis / :diffoff!",
  },
  {
    cmd = "pa(ckadd) <plugin>",
    desc = "load an optional plugin on demand",
    example = ":packadd cfilter",
  },
  {
    cmd = "verb(ose) map <key>",
    desc = "find where a mapping was defined",
    example = ":verbose nmap <leader>f",
  },
  {
    cmd = "filt(er) /<pattern>/ ls",
    desc = "filter buffer list by pattern",
    example = ":filter /lua/ ls",
  },
  {
    cmd = "pu(t) =range(<start>,<end>)",
    desc = "insert a sequence of numbers",
    example = ":put =range(1,10)",
  },
  {
    cmd = "norm(al) <cmd>",
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
    example = ":marks a / :delmarks a-z",
  },
  {
    cmd = "undof(ile)",
    desc = "show persistent undo file path",
    example = ":echo undofile(expand('%'))",
  },
  {
    cmd = "mes(sages)",
    desc = "show recent echo/error messages",
    example = ":messages",
  },
  {
    cmd = "scr(iptnames)",
    desc = "list all sourced scripts in load order",
    example = ":scriptnames",
  },
  {
    cmd = "hi(ghlight) <group>",
    desc = "show highlight group definition",
    example = ":highlight Comment",
  },
  {
    cmd = "sy(ntax) list",
    desc = "show syntax items for current buffer",
    example = ":syntax list",
  },
  {
    cmd = "che(ckhealth) <module>",
    desc = "run diagnostic checks",
    example = ":checkhealth vim.lsp",
  },
  {
    cmd = "lua =<expr>",
    desc = "inspect any lua expression",
    example = ":lua =vim.bo.filetype",
  },
  {
    cmd = "prof(ile) start <path>",
    desc = "profile all functions",
    example = ":profile start /tmp/prof.log | profile func *",
  },
  {
    cmd = "ret(ab)",
    desc = "convert tabs/spaces",
    example = ":retab",
  },
  {
    cmd = "keepp(attern) /<pattern>",
    desc = "search without polluting search history",
    example = ":keeppattern /foo",
  },
  {
    cmd = "g/<pattern>/norm(al) <cmd>",
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
    cmd = "sav(eas) <path>",
    desc = "save current buffer to a new file",
    example = ":saveas backup.lua",
  },
  {
    cmd = "f(ile) <name>",
    desc = "rename current buffer without writing",
    example = ":file renamed.lua",
  },
  {
    cmd = "r(ead) !<cmd>",
    desc = "insert command output below cursor",
    example = ":read !date",
  },
  {
    cmd = "0r(ead) <file>",
    desc = "insert file contents at top of buffer",
    example = ":0read header.txt",
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
    cmd = "mks(ession)",
    desc = "save session",
    example = ":mksession / :source Session.vim",
  },
  {
    cmd = "mkvie(w)",
    desc = "save fold/cursor state",
    example = ":mkview / :loadview",
  },
  {
    cmd = "on(ly)",
    desc = "close all windows except current",
    example = ":only",
  },
  {
    cmd = "tabo(nly)",
    desc = "close all tabs except current",
    example = ":tabonly",
  },
  {
    cmd = "ba(ll)",
    desc = "open all buffers in splits",
    example = ":ball / :tab ball",
  },
  {
    cmd = "vert(ical) sb(uffer) <n>",
    desc = "open buffer n in a vertical split",
    example = ":vertical sbuffer 3",
  },
  {
    cmd = "to(pleft) vnew",
    desc = "open new buffer in leftmost split",
    example = ":topleft vnew",
  },
  {
    cmd = "rightb(elow) sp(lit)",
    desc = "open split below current window",
    example = ":rightbelow split",
  },
  {
    cmd = "res(ize) <n>",
    desc = "set window height",
    example = ":resize +5 / :vertical resize +10",
  },
  {
    cmd = "winc(md) =",
    desc = "equalize all window sizes",
    example = ":wincmd =",
  },
  {
    cmd = "se(t) scrollbind",
    desc = "sync scrolling between windows",
    example = ":set scrollbind / :set noscrollbind",
  },
  {
    cmd = "diffg(et)",
    desc = "pull changes from other diff window",
    example = ":diffget / :diffput",
  },
  {
    cmd = "diffu(pdate)",
    desc = "refresh diff highlighting after edits",
    example = ":diffupdate",
  },
  {
    cmd = "ju(mps)",
    desc = "list the jump stack",
    example = ":jumps",
  },
  {
    cmd = "reg(isters)",
    desc = "show contents of all registers",
    example = ":registers",
  },
  {
    cmd = "ol(dfiles)",
    desc = "list recently opened files",
    example = ":oldfiles / :browse oldfiles",
  },
  {
    cmd = "se(t) list",
    desc = "show whitespace characters",
    example = ":set list / :set nolist",
  },
  {
    cmd = "se(t) colorcolumn=<n>",
    desc = "show a vertical ruler",
    example = ":set colorcolumn=80,120",
  },
  {
    cmd = "mat(ch) <group> /<pattern>/",
    desc = "highlight pattern with group",
    example = ":match ErrorMsg /\\s\\+$/",
  },
  {
    cmd = "%s/\\s\\+$//e",
    desc = "strip trailing whitespace",
    example = ":%s/\\s\\+$//e",
  },
  {
    cmd = "%s/\\n\\{3,}/\\r\\r/e",
    desc = "collapse 3+ blank lines into 2",
    example = ":%s/\\n\\{3,}/\\r\\r/e",
  },
  {
    cmd = "g/^$/d",
    desc = "delete all blank lines",
    example = ":g/^$/d / :g/^\\s*$/d",
  },
  {
    cmd = "sor(t) /<pattern>/",
    desc = "sort by text matching pattern",
    example = ":sort /.*\\%2v/",
  },
  {
    cmd = "sor(t) n",
    desc = "sort numerically",
    example = ":sort n / :sort /\\d\\+/ r",
  },
  {
    cmd = "%norm(al) <cmd>",
    desc = "run normal cmd on every line",
    example = ":%normal >>",
  },
  {
    cmd = "'<,'>!<cmd>",
    desc = "filter selection through shell",
    example = ":'<,'>!tac / :'<,'>!sort / :'<,'>!uniq",
  },
  {
    cmd = "e ++enc=<encoding>",
    desc = "reopen file with specific encoding",
    example = ":e ++enc=latin1",
  },
  {
    cmd = "e ++ff=<format>",
    desc = "reopen file with line ending format",
    example = ":e ++ff=unix / :e ++ff=dos",
  },
  {
    cmd = "se(t) fileformat=<fmt>",
    desc = "convert line endings",
    example = ":set fileformat=unix",
  },
  {
    cmd = "e!",
    desc = "revert buffer to last saved state",
    example = ":e!",
  },
  {
    cmd = "rec(over)",
    desc = "recover from a swap file",
    example = ":recover",
  },
  {
    cmd = "se(t) undofile",
    desc = "enable persistent undo across sessions",
    example = ":set undofile",
  },
  {
    cmd = "wsh(ada)",
    desc = "write shared data",
    example = ":wshada / :rshada",
  },
  {
    cmd = "lua =vim.lsp.get_clients()",
    desc = "list active LSP clients",
    example = ":lua =vim.lsp.get_clients()",
  },
  {
    cmd = "che(ckhealth) vim.lsp",
    desc = "show LSP client status",
    example = ":checkhealth vim.lsp",
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
    cmd = "cope(n)",
    desc = "open quickfix window",
    example = ":cope / :ccl",
  },
  {
    cmd = "cn(ext)",
    desc = "next quickfix entry",
    example = ":cnext / :cprev",
  },
  {
    cmd = "col(der)",
    desc = "older quickfix list",
    example = ":colder / :cnewer",
  },
  {
    cmd = "lop(en)",
    desc = "open location list",
    example = ":lopen / :lnext",
  },
  {
    cmd = "vim(grep) /<pattern>/ <glob>",
    desc = "search files into quickfix",
    example = ":vimgrep /foo/ **/*.lua",
  },
  {
    cmd = "comp(iler) <name>",
    desc = "set errorformat for a compiler",
    example = ":compiler gcc / :make",
  },
  {
    cmd = "se(t) makeprg=<cmd>",
    desc = "set what :make runs",
    example = ":set makeprg=npm\\ test",
  },
  {
    cmd = "term(inal) <?bin>",
    desc = "open terminal in current window",
    example = ":terminal lazygit",
  },
  {
    cmd = "h(elp) quickref",
    desc = "the ultimate vim cheat sheet",
    example = ":help quickref",
  },
  {
    cmd = "h(elp) <help-tag>",
    desc = "open help for any topic",
    example = ":help help-tags",
  },
  {
    cmd = "helpg(rep) <pattern>",
    desc = "search across all help files",
    example = ":helpgrep treesitter",
  },
  {
    cmd = "ene(w)",
    desc = "open a new empty buffer",
    example = ":enew | set ft=lua",
  },
  {
    cmd = "uniq",
    desc = "deduplicate text in current buffer",
    example = ":uniq",
  },
  {
    cmd = "ipu(t)",
    desc = "put text from register and adjust indent",
    example = ":iput / :iput a",
  },
}
