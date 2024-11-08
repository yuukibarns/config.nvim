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

	-- Faster lua-language-server set
	{
		"folke/lazydev.nvim",
		ft = "lua",
		config = true,
	},
}
