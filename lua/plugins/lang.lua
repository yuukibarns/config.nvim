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

	-- obsidian
	{
		"yuukibarns/obsidian.nvim",
		version = "*",
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
			mappings = {
				["gf"] = {
					action = function()
						return require("obsidian").util.gf_passthrough()
					end,
					opts = { noremap = false, expr = true, buffer = true },
				},
			},
			ui = {
				enable = false,
			},
		},
	},

	--markdown preview
	{
		"iamcco/markdown-preview.nvim",

		ft = { "markdown" },
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		build = "cd app && yarn install",

		init = function()
			vim.g.mkdp_filetypes = { "markdown" }
			vim.g.mkdp_preview_options = {
				disable_sync_scroll = 1,
			}
		end,
	},

	-- Faster LuaLS setup for Neovim
	{ "folke/lazydev.nvim", ft = "lua", config = true },
}
