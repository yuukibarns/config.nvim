local function shl(group, properties)
	vim.api.nvim_set_hl(0, group, properties)
end

local function load_custom()
	-- Remove Background
	shl("Normal", { ctermfg = 250, ctermbg = "none", fg = "#bcbcbc", bg = "none" })
	-- Tweak Visual
	shl("Visual", { ctermbg = 240, bg = "#303030" })
	-- Tweak LSP
	shl("Identifier", { link = "Normal" })
	shl("Function", { ctermfg = 109, fg = "#87afaf" })
	shl("@variable.parameter", { italic = true })
	shl("Folded", { link = "NONE" })
	-- UI
	shl("FloatBorder", { ctermfg = 243, ctermbg = 243, fg = "#767676", bg = "#767676" })
	shl("VertSplit", { link = "NONE" })
	shl("CursorLine", { ctermbg = "none" })
	shl("StatusLine", { link = "NONE" })
	shl("TreesitterContextSeparator", { link = "NONE" })
	shl("TreesitterContext", { link = "NONE" })
	-- Latex
	shl("Conceal", { link = "NONE" })
	shl("@none.latex", { link = "NONE" })
	shl("@markup.math.latex", { link = "NONE" })
	shl("SpellBad", { underline = true })
	shl("SpellRare", { underline = true })
	shl("SpellCap", { underline = true })
	shl("SpellLocal", { underline = true })
	shl("@markup.raw.markdown_inline", { link = "Pmenu" })
	-- Be a Quiet Boy
	-- shl("Identifier", { link = "NONE" })
	-- shl("Statement", { link = "NONE" })
	-- shl("String", { link = "NONE" })
	-- shl("Special", { link = "NONE" })
	-- shl("Constant", { link = "NONE" })
	-- shl("Type", { link = "NONE" })
	-- shl("Character", { link = "NONE" })
	-- shl("Folded", { link = "NONE" })
	-- shl("VertSplit", { link = "NONE" })
	-- shl("NormalFloat", { link = "NONE" })
	-- shl("Pmenu", { link = "NONE" })
end

load_custom()
