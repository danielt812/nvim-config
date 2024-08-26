local M = { "hrsh7th/nvim-cmp" }

M.enabled = true

M.dependencies = {
	{ "hrsh7th/cmp-nvim-lsp" },
	{ "hrsh7th/cmp-buffer" },
	{ "hrsh7th/cmp-path" },
	{ "L3MON4D3/LuaSnip" },
	{ "rafamadriz/friendly-snippets" },
	{ "saadparwaiz1/cmp_luasnip" },
	{ "zbirenbaum/copilot-cmp" },
}

M.event = { "InsertEnter" }

M.opts = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")

	luasnip.config.set_config({
		region_check_events = "InsertEnter",
		delete_check_events = "InsertLeave",
	})

	require("luasnip.loaders.from_vscode").lazy_load()

	local icons = require("icons")

	local has_words_before = function()
		if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
			return false
		end
		local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
	end

	return {
		snippet = {
			expand = function(args)
				luasnip.lsp_expand(args.body) -- For `luasnip` users.
			end,
		},
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		preselect = cmp.PreselectMode.None,
		mapping = cmp.mapping.preset.insert({
			["<C-k>"] = cmp.mapping.select_prev_item(),
			["<C-j>"] = cmp.mapping.select_next_item(),
			["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(1)),
			["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1)),
			["<C-Space>"] = cmp.mapping(cmp.mapping.complete()),
			["<C-q>"] = cmp.mapping(cmp.mapping.abort()),
			["<CR>"] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. If none selected, don't `select` first item.

			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
				elseif luasnip.expand_or_jumpable() then
					luasnip.expand_or_jump()
				elseif has_words_before() then
					cmp.complete()
				else
					fallback()
				end
			end, { "i", "s" }),

			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					fallback()
				end
			end, { "i", "s" }),
		}),
		formatting = {
			fields = { "kind", "abbr", "menu" },
			format = function(entry, vim_item)
				vim_item.kind = icons.kind[vim_item.kind]
				vim_item.menu = ({
					copilot = "COPILOT",
					lazydev = "LAZYDEV",
					path = "PATH",
					nvim_lsp = "LSP",
					luasnip = "LUASNIP",
					buffer = "BUFFER",
				})[entry.source.name]
				return vim_item
			end,
		},
		sources = {
			{ name = "nvim_lsp" },
			{ name = "lazydev" },
			{ name = "copilot" },
			{ name = "luasnip" },
			{ name = "path" },
			-- { name = "nvim_lua" },
			{ name = "buffer" },
		},
		confirm_opts = {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		experimental = {
			ghost_text = true,
		},
	}
end

M.config = function(_, opts)
	require("cmp").setup(opts)
end

return M
