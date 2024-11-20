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
					-- markdown
					"markdown",
					"markdown_inline",
					"latex",
					-- vim
					"vim",
					"vimdoc",
					-- languages
					"lua",
					"c",
					"cpp",
					"python",
					-- shell
					"bash",
				},
			})
		end,
	},

	-- context 
	{
		"nvim-treesitter/nvim-treesitter-context",
		command = { "TSContextEnable", "TSContextDisable", "TSContextToggle" },
		config = function()
			require("treesitter-context").setup({
				max_lines = 6,
				mode = "topline",
				trim_scope = "inner",
				separator = "-",
			})
		end,
	},
}
