local statusline = require("mini.statusline")
local icons = require("mini.icons")

statusline.setup({
	content = {
		active = function()
      -- NOTE these are custom highlight groups that are not part of MiniNvim
      -- stylua: ignore start
      local diagnostic_icons = {
        ERROR = "",
        WARN  = "",
        INFO  = "",
        HINT  = "",
      }
			-- stylua: ignore end

			local diagnostic_symbols = {}

			for severity, icon in pairs(diagnostic_icons) do
				diagnostic_symbols[severity] =
					string.format("%%#MiniStatuslineDiag%s#%s %%#MiniStatuslineDevinfo#", severity, icon)
			end

			local function section_fileinfo(trunc_width)
				local ft = vim.bo.filetype or "none"
				local shiftwidth = "󰌒 " .. vim.api.nvim_get_option_value("shiftwidth", { buf = 0 })

				if ft == "toggleterm" then
					return
				end

				local icon, hl = icons.get("filetype", ft, { with_hl = true })
				local fileinfo = string.format("%%#%s#%s %%#MiniStatuslineFileinfo#%s%%*", hl or "", icon, ft)
				local truncate = statusline.is_truncated(trunc_width)

				if ft == "toggleterm" then
					return nil
				else
					return truncate and fileinfo or shiftwidth .. " " .. fileinfo
				end
			end

			local function section_location(trunc_width)
				local ft = vim.bo.filetype or "none"
				local line = vim.fn.line(".")
				local col = vim.fn.col(".")
				local truncate = statusline.is_truncated(trunc_width)

				if ft == "toggleterm" then
					return nil
				else
					return truncate and "" or string.format("%d:%d", line, col)
				end
			end

			local mode, mode_hl = statusline.section_mode({ trunc_width = 80 })
			local git = statusline.section_git({ trunc_width = 100 })
			local diff = statusline.section_diff({ trunc_width = 100, icon = "" })
			local diagnostics =
				statusline.section_diagnostics({ trunc_width = 75, icon = "", signs = diagnostic_symbols })
			local filename = statusline.section_filename({ trunc_width = 240 })
			local searchcount = statusline.section_searchcount({ trunc_width = 120 })
			local fileinfo = section_fileinfo(80)
			local location = section_location(80)

			local progressbar = function()
				local current_line = vim.fn.line(".")
				local total_lines = vim.fn.line("$")
				local chars = { "__", "▁▁", "▂▂", "▃▃", "▄▄", "▅▅", "▆▆", "▇▇", "██" }
				local line_ratio = current_line / total_lines
				local index = math.ceil(line_ratio * #chars)
				return chars[index]
			end

			local progress = function()
				local ft = vim.bo.filetype or "none"

				if ft == "toggleterm" then
					return nil
				else
					return "%P" .. " " .. progressbar()
				end
			end

			return statusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { git, diff, diagnostics } },
				"%<", -- Mark general truncate point
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=", -- End left alignment
				-- { hl = "MiniStatuslineFileinfo", strings = { fileinfo } },
				{ hl = "MiniStatuslineFilename", strings = { fileinfo } },
				{ hl = "MiniStatuslineLocation", strings = { searchcount, location } },
				{ hl = mode_hl, strings = { progress } },
			})
		end,
	},
})
