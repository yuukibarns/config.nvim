local options = {
	base46 = {
		theme = "jellybeans",
		transparency = false,
		hl_add = {
			Conceal = { link = "@function.latex" },
			["@none.latex"] = { link = "Normal" },
			StatusLine = { link = "Normal" },
		},
		integrations = {
			-- "cmp",
		},
	},
	ui = {
		statusline = {
			enabled = false,
			order = { "file", "git", "modified", "%=", "lsp_msg", "diagnostics", "lsp", "cursor" },
			modules = {
				modified = " %h%m%r",
				-- cursor = "%c%V",
				cursor = "%#St_pos_sep#" .. "" .. "%#St_pos_icon# %#St_pos_text# %c%V %p%% ",
			},
		},
		tabufline = {
			enabled = false,
		},
	},
	nvdash = {
		load_on_startup = false,
	},
	lsp = {
		signature = true,
	},
}

return options
