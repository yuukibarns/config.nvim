local opt = vim.opt_local

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.formatoptions = "qnjl"
opt.textwidth = 80

vim.keymap.set(
    "n",
    "<M-b>",
    "<Cmd>TexlabBuild<CR>",
    { desc = "Build the current buffer", buffer = true, noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<M-f>",
    "<Cmd>TexlabForward<CR>",
    { desc = "Forward search from current position", buffer = true, noremap = true, silent = true }
)
vim.keymap.set(
    "n",
    "<M-x>",
    "<Cmd>TexlabCancelBuild<CR>",
    { desc = "Cancel the current build", buffer = true, noremap = true, silent = true }
)


vim.api.nvim_buf_set_keymap(0, "n", "<C-j>", "[s1z=", { desc = "Crect Last Spelling" })

local function find_latex_pair(around, opening_delims, closing_delims)
    local line = vim.api.nvim_get_current_line()
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))

    -- Search backward for opening delimiter
    local start_open = nil
    local opening
    for i = col, 0, -1 do
        local flag = false
        for j = 1, #opening_delims, 1 do
            if i + #opening_delims[j] <= #line then
                local substr = line:sub(i + 1, i + #opening_delims[j])
                if substr == opening_delims[j] then
                    start_open = i
                    opening = opening_delims[j]
                    flag = true
                    break
                end
            end
        end
        if flag == true then
            break
        end
    end
    if not start_open then return nil end

    -- Search forward for closing delimiter
    local start_close = nil
    local closing
    for i = start_open + #opening, #line, 1 do
        local flag = false
        for j = 1, #closing_delims, 1 do
            if i + #closing_delims[j] <= #line then
                local substr = line:sub(i + 1, i + #closing_delims[j])
                if substr == closing_delims[j] then
                    start_close = i
                    closing = closing_delims[j]
                    flag = true
                    break
                end
            end
        end
        if flag == true then
            break
        end
    end
    if not start_close then return nil end

    -- Verify cursor position is within delimiters
    if col < start_open or col > start_close + (#closing - 1) then
        return nil
    end

    return {
        start = around and start_open or (start_open + #opening),
        finish = around and (start_close + #closing - 1) or (start_close - 1)
    }
end

local function handle_latex(around, mode, opening, closing)
    local pos = find_latex_pair(around, opening, closing)
    if not pos then return end

    local lnum = vim.fn.line('.') - 1
    local start_col = pos.start
    local end_col = pos.finish + 1 -- API uses exclusive end

    if mode == 'visual' then
        vim.cmd('normal! \x1b') -- Exit current mode
        vim.api.nvim_win_set_cursor(0, { vim.fn.line('.'), start_col })
        vim.cmd('normal! v')
        vim.api.nvim_win_set_cursor(0, { vim.fn.line('.'), pos.finish })
    elseif mode == 'delete' then
        vim.api.nvim_buf_set_text(0, lnum, start_col, lnum, end_col, {})
    elseif mode == 'change' then
        vim.api.nvim_buf_set_text(0, lnum, start_col, lnum, end_col, {})
        vim.cmd('startinsert')
    end
end

local math_delimiter_opening = { "\\(", "\\[" }
local math_delimiter_closing = { "\\)", "\\]" }

-- Visual mode
vim.api.nvim_buf_set_keymap(0, 'v', 'im', '', {
    noremap = true,
    silent = true,
    desc = "Inside math",
    callback = function()
        handle_latex(false, 'visual', math_delimiter_opening, math_delimiter_closing)
    end,
})

vim.api.nvim_buf_set_keymap(0, 'v', 'am', '', {
    noremap = true,
    silent = true,
    desc = "Around math",
    callback = function() handle_latex(true, 'visual', math_delimiter_opening, math_delimiter_closing) end,
})

-- Normal mode
vim.api.nvim_buf_set_keymap(0, 'n', 'dim', '', {
    noremap = true,
    silent = true,
    desc = "Delete inside math",
    callback = function() handle_latex(false, 'delete', math_delimiter_opening, math_delimiter_closing) end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'dam', '', {
    noremap = true,
    silent = true,
    desc = "Delete around math",
    callback = function() handle_latex(true, 'delete', math_delimiter_opening, math_delimiter_closing) end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'cim', '', {
    noremap = true,
    silent = true,
    desc = "Change inside math",
    callback = function() handle_latex(false, 'change', math_delimiter_opening, math_delimiter_closing) end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'cam', '', {
    noremap = true,
    silent = true,
    desc = "Change around math",
    callback = function() handle_latex(true, 'change', math_delimiter_opening, math_delimiter_closing) end,
})

local left_delimiters = {
    "\\left(",        -- Parentheses
    "\\left[",        -- Square brackets
    "\\left{",        -- Curly braces (note: escaped with `\`)
    "\\left.",        -- Empty delimiter (no right delimiter)
    "\\left\\lbrack", -- Alternative square brackets
    "\\left\\lparen", -- Alternative parentheses
    "\\left\\langle", -- Angle brackets
    "\\left|",        -- Single vertical bar
    "\\left\\|",      -- Double vertical bars
    "\\left\\lfloor", -- Floor
    "\\left\\lceil",  -- Ceiling
}

local right_delimiters = {
    "\\right)",        -- Parentheses
    "\\right]",        -- Square brackets
    "\\right}",        -- Curly braces (note: escaped with `\`)
    "\\right.",        -- Empty delimiter (no left delimiter)
    "\\right\\rbrack", -- Alternative square brackets
    "\\right\\rparen", -- Alternative parentheses
    "\\right\\rangle", -- Angle brackets
    "\\right|",        -- Single vertical bar
    "\\right\\|",      -- Double vertical bars
    "\\right\\rfloor", -- Floor
    "\\right\\rceil",  -- Ceiling
}

-- Visual mode
vim.api.nvim_buf_set_keymap(0, 'v', 'id', '', {
    noremap = true,
    silent = true,
    desc = "Inside left right delimiters",
    callback = function() handle_latex(false, 'visual', left_delimiters, right_delimiters) end,
})

vim.api.nvim_buf_set_keymap(0, 'v', 'ad', '', {
    noremap = true,
    silent = true,
    desc = "Around left right delimiters",
    callback = function() handle_latex(true, 'visual', left_delimiters, right_delimiters) end,
})

-- Normal mode
vim.api.nvim_buf_set_keymap(0, 'n', 'did', '', {
    noremap = true,
    silent = true,
    desc = "Delete inside left right delimiters",
    callback = function() handle_latex(false, 'delete', left_delimiters, right_delimiters) end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'dad', '', {
    noremap = true,
    silent = true,
    desc = "Delete around left right delimiters",
    callback = function() handle_latex(true, 'delete', left_delimiters, right_delimiters) end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'cid', '', {
    noremap = true,
    silent = true,
    desc = "Change inside left right delimiters",
    callback = function() handle_latex(false, 'change', left_delimiters, right_delimiters) end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'cad', '', {
    noremap = true,
    silent = true,
    desc = "Change around left right delimiters",
    callback = function() handle_latex(true, 'change', left_delimiters, right_delimiters) end,
})

local get_node_text = vim.treesitter.get_node_text

-- Table of alignment environments to recognize
local ALIGN_ENVS = {
    multline = true,
    eqnarray = true,
    align = true,
    aligned = true,
    array = true,
    split = true,
    alignat = true,
    gather = true,
    flalign = true,
}

---Calculate concealed length at position for a specific line
---@param line_num_1based integer 1-based line number
---@param pos integer 1-based column position
local function get_concealed_line_length(line_num_1based, pos)
    local bufnr = vim.api.nvim_get_current_buf()
    local line_num = line_num_1based - 1 -- Convert to 0-based
    -- Get the character under the cursor
    local line = vim.api.nvim_buf_get_lines(0, line_num, line_num + 1, false)[1]
    local filter = { syntax = false, treesitter = true, extmarks = false, semantic_tokens = false }

    local concealed_length = 0
    local in_conceal = false
    local col = 0
    local metadata = ""

    while col < pos do
        local nodes = vim.inspect_pos(bufnr, line_num, col, filter)
        local is_concealed = false
        local char = line:sub(col + 1, col + 1)

        for _, node_info in ipairs(nodes.treesitter) do
            if (node_info.capture or ''):match('conceal') then
                is_concealed = true
                if not in_conceal or node_info.metadata.conceal ~= metadata or char == "\\" then
                    metadata = node_info.metadata.conceal
                    in_conceal = true
                    concealed_length = concealed_length + (metadata ~= "" and 1 or 0)
                end
                break
            end
        end

        if not is_concealed then
            concealed_length = concealed_length + 1
            metadata = ""
            in_conceal = false
        end
        col = col + 1
    end

    return concealed_length
end

---Check if cursor is in a LaTeX math alignment environment
---@return boolean true if in alignment environment, false otherwise
local function in_align()
    local node = vim.treesitter.get_node({ ignore_injections = false })
    while node do
        if node:type() == "math_environment" then
            local begin = node:child(0)
            local names = begin and begin:field("name")

            if names and names[1] and ALIGN_ENVS[get_node_text(names[1], 0):gsub("{(%w+)%s*%*?}", "%1")] then
                return true
            end
        end
        node = node:parent()
    end
    return false
end

local function get_align_node()
    local node = vim.treesitter.get_node({ ignore_injections = false })
    while node and node:type() ~= "math_environment" do node = node:parent() end
    if not node then return end

    -- Verify environment type
    local begin = node:child(0)
    local names = begin and begin:field("name")
    if not (names and names[1] and ALIGN_ENVS[get_node_text(names[1], 0):gsub("{(%w+)%s*%*?}", "%1")]) then
        return nil
    end

    return node
end

local function normalize_align_environment(s_row, e_row)
    local lines = vim.api.nvim_buf_get_lines(0, s_row, e_row, false)

    -- Normalization-only processing
    local normalized_lines = {}
    for i, line in ipairs(lines) do
        local indent = line:match('^(%s*)') or ''
        local content = line:sub(#indent + 1)

        -- Collapse whitespace around ampersands and multiple spaces
        local processed = content:gsub('%s*&%s*', ' & ') -- Ensure single spaces around &
            :gsub('^%s+', '')                            -- Trim leading spaces
            :gsub('%s+$', '')                            -- Trim trailing spaces
            :gsub('%s+', ' ')                            -- Collapse multiple spaces into one

        normalized_lines[i] = indent .. processed
    end

    vim.api.nvim_buf_set_lines(0, s_row, e_row, false, normalized_lines)
end

local function align_ampersands(s_row, e_row)
    local lines = vim.api.nvim_buf_get_lines(0, s_row, e_row, false)

    -- Find the maximum concealed length before the ampersand
    local max_concealed_length = 0
    for i, line in ipairs(lines) do
        local buf_line = s_row + i
        local and_pos = line:find('&')
        if and_pos then
            local cl = get_concealed_line_length(buf_line, and_pos)
            max_concealed_length = math.max(max_concealed_length, cl)
        end
    end

    -- Apply alignment by adding padding to the head of each line
    local aligned_lines = {}
    for i, line in ipairs(lines) do
        local buf_line = s_row + i
        local and_pos = line:find('&')
        if and_pos then
            local cl = get_concealed_line_length(buf_line, and_pos)
            local padding = string.rep(' ', max_concealed_length - cl)
            -- Insert padding before the ampersand
            local aligned_line = padding .. line
            aligned_lines[i] = aligned_line
        else
            -- If there's no ampersand, keep the line as is
            aligned_lines[i] = line
        end
    end

    vim.api.nvim_buf_set_lines(0, s_row, e_row, false, aligned_lines)
end

-- Inserts a new line with proper alignment characters when in math environment
vim.keymap.set('i', '<CR>', function()
    if not in_align() then
        return "<CR>"
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1] - 1 -- Convert to 0-based index
    local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
    if cursor[2] ~= #line then
        return "<CR>"
    end

    local and_pos = line:find('&')
    if not and_pos then
        return "<CR>"
    end

    -- Exit Insert mode first
    local escape = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
    vim.api.nvim_feedkeys(escape, 'n', true)

    -- Schedule buffer modifications after exiting Insert mode
    vim.schedule(function()
        local offset = and_pos - get_concealed_line_length(cursor[1], and_pos)
        -- vim.api.nvim_echo({ { tostring(offset) } }, true, {})
        -- Calculate indent and create new line
        local indent = line:sub(1, and_pos - 1)
        indent = indent:gsub("[^ \t]", " ")
        indent = indent:sub(1, -(offset + 1))
        local new_line = indent .. '& \\\\'

        -- Insert the new line below the current line
        vim.api.nvim_buf_set_lines(0, row + 1, row + 1, true, { new_line })

        -- Move cursor to the new line and position after '&'
        vim.api.nvim_win_set_cursor(0, { row + 2, #indent })
        vim.api.nvim_feedkeys('a', 'n', false) -- Enter Insert mode after '&'
    end)

    -- Return nothing to prevent default <CR> behavior
    return ""
end, {
    expr = true,
    buffer = 0,
    noremap = true,
    silent = true,
    desc = "Insert new aligned line in LaTeX environment"
})

-- Keymap to trigger alignment
vim.keymap.set('n', '<leader>la', function()
    -- Get node and range first before any modifications
    local node = get_align_node()
    if not node then return end
    local s_row, _, e_row, _ = node:range()

    -- Wrap alignment in schedule to ensure buffer updates are processed
    local align = vim.schedule_wrap(function()
        align_ampersands(s_row, e_row)
    end)

    -- First normalization using captured range
    normalize_align_environment(s_row, e_row)

    align()
end, {
    buffer = 0,
    desc = 'Align & symbols in LaTeX environment with conceal awareness'
})

-- Inserts a new line with proper alignment characters when in math environment
vim.keymap.set('n', 'o', function()
    if not in_align() then
        return "o"
    end

    local cursor = vim.api.nvim_win_get_cursor(0)
    local row = cursor[1] - 1 -- Convert to 0-based index
    local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
    local indent = string.match(line, "^%s*")

    -- Exit Insert mode first
    local escape = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
    vim.api.nvim_feedkeys(escape, 'n', true)

    -- Schedule buffer modifications after exiting Insert mode
    vim.schedule(function()
        local new_line = indent .. ' \\\\'

        -- Insert the new line below the current line
        vim.api.nvim_buf_set_lines(0, row + 1, row + 1, true, { new_line })

        -- Move cursor to the new line and position after '&'
        vim.api.nvim_win_set_cursor(0, { row + 2, #indent })
        vim.api.nvim_feedkeys('i', 'n', false) -- Enter Insert mode after '&'
    end)

    return ""
end, {
    expr = true,
    buffer = 0,
    noremap = true,
    silent = true,
    desc = "Insert new aligned line in LaTeX environment"
})

-- local function align_ampersands(s_row, e_row)
--     local lines = vim.api.nvim_buf_get_lines(0, s_row, e_row, false)
--     local lines_data = {} -- Stores segments, concealed lengths, and ampersand counts per line
--     local max_columns = 0 -- Track the maximum number of ampersands in any line
--
--     -- First pass: collect ampersand positions and split lines into segments
--     for i, line in ipairs(lines) do
--         local buf_line = s_row + i - 1 -- Buffer line number (0-based)
--         local and_positions = {}
--
--         -- Find all ampersand positions in the current line
--         local current_pos = 1
--         while true do
--             local pos = line:find('&', current_pos)
--             if not pos then break end
--             table.insert(and_positions, pos)
--             current_pos = pos + 1
--         end
--
--         -- Split the line into segments around each ampersand
--         local segments = {}
--         local prev_pos = 1
--         for _, pos in ipairs(and_positions) do
--             table.insert(segments, line:sub(prev_pos, pos - 1))
--             prev_pos = pos + 1
--         end
--         table.insert(segments, line:sub(prev_pos)) -- Add the remaining part after last &
--
--         -- Calculate concealed length before each ampersand
--         local cls = {}
--         for _, pos in ipairs(and_positions) do
--             local cl = get_concealed_line_length(buf_line, pos)
--             table.insert(cls, cl)
--         end
--
--         -- Update lines_data and max_columns
--         lines_data[i] = {
--             segments = segments,
--             cls = cls,
--             num_amps = #and_positions,
--         }
--         max_columns = math.max(max_columns, #and_positions)
--     end
--
--     -- Determine maximum concealed length for each column
--     local max_cl_per_column = {}
--     for col = 1, max_columns do
--         max_cl_per_column[col] = 0
--         for _, data in ipairs(lines_data) do
--             if data.cls[col] and data.cls[col] > max_cl_per_column[col] then
--                 max_cl_per_column[col] = data.cls[col]
--             end
--         end
--     end
--
--     -- Build aligned lines by applying padding to each segment
--     local aligned_lines = {}
--     for _, data in ipairs(lines_data) do
--         local aligned_line = ""
--         for col = 1, data.num_amps do
--             local segment = data.segments[col]
--             local padding = max_cl_per_column[col] - data.cls[col]
--             aligned_line = aligned_line .. string.rep(' ', padding) .. segment .. '&'
--         end
--         aligned_line = aligned_line .. data.segments[data.num_amps + 1] -- Add last segment
--         table.insert(aligned_lines, aligned_line)
--     end
--
--     -- Update the buffer with aligned lines
--     vim.api.nvim_buf_set_lines(0, s_row, e_row, false, aligned_lines)
-- end
