return {

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				sync_install = false,
				ignore_install = {},
				auto_install = true,
				ensure_installed = {
					"latex",
					"markdown",
					"markdown_inline",
					"regex",
					"java",
					"javascript",
					"vim",
					"lua",
					"bash",
					"c",
					"cpp",
					"bibtex",
					"comment",
					"diff",
					"luadoc",
					"luap",
					"python",
					"query",
					"vimdoc",
					"rust",
					"gitcommit",
					"git_rebase",
					-- "git_config",
					"cmake",
					"toml",
					"html",
					"powershell",
				},
			})
		end,
		highlight = { enable = true },
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		config = true,
	},
}
