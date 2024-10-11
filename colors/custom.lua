local function shl(group, properties)
	vim.api.nvim_set_hl(0, group, properties)
end

local function load_custom()
	shl("TreesitterContext", { bg = "bg" })
	shl("@conceal.latex", { link = "@markup.math" })
	shl("@markup.math", { link = "Identifier" })
	shl("@none", { fg = "fg" })
	shl("@variable.parameter", { italic = true, fg = "NvimLightGray2" })
	shl("Boolean", { bold = true, fg = "NvimLightGray2" })
	shl("@markup.heading", { bold = true, fg = "NvimLightGreen" })
	shl("@keyword.directive.markdown", { link = "Comment" })
	shl("StatusLine", { fg = "fg", bg = "bg" })
	shl("@punctuation.bracket.latex", { fg = "NvimLightRed" })
	shl("@module.latex", { fg = "NvimLightYellow" })
end

load_custom()
