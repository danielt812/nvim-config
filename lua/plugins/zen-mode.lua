local M = { "folke/zen-mode.nvim" }

M.enabled = true

M.cmd = { "ZenMode" }

M.opts = function()
	return {
		window = {
			backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
			width = 120, -- width of the Zen window
			height = 1, -- height of the Zen window
			options = {
				-- signcolumn = "no", -- disable signcolumn
				-- number = false, -- disable number column
				-- relativenumber = false, -- disable relative numbers
				-- cursorline = false, -- disable cursorline
				-- cursorcolumn = false, -- disable cursor column
				-- foldcolumn = "0", -- disable fold column
				-- list = false, -- disable whitespace characters
			},
		},
		plugins = {
			options = {
				ruler = false, -- disables the ruler text in the cmd line area
				showcmd = false, -- disables the command in the last line of the screen
				-- you may turn on/off statusline in zen mode by setting 'laststatus'
				-- statusline will be shown only if 'laststatus' == 3
				laststatus = 0, -- turn off the statusline in zen mode
			},
			twilight = { enabled = false }, -- enable to start Twilight when zen mode opens
			gitsigns = { enabled = true }, -- disables git signs
			tmux = { enabled = true }, -- disables the tmux statusline
			kitty = {
				enabled = true,
				font = "+4", -- font size increment
			},
		},
	}
end

M.config = function(_, opts)
	require("zen-mode").setup(opts)
end

return M
