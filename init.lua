vim.loader.enable()

-- DISABLE REMOTE PLUGINS
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- COLORSCHEME
vim.cmd([[colorscheme custom]])

---------- LAZYINIT ----------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	dev = {
		fallback = false,
		path = "~/Learn/git",
		patterns = { "jzr" },
	},
	spec = {
		{ import = "plugins" },
	},
	ui = {
		border = "rounded",
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"netrwPlugin",
				"rplugin",
				"shada",
				"spellfile",
				"tarPlugin",
				"tutor",
				"zipPlugin",
			},
		},
	},
})
