-- nvim-treesitter
local path = vim.fn.stdpath("data") .. "/nvim-treesitter"
vim.opt.rtp:prepend(path)

require("nvim-treesitter.configs").setup({
	ensure_installed = {
		"markdown",
		"markdown_inline",
		"latex",
	},
	highlight = { enable = true },
})

