local M = { "kevinhwang91/nvim-ufo" }

M.enabled = true

M.event = { "LspAttach" }

M.dependencies = { "kevinhwang91/promise-async" }

M.init = function()
	vim.keymap.set("n", "zR", "<cmd>lua require('ufo').openAllFolds()<CR>")
	vim.keymap.set("n", "zM", "<cmd>lua require('ufo').closeAllFolds()<CR>")
	vim.keymap.set("n", "zr", "<cmd>lua require('ufo').openFoldsExceptKinds()<CR>")
	vim.keymap.set("n", "zm", "<cmd>lua require('ufo').closeFoldsWith()<CR>") -- closeAllFolds == closeFoldsWith(0)
end

M.opts = function()
	local handler = function(virtText, lnum, endLnum, width, truncate, ctx)
		local filling = " ... "
		local suffix = (" %d lines "):format(endLnum - lnum)
		local suffixWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - suffixWidth
		local curWidth = 0
		table.insert(virtText, { filling, "Folded" })
		local endVirtText = ctx.get_fold_virt_text(endLnum)
		for i, chunk in ipairs(endVirtText) do
			local chunkText = chunk[1]
			local hlGroup = chunk[2]
			if i == 1 then
				chunkText = chunkText:gsub("^%s+", "")
			end
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if targetWidth > curWidth + chunkWidth then
				table.insert(virtText, { chunkText, hlGroup })
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				table.insert(virtText, { chunkText, hlGroup })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				-- str width returned from truncate() may less than 2nd argument, need padding
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end
		table.insert(virtText, { suffix, "Folded" })
		return virtText
	end

	return {
		enable_get_fold_virt_text = true,
		fold_virt_text_handler = handler,
		preview = {
			mappings = {
				scrollB = "<C-b>",
				scrollF = "<C-f>",
				scrollU = "<C-u>",
				scrollD = "<C-d>",
			},
		},
		provider_selector = function()
			return { "treesitter", "indent" }
		end,
	}
end

M.config = function(_, opts)
	require("ufo").setup(opts)
end

return M
