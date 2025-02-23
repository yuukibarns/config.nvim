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

	-- markdown preview
	-- {
	-- 	"toppair/peek.nvim",
	-- 	ft = { "markdown" },
	-- 	cmd = { "PeekOpen", "PeekClose" },
	-- 	build = "deno task --quiet build:fast",
	-- 	keys = {
	-- 		{
	-- 			"<leader>cp",
	-- 			ft = "markdown",
	-- 			"<cmd>PeekOpen<cr>",
	-- 		}
	-- 	},
	-- 	config = function()
	-- 		require("peek").setup({
	-- 			app = "browser",
	-- 		})
	-- 		vim.api.nvim_create_user_command("PeekOpen", require("peek").open, {})
	-- 		vim.api.nvim_create_user_command("PeekClose", require("peek").close, {})
	-- 	end,
	-- },
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
		-- config = function()
		-- 	vim.cmd([[do FileType]])
		-- end,
	},
}
