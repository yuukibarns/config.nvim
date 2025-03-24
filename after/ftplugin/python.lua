vim.api.nvim_buf_set_keymap(0, "n", "<C-j>", "[s1z=", { desc = "Crect Last Spelling" })

-- Define highlights
vim.api.nvim_set_hl(0, 'MarkdownCell', { link = "@string" })
vim.api.nvim_set_hl(0, 'CodeCell', { link = "@keyword" })

-- Configure cell symbols
local symbols = {
    markdown = '󰍔',
    code = '󰌠'
}

local function create_cell_overlay(buf, ns, row, symbol, hl_group, line)
    local win = vim.api.nvim_get_current_win()
    local win_width = vim.api.nvim_win_get_width(win)

    -- Calculate original line's display width
    local original_len = vim.fn.strdisplaywidth(line)

    -- Calculate available space for text (excluding line numbers and sign column)
    local num_width = vim.wo.number and vim.wo.numberwidth or 0
    local sign_width = vim.wo.signcolumn == 'yes' and 2 or 0
    local available_width = win_width - num_width - sign_width

    -- Create icon with padding
    local icon_text = symbol .. " "

    -- Add icon at line start
    vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
        virt_text = { { icon_text, hl_group } },
        virt_text_pos = 'overlay',
        hl_mode = 'combine',
        spell = false,
        priority = 100,
    })

    -- Calculate separator position and length
    local separator_start = 0
    local separator_length = math.max(0, available_width - separator_start)

    if separator_length > 0 then
        local separator = string.rep('═', separator_length)
        vim.api.nvim_buf_set_extmark(buf, ns, row, separator_start, {
            virt_text = { { separator, hl_group } },
            virt_text_pos = 'overlay',
            hl_mode = 'combine',
            priority = 99,
        })
    end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'TextChanged', 'TextChangedI', 'WinResized', 'OptionSet' }, {
    pattern = '*.py',
    callback = function()
        local buf = vim.api.nvim_get_current_buf()
        local ns = vim.api.nvim_create_namespace('jupyter_cells')
        vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)

        local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
        for lnum, line in ipairs(lines) do
            local row = lnum - 1

            if line:match('^# %%%% %[markdown%]') then
                create_cell_overlay(buf, ns, row, symbols.markdown, 'MarkdownCell', line)
            elseif line:match('^# %%%%') then
                create_cell_overlay(buf, ns, row, symbols.code, 'CodeCell', line)
            end
        end
    end
})


-- Automatically sync notebook when saving buffer
vim.api.nvim_create_augroup('jupytext_sync', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    group = 'jupytext_sync',
    pattern = '*.py',
    callback = function()
        local file = vim.fn.expand('%:p')
        vim.system(
            { 'jupytext', '--sync', file },
            { detach = true },
            function(obj)
                if obj.stderr then
                    print(obj.stderr)
                end
                if obj.stdout then
                    print(obj.stdout)
                    print("[jupytext] Synced " .. file)
                end
            end
        )
    end
})
