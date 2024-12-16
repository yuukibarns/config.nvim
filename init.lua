vim.loader.enable()

-- DISABLE REMOTE PLUGINS
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- COLORSCHEME
-- vim.cmd([[colorscheme habamax]])
-- vim.cmd([[colorscheme custom]])

-- VIM-SNEAK
vim.cmd([[map s <Plug>Sneak_s]])
vim.cmd([[map S <Plug>Sneak_S]])

-- NVCHAD
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

---------- LAZYINIT ----------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- if not vim.uv.fs_stat(lazypath) then
-- 	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
-- 	vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
-- end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- dev = {
	-- 	fallback = true,
	-- 	path = "~",
	-- 	patterns = { "jzr" },
	-- },
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

-- NVCHAD
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end
