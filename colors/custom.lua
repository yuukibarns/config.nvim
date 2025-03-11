local function shl(group, properties)
    vim.api.nvim_set_hl(0, group, properties)
end

local function load_custom()
    -- Remove Background
    shl("Normal", { ctermfg = 250, ctermbg = "none", fg = "#bcbcbc", bg = "none" })
    -- shl("NormalNC", { bg = "none" })
    -- Tweak Visual
    shl("Visual", { ctermbg = 240, bg = "#404040" })
    -- Tweak LSP
    shl("Identifier", { link = "NONE" })
    shl("Function", { ctermfg = 109, fg = "#87afaf" })
    shl("Folded", { link = "NONE" })
    shl("@module", { link = "@module.builtin" })
    shl("@lsp.kind.property", { link = "Function" })
    -- UI
    shl("Cursor", { link = "TermCursor" })
    -- shl("FloatBorder", { ctermfg = 243, ctermbg = 243, fg = "#767676", bg = "#767676" })
    shl("VertSplit", { link = "Comment" })
    shl("CursorLine", { ctermbg = "none" })
    shl("StatusLine", { link = "NONE" })
    shl("TreesitterContextSeparator", { link = "NONE" })
    shl("TreesitterContext", { link = "NONE" })
    -- Latex
    shl("Conceal", { link = "@markup.math.latex" })
    shl("@none.latex", { link = "NONE" })
    shl("@markup.math.latex", { link = "Function" })
    shl("@function.latex", { link = "Function" })
    shl("SpellBad", { underline = true })
    shl("SpellRare", { underline = true })
    shl("SpellCap", { underline = true })
    shl("SpellLocal", { underline = true })
    -- vimdoc
    shl("@markup.link.vimdoc", { underline = true })
    shl("NormalFloat", { link = "NONE" })
    shl("Pmenu", { link = "NONE" })
end

-- Be a Quiet Boy
local function quiet_boy()
    shl("Identifier", { link = "NONE" })
    shl("Statement", { link = "NONE" })
    shl("String", { link = "NONE" })
    shl("Special", { link = "NONE" })
    shl("Constant", { link = "NONE" })
    shl("Type", { link = "NONE" })
    shl("Character", { link = "NONE" })
    shl("Folded", { link = "NONE" })
    shl("VertSplit", { link = "NONE" })
    shl("NormalFloat", { link = "NONE" })
    shl("Pmenu", { link = "NONE" })
end

load_custom()
