return {
    {
        "yuukibarns/snacks.nvim",
        branch = "test2",
        commit = "79ce1180b16be2bb14c67fb2b4c6a0ecb2959582",
        lazy = false,
        priority = 1000,
        keys = {
            {
                "<leader>K",
                function()
                    Snacks.image.open()
                    Snacks.image.show_src()
                    vim.cmd('normal! \x1b')
                end,
                mode = { "n", "v" },
                ft = { "tex", "markdown", "python" },
                desc = "Open images inline"
            },
            {
                "<leader>L",
                function()
                    Snacks.image.close()
                    vim.cmd('normal! \x1b')
                end,
                mode = { "n", "v" },
                ft = { "tex", "markdown", "python" },
                desc = "Close images inline"
            },
        },
        ---@type snacks.Config
        opts = {
            -- picker = { enabled = true },
            image = {
                doc = {
                    -- enable image viewer for documents
                    -- a treesitter parser must be available for the enabled languages.
                    enabled = true,
                    -- render the image inline in the buffer
                    -- if your env doesn't support unicode placeholders, this will be disabled
                    -- takes precedence over `opts.float` on supported terminals
                    inline = false,
                    -- render the image in a floating window
                    -- only used if `opts.inline` is disabled
                    float = false,
                    max_width = 80,
                    max_height = 40,
                    -- Set to `true`, to conceal the image text when rendering inline.
                    conceal = false, -- (experimental)
                },
                convert = {
                    magick = {
                        default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
                        vector = { "-density", 192, "{src}[0]" },         -- used by vector images like svg
                        -- math = { "-density", 96 * 4, "{src}[0]", "-resize", "150%", "-trim" },
                        math = { "-density", 192, "{src}[0]", "-trim" },
                        pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
                    },
                },
                math = {
                    enabled = true, -- enable math expression rendering
                    -- in the templates below, `${header}` comes from any section in your document,
                    -- between a start/end header comment. Comment syntax is language-specific.
                    -- * start comment: `// snacks: header start`
                    -- * end comment:   `// snacks: header end`
                    latex = {
                        font_size = "Large", -- see https://www.sascha-frank.com/latex-font-size.html
                        -- for latex documents, the doc packages are included automatically,
                        -- but you can add more packages here. Useful for markdown documents.
                        packages = { "amsmath", "amssymb", "mathtools", "mathrsfs", "tikz-cd", "quiver" },
                        tpl = [[
        \documentclass[preview,border=0pt,varwidth=\maxdimen]{standalone}
        \usepackage{${packages}}
        \begin{document}
        ${header}
        { \${font_size} \selectfont
          \color[HTML]{${color}}
        ${content}}
        \end{document}]],
                    },
                },
            }
        }
    }
}
