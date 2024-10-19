local function shl(group, properties)
	vim.api.nvim_set_hl(0, group, properties)
end

local function load_custom()
	-- StatusLine
	shl("StatusLine", { fg = "fg", bg = "bg" })
	-- Term
	shl("TermCursor", { fg = "bg", bg = "fg" })
	-- Fold
	shl("Folded", { fg = "fg", bg = "bg" })
	-- Lsp
	shl("@variable.parameter", { italic = true, fg = "NvimLightGray2" })
	shl("@type", { fg = "NvimLightYellow" })
	shl("@type.builtin", { link = "@type" })
	shl("@variable.builtin", { link = "@keyword" })
	-- Lazy
	shl("LazyReasonEvent", { fg = "NvimLightYellow" })
	shl("LazyReasonStart", { fg = "NvimLightGreen" })
	shl("LazyReasonRequire", { fg = "NvimLightBlue" })
	shl("LazyReasonFt", { fg = "NvimLightGreen" })
	shl("LazyReasonCmd", { fg = "NvimLightBlue" })
	shl("LazyReasonSource", { fg = "NvimLightGreen" })
	shl("LazyReasonKeys", { fg = "NvimLightRed" })
	-- TreesitterContext
	shl("TreesitterContext", { bg = "bg" })
	-- Markup
	shl("@markup.heading", { bold = true, fg = "NvimLightGreen" })
	shl("@markup.link.label.markdown_inline", { fg = "NvimLightCyan" })
	shl("@conceal.latex", { link = "@markup.math" })
	shl("@markup.math", { link = "Identifier" })
	shl("@punctuation.bracket.latex", { fg = "NvimLightRed" })
	shl("@module.latex", { fg = "NvimLightYellow" })
	shl("@none", { fg = "fg" })
	shl("@keyword.directive.markdown", { link = "Comment" })
end

load_custom()
