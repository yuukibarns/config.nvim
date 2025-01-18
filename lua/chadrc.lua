local options = {
	base46 = {
		theme = "jellybeans",
		transparency = true,
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
		-- cmp = {
		-- 	icons_left = false, -- only for non-atom styles!
		-- 	style = "default", -- default/flat_light/flat_dark/atom/atom_colored
		-- 	format_colors = {
		-- 		tailwind = false, -- will work for css lsp too
		-- 		icon = "󱓻",
		-- 	},
		-- },
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
