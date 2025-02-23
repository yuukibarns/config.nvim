return {
	-- filesype plugin for markdown
	{
		"yuukibarns/markdown.nvim",
		ft = { "markdown", "tex" },

		config = function()
			require("markdown").setup({
				conceals = {
					enabled = {
						"amssymb",
						"core",
						"delim",
						"font",
						"greek",
						--	"mleftright",
						"math",
						"script",
					},
				},
			})
		end,
	},

	-- Faster LuaLS setup for Neovim
	{ "folke/lazydev.nvim", ft = "lua", config = true },

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function()
			require("lazy").load({ plugins = { "markdown-preview.nvim" } })
			vim.fn["mkdp#util#install"]()
		end,
		keys = {
			{
				"<leader>cp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
	},
}
