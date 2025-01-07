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

	-- markdown preview
	{
		"toppair/peek.nvim",
		ft = { "markdown" },
		build = "deno task --quiet build:fast",
		config = function()
			require("peek").setup({
				app = "browser",
			})
			vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
			vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
		end,
	},

	-- Faster LuaLS setup for Neovim
	{ "folke/lazydev.nvim", ft = "lua", config = true },

	-- {
	-- 	"iamcco/markdown-preview.nvim",
	-- 	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	-- 	ft = { "markdown" },
	-- 	build = function()
	-- 		vim.cmd([[Lazy load markdown-preview.nvim]])
	-- 		vim.fn["mkdp#util#install"]()
	-- 	end,
	-- },
}
