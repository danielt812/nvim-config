local M = { "iamcco/markdown-preview.nvim" }

M.enabled = true

M.ft = { "markdown" }

M.cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" }

M.build = function()
	vim.fn["mkdp#util#install"]()
end

M.config = function()
	vim.cmd([[do FileType]])
end

return M
