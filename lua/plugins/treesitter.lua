return {

	-- treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"latex",
					"markdown",
					"markdown_inline",
					"regex",
					"java",
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
				},
			})
		end,
	},
}
