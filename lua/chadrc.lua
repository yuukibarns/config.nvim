local options = {
    base46 = {
        theme = "doomchad",
        transparency = false,
        hl_add = {
            Conceal = { link = "@function.latex" },
            ["@none.latex"] = { link = "Normal" },
            TreesitterContext = { link = "NONE" },
            CmpSel = { link = "Visual" },
        },
        integrations = {
            "alpha",
            "markview",
            "whichkey",
            "leap",
            "lsp",
            "treesitter",
            -- "blink",
            "cmp",
        },
    },
    ui = {
        statusline = {
            enabled = true,
            order = { "file", "git", "modified", "%=", "lsp_msg", "diagnostics", "lsp", "cursor" },
            modules = {
                modified = " %h%m%r",
                -- cursor = "%c%V",
                cursor = "%#St_pos_sep#" .. "" .. "%#St_pos_icon# %#St_pos_text# %c%V %p%% ",
            },
        },
        tabufline = {
            enabled = true,
            order = { "treeOffset", "buffers", "tabs" },
        },
    },
    nvdash = {
        load_on_startup = false,
    },
    lsp = {
        signature = false,
    },
}

return options
