return {
	-- filesype plugin for `MarkDown`
	{
		"jzr/markdown.nvim",
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
}
