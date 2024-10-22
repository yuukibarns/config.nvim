return {

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter.configs").setup({
				modules = {},
				sync_install = false,
				auto_install = true,
				ignore_install = {},
				highlight = {
					enable = true,
				},
				ensure_installed = {
					"markdown",
					"markdown_inline",
					"latex",
					"vim",
					"lua",
					"bash",
					"c",
					"cpp",
					"bibtex",
					"comment",
					"python",
					"query",
					"vimdoc",
					"rust",
					"toml",
					"html",
				},
			})
		end,
	},
}
