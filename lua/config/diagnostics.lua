local colors = require("mini.colors")

local signs = { E = "", W = "", I = "", H = "" }

vim.diagnostic.config({
  -- signs = false,
  signs = {
    priority = 2,
    severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.ERROR },
    text = {
      [vim.diagnostic.severity.ERROR] = signs.E,
      [vim.diagnostic.severity.WARN]  = signs.W,
      [vim.diagnostic.severity.INFO]  = signs.I,
      [vim.diagnostic.severity.HINT]  = signs.H,
    },
  },
  virtual_text = false,
})

-- #############################################################################
-- #                                  Keymaps                                  #
-- #############################################################################

vim.keymap.set("n", "g?", function()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local diags = vim.diagnostic.get(0, { lnum = row })
  if #diags == 0 then return end
  local msg = table.concat(vim.tbl_map(function(d) return d.message end, diags), "\n")
  vim.fn.setreg("+", msg)
  vim.notify("Yanked: " .. msg)
end, { desc = "Yank diagnostic" })

-- #############################################################################
-- #                            Virtual Diagnostics                            #
-- #############################################################################

do
  local ns = vim.api.nvim_create_namespace("virtual_diagnostics")
  local group = vim.api.nvim_create_augroup("virtual_diagnostics", { clear = true })

  local state = {
    enabled = true,
    cache = {},
    attached = {},
    last_cursor = {},
    uid_counter = 1,
  }

  local function generate_uid()
    state.uid_counter = (state.uid_counter % (2 ^ 32 - 1)) + 1
    return state.uid_counter
  end

  local function cache_update(buf, diagnostics)
    if not diagnostics or #diagnostics == 0 then
      state.cache[buf] = {}
      return
    end
    local sorted = vim.deepcopy(diagnostics)
    table.sort(
      sorted,
      function(a, b)
        return a.severity < b.severity
          or (a.severity == b.severity and a._extmark_id and b._extmark_id and a._extmark_id > b._extmark_id)
      end
    )
    state.cache[buf] = sorted
  end

  local function blend(foreground, background, alpha)
    local fg = colors.convert(foreground, "oklab") or { l = 0, a = 0, b = 0 }
    local bg = colors.convert(background, "oklab") or { l = 0, a = 0, b = 0 }
    local t = math.max(0, math.min(1, alpha or 0))
    local mixed = { l = t * fg.l + (1 - t) * bg.l, a = t * fg.a + (1 - t) * bg.a, b = t * fg.b + (1 - t) * bg.b }
    return colors.convert(mixed, "hex")
  end

  local function int_to_hex(int)
    if not int then return "None" end
    return colors.convert(string.format("#%06x", int), "hex") or "None"
  end

  local function split_lines(s)
    if type(s) ~= "string" then return {} end
    local lines = {}
    for line in s:gmatch("([^\n\r]*)\r?\n?") do
      if line ~= "" then lines[#lines + 1] = line end
    end
    return lines
  end

  local function wrap_text(text, max_length, trim_whitespaces, tabstop)
    if not text then return {} end
    if max_length <= 0 then return split_lines(text) end
    text = text:gsub("\t", string.rep(" ", tabstop))

    local lines = {}
    for _, split_line in ipairs(split_lines(text)) do
      if split_line:match("^%s*$") then
        lines[#lines + 1] = split_line
      else
        local current_line = ""
        local beginning_ws = trim_whitespaces and "" or split_line:match("^%s*") or ""
        local words = {}
        local start_pos = 1
        for word in split_line:gmatch("%S+") do
          local ws, we = split_line:find(word, start_pos, true)
          words[#words + 1] = { text = word, leading_space = split_line:sub(start_pos, ws - 1) }
          start_pos = we + 1
        end
        local first_word = true
        for _, wi in ipairs(words) do
          local sp = first_word and beginning_ws or (trim_whitespaces and " " or wi.leading_space)
          local potential = current_line .. sp .. wi.text
          if #potential <= max_length then
            current_line = potential
            first_word = false
          else
            if current_line ~= "" then lines[#lines + 1] = current_line end
            current_line = (trim_whitespaces and "" or beginning_ws) .. wi.text
            first_word = false
          end
        end
        if current_line ~= "" then lines[#lines + 1] = current_line end
      end
    end
    return lines
  end

  local severity_names = { "Error", "Warn", "Info", "Hint" }

  local hl_prefix = "InlineDiagnosticVirtualText"
  local inv_prefix = "InlineInvDiagnosticVirtualText"

  local function get_hl(name)
    local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
    return { fg = int_to_hex(hl.fg), bg = int_to_hex(hl.bg), italic = hl.italic or false }
  end

  local function get_mixing_color(color)
    if color == "None" then return vim.o.background == "light" and "#ffffff" or "#000000" end
    if color:sub(1, 1) == "#" then return color end
    local resolved = get_hl(color).bg
    if resolved == "None" then return vim.o.background == "light" and "#ffffff" or "#000000" end
    return resolved
  end

  local function setup_highlights()
    local cl_hl = get_hl("CursorLine")
    local cl_color = (cl_hl.bg ~= "None") and cl_hl or { bg = "None" }

    local color = {
      error = get_hl("DiagnosticError"),
      warn = get_hl("DiagnosticWarn"),
      info = get_hl("DiagnosticInfo"),
      hint = get_hl("DiagnosticHint"),
      arrow = get_hl("NonText"),
      cursor_line = cl_color,
      background = get_hl("CursorLine").bg,
      mixing_color = get_mixing_color("Normal"),
    }

    local blends = {
      error = blend(color.error.fg, color.mixing_color, 0.25),
      warn = blend(color.warn.fg, color.mixing_color, 0.25),
      info = blend(color.info.fg, color.mixing_color, 0.25),
      hint = blend(color.hint.fg, color.mixing_color, 0.25),
      background = color.background,
    }

    -- Build base highlight groups
    local hi = { [hl_prefix .. "Bg"] = { bg = color.background } }

    for _, name in pairs(severity_names) do
      local nl = name:lower()
      local c = color[nl]

      hi[hl_prefix .. name .. "CursorLine"] = { bg = color.cursor_line.bg, fg = c.fg, italic = c.italic }
      hi[hl_prefix .. name] = { bg = blends[nl], fg = c.fg, italic = c.italic }
      hi[hl_prefix .. name .. "NoBg"] = { fg = c.fg, bg = "None", italic = c.italic }
      hi[inv_prefix .. name] = { fg = blends[nl], bg = color.background, italic = c.italic }
      hi[inv_prefix .. name .. "CursorLine"] = { fg = blends[nl], bg = color.cursor_line.bg, italic = c.italic }
      hi[inv_prefix .. name .. "NoBg"] = { fg = blends[nl], bg = "None", italic = c.italic }
    end

    hi[hl_prefix .. "Arrow"] = { bg = color.background, fg = color.arrow.fg }
    hi[hl_prefix .. "ArrowNoBg"] = { bg = "None", fg = color.arrow.fg }

    -- Build mixed groups
    local group_names = {}
    for _, name in ipairs(severity_names) do
      group_names[#group_names + 1] = hl_prefix .. name
    end
    for _, primary in ipairs(group_names) do
      for _, secondary in ipairs(group_names) do
        local mixed_name = primary .. "Mix" .. secondary:match("Text(%w+)$")
        hi[mixed_name] = { fg = hi[primary].fg, bg = hi[secondary].bg, italic = hi[primary].italic }
      end
    end

    for name, h in pairs(hi) do
      vim.api.nvim_set_hl(0, name, h)
    end
  end

  local function get_diag_highlights(diag_ret, curline, index_diag)
    local sev_name = severity_names[diag_ret.severity] or severity_names[1]
    local diag_hi = hl_prefix .. sev_name
    local diag_inv_hi = inv_prefix .. sev_name
    local body_hi = inv_prefix .. sev_name .. "NoBg"

    if (diag_ret.line and diag_ret.line ~= curline) or index_diag > 1 or diag_ret.need_to_be_under then
      diag_inv_hi = diag_inv_hi .. "NoBg"
    end

    return diag_hi, diag_inv_hi, body_hi
  end

  local function get_mixed_highlights(sev_a, sev_b)
    local ha = severity_names[sev_a] or severity_names[1]
    local hb = severity_names[sev_b] or severity_names[1]
    return hl_prefix .. hb .. "Mix" .. ha, inv_prefix .. ha .. "Mix" .. hb
  end

  local function get_diag_icon(severity)
    local key = vim.diagnostic.severity[severity]:sub(1, 1)
    return signs[key] or key
  end

  local function create_related_diag(info, parent)
    return {
      message = info.message,
      severity = parent.severity,
      lnum = parent.lnum,
      col = parent.col,
      end_lnum = parent.end_lnum,
      end_col = parent.end_col,
      source = parent.source,
      is_related = true,
      related_location = info.location,
    }
  end

  local function add_related(diagnostics)
    local result = {}
    for _, diag in ipairs(diagnostics) do
      result[#result + 1] = diag
      if diag.user_data and diag.user_data.lsp and diag.user_data.lsp.relatedInformation then
        local ri = diag.user_data.lsp.relatedInformation
        if #ri > 0 then
          for i, info in ipairs(ri) do
            if i > 3 then break end
            if info.message and info.message ~= "" then result[#result + 1] = create_related_diag(info, diag) end
          end
        end
      end
    end
    return result
  end

  local function filter_under_cursor(buf, diagnostics)
    if
      not vim.api.nvim_buf_is_valid(buf)
      or vim.api.nvim_get_current_buf() ~= buf
      or not diagnostics
      or #diagnostics == 0
    then
      return {}
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    local filtered = vim.tbl_filter(function(d) return d.lnum == pos[1] - 1 end, diagnostics)
    return add_related(filtered)
  end

  local function filter_for_display(buf, diagnostics)
    local uc = filter_under_cursor(buf, diagnostics)
    local seen = {}
    for _, d in ipairs(uc) do
      seen[d] = true
    end
    for _, d in ipairs(diagnostics) do
      if not seen[d] then uc[#uc + 1] = d end
    end
    return uc
  end

  local function filter_visible(diagnostics)
    local first_line = vim.fn.line("w0") - 1
    local last_line = vim.fn.line("w$")
    local visible = {}
    for _, diag in ipairs(diagnostics) do
      if diag.lnum >= first_line and diag.lnum <= last_line then
        visible[diag.lnum] = visible[diag.lnum] or {}
        visible[diag.lnum][#visible[diag.lnum] + 1] = diag
      end
    end
    return visible
  end

  local function get_max_width(chunks)
    local max_w = 0
    for _, c in ipairs(chunks) do
      if type(c) == "string" then
        local ok, w = pcall(vim.fn.strdisplaywidth, c)
        if ok and w > max_w then max_w = w end
      end
    end
    return max_w
  end

  local function add_severity_icons(vt, severities)
    if not severities or #severities == 0 then return end
    local sorted = vim.deepcopy(severities)
    table.sort(sorted)
    local main = sorted[1]

    for i = #sorted, 2, -1 do
      local sev = sorted[i]
      local hl = get_mixed_highlights(main, sev)
      local icon = get_diag_icon(sev)
      vt[#vt + 1] = { icon, hl }
    end
  end

  local function chunk_get_icon(severities, index_diag, total_chunks)
    if total_chunks == 1 then
      local sorted = vim.deepcopy(severities)
      table.sort(sorted)
      return get_diag_icon(sorted[1])
    end
    return get_diag_icon(severities[index_diag])
  end

  local function add_message_text(vt, message, num_chunks, total_chunks, index_diag, diag_hi, diag_inv_hi, is_related)
    local after = " "
    local before = is_related and "" or " "

    if num_chunks == 1 then
      if total_chunks == 1 or index_diag == total_chunks then
        if message ~= "" then message = message .. " " end
        vt[#vt + 1] = { before .. message, diag_hi }
        vt[#vt + 1] = { "", diag_inv_hi }
      else
        vt[#vt + 1] = { before .. message .. after, diag_hi }
      end
    else
      vt[#vt + 1] = { before .. message .. after, diag_hi }
    end
  end

  local function get_header(message, index_diag, chunk_info, diag_hi, diag_inv_hi, total_chunks, severities, is_related)
    local vt = {}
    if index_diag == 1 then vt[#vt + 1] = { "", diag_inv_hi } end
    vt[#vt + 1] = { is_related and "  " or " ", diag_hi }

    if index_diag == 1 and total_chunks == 1 and not is_related then add_severity_icons(vt, severities) end

    local icon = is_related and "↳ " or chunk_get_icon(severities, index_diag, total_chunks)
    vt[#vt + 1] = { icon, diag_hi }

    add_message_text(vt, message, #chunk_info.chunks, total_chunks, index_diag, diag_hi, diag_inv_hi, is_related)
    return vt
  end

  local function get_body(chunk, index_diag, index_chunk, num_chunks, diag_hi, diag_inv_hi, total_chunks, is_related)
    local vert = index_chunk == num_chunks and " └" or " │"
    local vt
    if is_related then
      vt = { { "    " .. chunk, diag_hi }, { " ", diag_hi } }
    else
      vt = { { vert, diag_hi }, { " " .. chunk, diag_hi }, { " ", diag_hi } }
    end
    if index_diag == total_chunks and index_chunk == num_chunks then vt[#vt + 1] = { "", diag_inv_hi } end
    return vt
  end

  local function get_arrow(diag_line, chunk_info)
    local arrow = "   "
    local hi = hl_prefix .. "Arrow"

    if diag_line ~= chunk_info.line or chunk_info.need_to_be_under then hi = hl_prefix .. "ArrowNoBg" end

    if chunk_info.need_to_be_under then return { { "", "None" }, { "    ", hi } } end
    return { arrow, hi }
  end

  local function get_extmark_offset(buf, curline, col)
    local marks = vim.api.nvim_buf_get_extmarks(buf, -1, { curline, col }, { curline, -1 }, {
      details = true,
      overlap = true,
    })
    local offset = 0
    for _, mark in ipairs(marks) do
      local d = mark[4]
      if not d then return end
      if
        (d.virt_text_pos == "eol" or d.virt_text_pos == "win_col")
        and d.virt_text
        and d.virt_text[1]
        and d.virt_text[1][1]
      then
        offset = offset + #d.virt_text[1][1]
      end
    end
    if vim.lsp.inlay_hint.is_enabled({ bufnr = buf }) then
      local line = vim.api.nvim_buf_get_lines(buf, curline, curline + 1, false)[1]
      if line then
        local cc = vim.fn.strchars(line)
        local hints = vim.lsp.inlay_hint.get({
          bufnr = buf,
          range = { start = { line = curline, character = 0 }, ["end"] = { line = curline, character = cc } },
        })
        for _, hint in ipairs(hints) do
          local lbl = hint.inlay_hint.label
          if type(lbl) == "string" then
            offset = offset + #lbl
          elseif type(lbl) == "table" then
            for _, part in ipairs(lbl) do
              if type(part.value) == "string" then offset = offset + #part.value end
            end
          end
        end
      end
    end
    return offset
  end

  local function get_chunks(diags_on_line, diag_index, diag_line, cursor_line, buf)
    local win_width = vim.api.nvim_win_get_width(0)
    local lines = vim.api.nvim_buf_get_lines(buf, diag_line, diag_line + 1, false)
    local line_length = lines[1] and #lines[1] or 0
    local need_to_be_under = false

    local diag = diags_on_line[diag_index]

    local msg = diag.message
    local source_tag = ""
    if diag.is_related then
      if diag.related_location and diag.related_location.uri then
        local fname = vim.fn.fnamemodify(vim.uri_to_fname(diag.related_location.uri), ":t")
        if diag.related_location.range and diag.related_location.range.start then
          source_tag = string.format(" [%s:%d]", fname, diag.related_location.range.start.line + 1)
        else
          source_tag = string.format(" [%s]", fname)
        end
      end
    else
      local client_name
      if diag.namespace then
        local ns_info = vim.diagnostic.get_namespace(diag.namespace)
        if ns_info and ns_info.name then client_name = ns_info.name:match("^vim%.lsp%.(.+)%.[%d]+$") end
      end
      local name = client_name or diag.source
      if name then source_tag = " [" .. name .. "]" end
    end

    local other_offset = get_extmark_offset(buf, diag_line, line_length)

    if cursor_line == diag_line then
      local ok, vc = pcall(vim.fn.virtcol, "$")
      local vlw = ok and (vc - 1) or (lines[1] and vim.fn.strdisplaywidth(lines[1]) or 0) + other_offset
      if vlw > win_width - 40 then need_to_be_under = true end
    end

    local chunks
    if cursor_line == diag_line then
      chunks = wrap_text(msg, 40, false, 2)
    else
      chunks = { " " .. msg }
    end

    return {
      chunks = chunks,
      source_tag = source_tag,
      severity = diag.severity,
      severities = vim.tbl_map(function(d) return d.severity end, diags_on_line),
      offset = 0,
      offset_win_col = other_offset,
      need_to_be_under = need_to_be_under,
      line = diag.lnum,
      is_related = diag.is_related or false,
    }
  end

  local function vt_from_diagnostic(ret, index_diag, padding, total_chunks)
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    local diag_hi, diag_inv_hi, body_hi = get_diag_highlights(ret, cursor_line, index_diag)

    local all_vt = {}

    for idx, chunk in ipairs(ret.chunks) do
      local message = chunk .. string.rep(" ", math.max(0, padding - vim.fn.strdisplaywidth(chunk)))

      if idx == 1 then
        local header = get_header(
          message,
          index_diag,
          ret,
          diag_hi,
          diag_inv_hi,
          total_chunks,
          ret.severities,
          ret.is_related or false
        )

        if index_diag == 1 and not (ret.is_related or false) then
          local chunk_arrow = get_arrow(cursor_line, ret)
          if type(chunk_arrow[1]) == "table" then
            all_vt[#all_vt + 1] = chunk_arrow
            all_vt[#all_vt + 1] = header
          else
            table.insert(header, 1, chunk_arrow)
            all_vt[#all_vt + 1] = header
          end
        else
          all_vt[#all_vt + 1] = header
        end
      else
        local b =
          get_body(message, index_diag, idx, #ret.chunks, diag_hi, body_hi, total_chunks, ret.is_related or false)
        all_vt[#all_vt + 1] = b
      end
    end

    if ret.need_to_be_under then table.insert(all_vt, 1, { { " ", "None" } }) end

    return all_vt, ret.offset_win_col, ret.need_to_be_under
  end

  local function vt_from_diagnostics(diags_on_line, cursor_pos, buf)
    local all_vt = {}
    local need_under = false
    local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1

    local chunks_list = {}
    local max_w = 0
    local has_related = false

    for i = 1, #diags_on_line do
      local ret = get_chunks(diags_on_line, i, cursor_pos[1], current_line, buf)
      max_w = math.max(max_w, get_max_width(ret.chunks))
      chunks_list[i] = ret
      has_related = has_related or ret.is_related
    end

    -- Append source tags aligned to the same column
    local max_msg_w = 0
    for _, ret in ipairs(chunks_list) do
      if ret.source_tag ~= "" then
        local last = ret.chunks[#ret.chunks] or ""
        max_msg_w = math.max(max_msg_w, vim.fn.strdisplaywidth(last))
      end
    end
    for _, ret in ipairs(chunks_list) do
      if ret.source_tag ~= "" and #ret.chunks > 0 then
        local last = ret.chunks[#ret.chunks]
        local pad = max_msg_w - vim.fn.strdisplaywidth(last)
        ret.chunks[#ret.chunks] = last .. string.rep(" ", pad) .. ret.source_tag
        max_w = math.max(max_w, get_max_width(ret.chunks))
      end
    end

    for i, ret in ipairs(chunks_list) do
      local padding = has_related and not ret.is_related and max_w + 1 or max_w
      local vt, _, diag_under = vt_from_diagnostic(ret, i, padding, #chunks_list)
      need_under = need_under or diag_under
      if need_under and i > 1 then table.remove(vt, 1) end
      vim.list_extend(all_vt, vt)
    end

    return all_vt, 0, need_under
  end

  local function set_extmark(buf, line, virt_text, win_col, priority, pos)
    if not buf or not vim.api.nvim_buf_is_valid(buf) then return end
    vim.api.nvim_buf_set_extmark(buf, ns, line, 0, {
      id = generate_uid(),
      virt_text = virt_text,
      virt_text_pos = pos or "eol",
      virt_text_win_col = win_col,
      priority = priority,
      strict = false,
    })
  end

  local function write_multiline(buf, curline, virt_lines, priority)
    local remaining = { unpack(virt_lines, 2) }
    local trimmed = {}
    for i, t in ipairs(virt_lines[1]) do
      trimmed[i] = { i == 1 and t[1] or t[1]:gsub("%s+", " "), t[2] }
    end
    vim.api.nvim_buf_set_extmark(buf, ns, curline, 0, {
      id = generate_uid(),
      virt_text_pos = "eol",
      virt_text = trimmed,
      virt_lines = remaining,
      priority = priority,
      strict = false,
    })
  end

  local function write_overflow(buf, params)
    local existing = params.buf_lines_count - params.curline
    local start_idx = params.need_to_be_under and 3 or 1
    local so = params.need_to_be_under and (params.signs_offset == 0 and 0 or 1) or params.signs_offset

    if params.need_to_be_under then
      set_extmark(buf, params.curline + 1, params.virt_lines[2], params.win_col, params.priority, nil)
    end

    for i = start_idx, existing do
      local co = params.win_col + params.offset + (i > start_idx and so or 0)
      set_extmark(buf, params.curline + i - 1, params.virt_lines[i], co, params.priority, "overlay")
    end

    local overflow = {}
    for i = existing + 1, #params.virt_lines do
      local line = vim.deepcopy(params.virt_lines[i])
      local co = params.win_col + params.offset + (i > start_idx and so or 0)
      table.insert(line, 1, { string.rep(" ", co), "None" })
      overflow[#overflow + 1] = line
    end

    if #overflow > 0 then
      vim.api.nvim_buf_set_extmark(buf, ns, params.buf_lines_count - 1, 0, {
        id = generate_uid(),
        virt_lines_above = false,
        virt_lines = overflow,
        priority = params.priority,
        strict = false,
      })
    end
  end

  local function write_simple(buf, curline, virt_lines, win_col, offset, signs_offset, priority)
    for i = 1, #virt_lines do
      local co = i == 1 and win_col or (win_col + offset + signs_offset)
      set_extmark(buf, curline + i - 1, virt_lines[i], co, priority, i > 1 and "overlay" or nil)
    end
  end

  local function should_skip_line(cursor_line, diag_line, diags_dims)
    for _, dims in ipairs(diags_dims) do
      if diag_line ~= dims[1] and cursor_line == dims[1] then
        if diag_line > dims[1] and diag_line < dims[1] + dims[2] then return true end
      end
    end
    return false
  end

  local function create_extmarks(buf, diag_line, diags_dims, virt_lines, offset, signs_offset, need_under, priority)
    if not vim.api.nvim_buf_is_valid(buf) or not virt_lines or vim.tbl_isempty(virt_lines) then return end
    local buf_lc = vim.api.nvim_buf_line_count(buf)
    if buf_lc == 0 then return end

    local function get_win_pos()
      local ok1, wl = pcall(vim.fn.winline)
      local ok2, vc = pcall(vim.fn.virtcol, "$")
      local ok3, sv = pcall(vim.fn.winsaveview)
      if not (ok1 and ok2 and ok3) then return { row = 0, col = 0 } end
      return { row = wl - 1, col = vc - sv.leftcol }
    end

    local wc = need_under and 0 or get_win_pos().col
    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1

    if diag_line ~= cursor_line then
      if should_skip_line(cursor_line, diag_line, diags_dims) then return end
      write_multiline(buf, diag_line, virt_lines, priority)
      return
    end

    if need_under or diag_line - 1 + #virt_lines > buf_lc - 1 then
      write_overflow(buf, {
        curline = diag_line,
        virt_lines = virt_lines,
        win_col = wc,
        offset = offset,
        signs_offset = signs_offset,
        priority = priority,
        need_to_be_under = need_under,
        buf_lines_count = buf_lc,
      })
    else
      write_simple(buf, diag_line, virt_lines, wc, offset, signs_offset, priority)
    end
  end

  local function render(buf)
    if not vim.api.nvim_win_is_valid(vim.api.nvim_get_current_win()) then return end
    if not (state.enabled and vim.diagnostic.is_enabled({ bufnr = buf }) and vim.api.nvim_buf_is_valid(buf)) then
      pcall(vim.api.nvim_buf_clear_namespace, buf, ns, 0, -1)
      return
    end

    local diagnostics = (state.cache[buf] or {})
    if vim.tbl_isempty(diagnostics) then
      local live = vim.diagnostic.get(buf)
      if live and #live > 0 then
        diagnostics = live
      else
        pcall(vim.api.nvim_buf_clear_namespace, buf, ns, 0, -1)
        return
      end
    end

    local cursor_line = vim.api.nvim_win_get_cursor(0)[1] - 1
    pcall(vim.api.nvim_buf_clear_namespace, buf, ns, 0, -1)

    local filtered = filter_for_display(buf, diagnostics)
    local visible = filter_visible(filtered)

    local diags_dims = {}
    local plan = {}

    for lnum, diags in pairs(visible) do
      if diags then
        local dpos = { lnum, 0 }
        local virt_lines, offset, need_under

        if lnum == cursor_line then
          virt_lines, offset, need_under = vt_from_diagnostics(diags, dpos, buf)
        else
          local ch = get_chunks(diags, 1, dpos[1], cursor_line, buf)
          if ch.source_tag ~= "" and #ch.chunks > 0 then
            ch.chunks[#ch.chunks] = ch.chunks[#ch.chunks] .. ch.source_tag
          end
          local mw = get_max_width(ch.chunks)
          virt_lines, offset, need_under = vt_from_diagnostic(ch, 1, mw, 1)
        end

        diags_dims[#diags_dims + 1] = { lnum, #virt_lines }
        plan[#plan + 1] = { virt_lines = virt_lines, offset = offset, need_under = need_under, dpos = dpos }
      end
    end

    local priority = 2
    for _, item in ipairs(plan) do
      local so = not item.need_under and vim.fn.strdisplaywidth("   ") or 0
      create_extmarks(buf, item.dpos[1], diags_dims, item.virt_lines, item.offset, so, item.need_under, priority)
    end
  end

  local function detach(buf)
    state.attached[buf] = nil
    state.last_cursor[buf] = nil
    state.cache[buf] = nil
  end

  local function attach(buf)
    if state.attached[buf] then return end
    local fname = vim.api.nvim_buf_get_name(buf)
    if fname:match("%.env") then return end
    state.attached[buf] = true

    vim.api.nvim_create_autocmd("DiagnosticChanged", {
      group = group,
      buffer = buf,
      callback = function(args)
        if vim.api.nvim_buf_is_valid(args.buf) then
          cache_update(args.buf, vim.diagnostic.get(args.buf))
          render(args.buf)
        end
      end,
    })

    vim.api.nvim_create_autocmd("CursorMoved", {
      group = group,
      buffer = buf,
      callback = function(args)
        if not vim.api.nvim_buf_is_valid(args.buf) then
          detach(args.buf)
          return
        end
        state.last_cursor[args.buf] = vim.api.nvim_win_get_cursor(0)
        render(args.buf)
      end,
    })

    local ctl_s = vim.api.nvim_replace_termcodes("<C-S>", true, true, true)
    local ctl_v = vim.api.nvim_replace_termcodes("<C-V>", true, true, true)
    local disabled_modes = { ctl_s, ctl_v, "s", "v", "V", "i", "ic", "ix" }

    vim.api.nvim_create_autocmd("ModeChanged", {
      group = group,
      buffer = buf,
      callback = function(args)
        if not vim.api.nvim_buf_is_valid(args.buf) then
          detach(args.buf)
          return
        end
        if vim.tbl_contains(disabled_modes, vim.fn.mode()) then
          state.enabled = false
        else
          state.enabled = true
        end
        render(args.buf)
      end,
    })

    vim.api.nvim_create_autocmd({ "BufDelete", "BufUnload", "BufWipeout" }, {
      group = group,
      buffer = buf,
      callback = function(args) detach(args.buf) end,
    })

    vim.api.nvim_create_autocmd({ "VimResized", "WinResized" }, {
      group = group,
      callback = function()
        if vim.api.nvim_buf_is_valid(buf) then
          render(buf)
        else
          detach(buf)
        end
      end,
    })

    -- Initial render if diagnostics exist
    local existing = vim.diagnostic.get(buf)
    if existing and #existing > 0 then
      cache_update(buf, existing)
      vim.schedule(function() render(buf) end)
    end
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(ev)
      if vim.api.nvim_buf_is_valid(ev.buf) then attach(ev.buf) end
    end,
  })

  vim.api.nvim_create_autocmd("ColorScheme", {
    group = group,
    callback = setup_highlights,
  })
end
