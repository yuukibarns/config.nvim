return {

	-- filesype plugin for `LaTeX`
	{
		"yuukibarns/latex.nvim",
		ft = "tex",
		config = function()
			require("latex").setup({
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
				imaps = {
					enabled = false,
					add = {},
					default_leader = "`",
				},
				surrounds = {
					enabled = false,
					command = "c",
					environment = "e",
				},
				texlab = {
					enabled = true,
					build = "<A-b>",
					forward = "<A-f>",
					cancel_build = "<A-x>",
					-- close_env = "]]",
					-- change_env = "cse",
					-- toggle_star = "tse",
				},
			})
		end,
	},

	-- filesype plugin for `MarkDown`
	{
		"jzr/markdown.nvim",
		ft = "markdown",
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
