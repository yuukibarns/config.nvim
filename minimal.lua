-- nvim-treesitter
local path = "~/nvim-treesitter"
vim.opt.rtp:prepend(path)

require("nvim-treesitter.configs").setup({
	modules = {},
	sync_install = false,
	ignore_install = {},
	auto_install = true,
	ensure_installed = {
		"markdown",
		"markdown_inline",
	},
	highlight = { enable = true },
})
