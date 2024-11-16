return {
	-- filesype plugin for `MarkDown`
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

	-- markdown preview
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreviewStart", "MarkdownPreviewStop" },
		ft = "markdown",
		build = function()
			vim.cmd([[Lazy load markdown-preview.nvim]])
			vim.fn["mkdp#util#install"]()
		end,
	},

	-- Faster lua-language-server set
	{
		"folke/lazydev.nvim",
		ft = "lua",
		config = true,
	},
}
