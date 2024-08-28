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

	-- obsidian
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		-- lazy = true,
		ft = "markdown",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		opts = {
			workspaces = {
				{
					name = "personal",
					path = "~/Learn/vaults/personal",
				},
				{
					name = "work",
					path = "~/Learn/vaults/work",
				},
			},
		},
	},

	--markdown preview
	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 	build = "cd app && yarn install",
	-- 	ft = "markdown",
	-- },
	-- {
	-- 	"ellisonleao/glow.nvim",
	-- 	config = function()
	-- 		require("glow").setup({
	-- 			border = "rounded",
	-- 		})
	-- 	end,
	-- 	cmd = "Glow",
	-- 	ft = "markdown",
	-- },

	-- Faster LuaLS setup for Neovim
	{ "folke/lazydev.nvim", ft = "lua", config = true },
}
