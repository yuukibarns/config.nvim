local options = {
	base46 = {
		theme = "gruvchad",
		transparency = true,
		integrations = {},
	},
	ui = {
		statusline = {
			order = { "file", "git", "modified", "%=", "diagnostics", "lsp", "cursor" },
			modules = {
				modified = " %h%m%r",
			},
		},
		tabufline = {
			enabled = false,
		},
	},
	nvdash = {
		load_on_startup = false,
	},
	lsp = { signature = false },
}

return options
