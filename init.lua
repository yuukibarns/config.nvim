vim.hl = vim.highlight

vim.loader.enable()

-- DISABLE REMOTE PLUGINS
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- MAPLEADER
vim.g.mapleader = " "

-- PLAINTEX NEVER
vim.g.tex_flavor = "latex"

-- POWERSHELL
vim.o.shell = vim.fn.executable('pwsh') == 1 and 'pwsh' or 'powershell'
vim.o.shellcmdflag = '-NoLogo -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.UTF8Encoding]::new();$PSDefaultParameterValues[\'Out-File:Encoding\']=\'utf8\';Remove-Alias -Force -ErrorAction SilentlyContinue tee;'
vim.o.shellredir = '2>&1 | %%{ "$_" } | Out-File %s; exit $LastExitCode'
vim.o.shellpipe = '2>&1 | %%{ "$_" } | tee %s; exit $LastExitCode'
vim.o.shellquote = ''
vim.o.shellxquote = ''

-- NANOLS
vim.g.markdown_fenced_languages = {
  "ts=typescript"
}

-- NVCHAD
vim.g.base46_cache = vim.fn.stdpath("data") .. "/base46_cache/"

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
		path = "~",
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

-- NVCHAD
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
	dofile(vim.g.base46_cache .. v)
end
