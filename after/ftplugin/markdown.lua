local opt = vim.opt_local

opt.matchpairs = { "(:)", "[:]", "{:}" }
opt.commentstring = "<!-- %s -->"
opt.formatoptions = "qnjl"
opt.textwidth = 100

vim.api.nvim_buf_set_keymap(0, "n", "<C-j>", "[s1z=", { desc = "Crect Last Spelling" })

vim.api.nvim_buf_create_user_command(0, "FixInlineMath", function()
    vim.cmd("%s/\\\\(\\s*/$/ge")
    vim.cmd("%s/\\s*\\\\)/$/ge")
    vim.cmd("nohlsearch") -- Clear search highlight
end, {})

vim.api.nvim_buf_create_user_command(0, "FixDisplayMath", function()
    vim.cmd("%s/\\\\\\[/$$/ge")
    vim.cmd("%s/\\\\\\]/$$/ge")
    vim.cmd("nohlsearch") -- Clear search highlight
end, {})

vim.api.nvim_buf_create_user_command(0, "FixMathFormat", function()
    vim.cmd([[%s/^\$\$\n\(\_.\{-}\)\n\$\$/\r$$\1$$\r/ge]])
    vim.cmd([[%s/\v(\s*)\$\$(\n)\s*(\S.*)\n\s*\$\$/\1\2\1$$\3$$\r\1/ge]])
    vim.cmd("nohlsearch") -- Clear search highlight
end, {})

vim.api.nvim_buf_create_user_command(0, "FixMath", function()
    vim.cmd("%s/\\\\(\\s*/$/ge")
    vim.cmd("%s/\\s*\\\\)/$/ge")
    vim.cmd("%s/\\\\\\[/$$/ge")
    vim.cmd("%s/\\\\\\]/$$/ge")
    vim.cmd([[%s/^\$\$\n\(\_.\{-}\)\n\$\$/\r$$\1$$\r/ge]])
    vim.cmd([[%s/\v(\s*)\$\$(\n)\s*(\S.*)\n\s*\$\$/\1\2\1$$\3$$\r\1/ge]])
    vim.cmd("nohlsearch") -- Clear search highlight
end, {})

-- Yank URL-friendly format of the current line
function YankURLFriendly()
    local line = vim.api.nvim_get_current_line()
    line = line:gsub("[^%w%s]", " ")       -- Replace special characters with spaces
    line = line:gsub("^%s*(.-)%s*$", "%1") -- Remove leading/trailing whitespace
    line = line:gsub("%s+", "-")           -- Replace spaces with hyphens
    line = line:lower()                    -- Convert to lowercase

    vim.cmd('normal! yy')                  -- Manually trigger yank highlight
    vim.fn.setreg('0', line)               -- Yank the result into the 0 register
    vim.fn.setreg('"', line)               -- Yank the result into the " register
    vim.fn.setreg('+', line)               -- Yank the result into the + register
end

-- Map the function to 'yu' in normal mode with a description
vim.api.nvim_buf_set_keymap(0, 'n', '<leader>yu', '', {
    noremap = true, -- Disable recursive mapping
    silent = true,  -- Suppress command feedback
    desc = "Yank URL-friendly format of the current line",
    callback = function()
        YankURLFriendly()
    end
})

-- Custom gf with title search support
---@return string
---@param title string
local function normalize_title(title)
    -- Remove leading/trailing whitespace
    title = title:gsub('^%s*(.-)%s*$', '%1')
    -- Replace hyphens and spaces with nothing
    title = title:gsub('[- ]', '')
    -- Remove special characters (e.g., $, \, etc.)
    title = title:gsub('[^%w]', '')
    -- Convert to lowercase for case-insensitive matching
    return title:lower()
end

-- Fuzzy match implementation from scratch
---@param pattern string The pattern to match (e.g., normalized title)
---@param text string The text to search in (e.g., normalized header)
---@return boolean True if the pattern fuzzy matches the text, false otherwise
local function fuzzy_match(pattern, text)
    local pattern_len = #pattern
    local pattern_idx = 1

    for i = 1, #text do
        if text:sub(i, i) == pattern:sub(pattern_idx, pattern_idx) then
            pattern_idx = pattern_idx + 1
            if pattern_idx > pattern_len then
                return true
            end
        end
    end
    return false
end

local function expand_env_vars(path)
    return path:gsub('%$([%w_]+)', function(env_var)
        return os.getenv(env_var) or ''
    end)
end

local function custom_gf()
    local file_with_title = vim.fn.expand('<cfile>')
    local parts = vim.split(file_with_title, '#')
    local file = expand_env_vars(parts[1])
    local title = parts[2] or ''

    if vim.fn.filereadable(file) == 1 or file == "" then
        local is_marked = false
        if file ~= "" then
            vim.cmd('edit ' .. file)
            is_marked = true
        end
        if title ~= '' then
            -- Normalize the URL-friendly title
            local normalized_title = normalize_title(title)

            -- Save the initial cursor position
            local initial_line = vim.fn.line('.')
            local initial_col = vim.fn.col('.')

            if not is_marked then
                -- Create a jump point before moving the cursor if have not been marked
                vim.cmd('normal! m\'')
            end

            -- Search for the first header that fuzzy matches the normalized title
            local found = false
            -- Move the cursor to the start of the file
            vim.fn.cursor(1, 1)

            while vim.fn.search('^\\s*#\\+\\s*\\zs.*', 'W') ~= 0 do
                local header = vim.fn.getline('.')
                local normalized_header = normalize_title(header)

                -- Use fuzzy matching to compare the title and header
                if fuzzy_match(normalized_title, normalized_header) then
                    found = true
                    break
                end
            end

            -- If no match is found, restore the cursor to the initial position
            if not found then
                vim.fn.cursor(initial_line, initial_col)
                vim.api.nvim_echo({ { 'No match found for title: ' .. title, 'WarningMsg' } }, true, {})
            end
        end
    else
        vim.api.nvim_echo({ { "File not found: " .. file, "WarningMsg" } }, true, {})
    end
end

vim.api.nvim_buf_set_keymap(0, 'n', 'gf', '', {
    noremap = true,
    silent = true,
    desc = "Custom go to file under cursor",
    callback = function()
        custom_gf()
    end
})

-- Alias configuration: {target_char = {'alias1', 'alias2'}}
local aliases = {
    ['$'] = { 'm' },
    ['*'] = { 'k' },
}

-- Create mappings for each character and its aliases
for target, alias_list in pairs(aliases) do
    -- Include original character in mappings
    local chars = { target }
    -- Add aliases to the list of characters to map
    vim.list_extend(chars, alias_list)

    for _, char in ipairs(chars) do
        -- Visual mode mappings
        vim.api.nvim_buf_set_keymap(
            0,
            "v",
            "i" .. char,
            string.format(":<C-u>normal! T%svt%s<CR>", target, target),
            { noremap = true, silent = true, desc = "Inside " .. target .. " text object" }
        )
        vim.api.nvim_buf_set_keymap(
            0,
            "v",
            "a" .. char,
            string.format(":<C-u>normal! F%svf%s<CR>", target, target),
            { noremap = true, silent = true, desc = "Around " .. target .. " text object" }
        )

        -- Normal mode mappings
        local normal_mappings = {
            ["di" .. char] = "T%svt%sd<CR>",
            ["da" .. char] = "F%svf%sd<CR>",
            ["ci" .. char] = "T%svt%sd<CR>i",
            ["ca" .. char] = "F%svf%sd<CR>i"
        }

        for lhs, rhs_pattern in pairs(normal_mappings) do
            local action = lhs:sub(1, 1) == "d" and "Delete" or "Change"
            local scope = lhs:sub(2, 2) == "i" and "inside" or "around"
            vim.api.nvim_buf_set_keymap(
                0,
                "n",
                lhs,
                string.format(":<C-u>normal! %s", rhs_pattern):format(target, target),
                { noremap = true, silent = true, desc = action .. " " .. scope .. " " .. target }
            )
        end
    end
end

-- Special handling for quote alias 'q'
local function find_quote_pair(around)
    local line = vim.api.nvim_get_current_line()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- row (1-based), col (0-based)
    local quotes = { '"', "'", '`' }

    -- Find nearest opening quote before cursor
    local start_quote, start_pos = nil, nil
    for i = col, 0, -1 do
        local c = line:sub(i + 1, i + 1)
        if vim.tbl_contains(quotes, c) then
            start_quote = c
            start_pos = i
            break
        end
    end
    if not start_quote then return end

    -- Find matching closing quote after cursor
    local end_pos = nil
    for i = start_pos + 1, #line do
        if line:sub(i + 1, i + 1) == start_quote then
            end_pos = i
            break
        end
    end
    if not end_pos then return end

    -- Verify cursor is between quotes
    if col < start_pos or col > end_pos then return end

    -- Calculate positions based on 'around' flag
    return {
        start = around and start_pos or (start_pos + 1),
        finish = around and end_pos or (end_pos - 1)
    }
end

local function handle_quote(around, mode)
    local pos = find_quote_pair(around)
    if not pos then return end

    local lnum = vim.fn.line('.') - 1 -- 0-based line number
    local start_col = pos.start
    local end_col = pos.finish + 1    -- API uses exclusive end

    if mode == 'visual' then
        vim.cmd('normal! \x1b')
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

-- Quote mappings using anonymous functions
vim.api.nvim_buf_set_keymap(0, 'v', 'iq', '', {
    noremap = true,
    silent = true,
    desc = "Inside quote text object",
    callback = function()
        handle_quote(false, "visual")
    end,
})

vim.api.nvim_buf_set_keymap(0, 'v', 'aq', '', {
    noremap = true,
    silent = true,
    desc = "Around quote text object",
    callback = function()
        handle_quote(true, "visual")
    end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'diq', '', {
    noremap = true,
    silent = true,
    desc = "Delete inside quote",
    callback = function()
        handle_quote(false, "delete")
    end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'daq', '', {
    noremap = true,
    silent = true,
    desc = "Delete around quote",
    callback = function()
        handle_quote(true, "delete")
    end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'ciq', '', {
    noremap = true,
    silent = true,
    desc = "Change inside quote",
    callback = function()
        handle_quote(false, "change")
    end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'caq', '', {
    noremap = true,
    silent = true,
    desc = "Change around quote",
    callback = function()
        handle_quote(true, "change")
    end,
})

local function find_latex_pair(around, opening_delims, closing_delims)
    local line = vim.api.nvim_get_current_line()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))

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

local minor_words = {
    -- Articles
    'a', 'an', 'the',
    -- Conjunctions
    'and', 'but', 'or', 'nor', 'for', 'yet', 'so', 'if',
    -- Long conjunctions
    -- 'because', 'although', 'though', 'while', 'whereas', 'whether', 'unless',
    -- Prepositions
    'as', 'at', 'by', 'in', 'of', 'on', 'to', 'up', 'via',
    -- Prepositions with length >= 4 are considered to be major words, "off" and "out" their grammar role are tricky to determine
    -- 'with', 'about', 'above', 'across', 'after', 'against', 'along', 'among', 'around', 'before', 'behind', 'below', 'beneath', 'beside', 'between', 'beyond', 'concerning', 'despite', 'down', 'during', 'except', 'from', 'inside', 'into', 'like', 'near', 'onto', 'out', 'outside', 'over', 'past', 'since', 'through', 'toward', 'under', 'underneath', 'until', 'unto', 'upon', 'within', 'without',
    -- Short auxiliary verbs
    'is', 'am', 'are', 'be', 'been', 'being', 'was', 'were', 'has', 'have', 'had', 'do', 'does', 'did',
    -- Modal auxiliary verbs
    -- 'can', 'could', 'may', 'might', 'must', 'shall', 'should', 'will', 'would', 'it', 'he', 'she', 'they', 'we', 'you'
}

local function get_spell_regions(bufnr, start_line, end_line)
    local regions = {}

    -- Original region detection logic
    for line = start_line, end_line do
        local row = line - 1
        local line_text = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ''
        local max_col = #line_text

        local current_start = nil

        for col = 0, max_col do
            local pos_info = vim.inspect_pos(
                bufnr,
                row,
                col,
                { treesitter = true, syntax = false, extmarks = false, semantic_tokens = false }
            )

            local has_spell = false
            local has_nospell = false
            local is_space = false

            if pos_info.treesitter == {} then
                is_space = true
            else
                for _, capture in ipairs(pos_info.treesitter) do
                    if capture.capture == 'spell' then
                        has_spell = true
                    elseif capture.capture == 'nospell' then
                        has_nospell = true
                    end
                end
            end

            if is_space or (has_spell and not has_nospell) then
                current_start = current_start or col
            else
                if current_start then
                    table.insert(regions, {
                        start_line = line,
                        start_col = current_start + 1,
                        end_line = line,
                        end_col = col + 1
                    })
                    current_start = nil
                end
            end
        end

        if current_start then
            table.insert(regions, {
                start_line = line,
                start_col = current_start + 1,
                end_line = line,
                end_col = max_col + 2
            })
        end
    end

    -- Split regions into sentences
    local new_regions = {}
    local current_sentence = 1

    for _, region in ipairs(regions) do
        local line = region.start_line
        local s_col = region.start_col
        local e_col = region.end_col
        local row = line - 1
        local line_text = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ''
        local substring = line_text:sub(s_col, e_col - 1)

        local split_positions = {}
        for i = 1, #substring - 1 do
            local c = substring:sub(i, i)
            if c == '.' or c == '!' or c == '?' then
                table.insert(split_positions, i)
            end
        end

        local current_split_start = s_col
        for _, split_pos in ipairs(split_positions) do
            local split_point = s_col + split_pos - 1
            local sub_end = split_point + 1
            table.insert(new_regions, {
                start_line = line,
                start_col = current_split_start,
                end_line = line,
                end_col = sub_end,
                sentence = current_sentence
            })
            current_split_start = sub_end
            current_sentence = current_sentence + 1
        end

        if current_split_start < e_col then
            table.insert(new_regions, {
                start_line = line,
                start_col = current_split_start,
                end_line = line,
                end_col = e_col,
                sentence = current_sentence
            })
        end
    end

    return new_regions
end

local function capitalize(word)
    if word:find('-') then
        return word:gsub('(%w+)(%-?)(%w*)', function(a, sep, b)
            return a:sub(1, 1):upper() .. a:sub(2) .. sep .. (b ~= '' and b:sub(1, 1):upper() .. b:sub(2) or '')
        end)
    end
    return word:sub(1, 1):upper() .. word:sub(2)
end

local function title_case_word(word)
    if word:match('^%W*$') then return word end

    if word:find('-') then
        return word:gsub('(%w+)(%-?)(%w*)', function(a, sep, b)
            return capitalize(a) .. sep .. (b ~= '' and capitalize(b) or '')
        end)
    end

    return vim.tbl_contains(minor_words, word:lower()) and word:lower() or capitalize(word)
end

local function process_text(text, is_first_in_sentence, is_last_in_sentence)
    local leading_spaces = text:match('^%s*') or ''
    local trailing_spaces = text:match('%s*$') or ''

    local words = {}
    for word in text:gmatch('%S+') do
        local prefix = word:match('^(%p+)')
        local suffix = word:match('(%p+)$')
        local core = word:sub((prefix and #prefix or 0) + 1, suffix and -(#suffix + 1) or nil)

        table.insert(words, {
            prefix = prefix or '',
            core = core,
            suffix = suffix or ''
        })
    end

    local processed = {}
    for i, parts in ipairs(words) do
        local prev = words[i - 1]
        local is_first = i == 1
        local is_last = i == #words
        local core = parts.core

        if is_first_in_sentence and is_first then
            core = capitalize(core)
        elseif is_last_in_sentence and is_last then
            core = capitalize(core)
        else
            if prev and (prev.suffix:match('[:%-]$') or prev.core:match('[:%-]$')) then
                core = capitalize(core)
            else
                core = title_case_word(core)
            end
        end

        -- In case the parts = ? then only need add prefix
        if parts.core == "" and parts.prefix == parts.suffix then
            processed[i] = parts.prefix
        else
            processed[i] = parts.prefix .. core .. parts.suffix
        end
    end

    return leading_spaces .. table.concat(processed, ' ') .. trailing_spaces
end

local function process_lines(start_line, end_line)
    local bufnr = vim.api.nvim_get_current_buf()
    local regions = get_spell_regions(bufnr, start_line, end_line)
    local lines = vim.api.nvim_buf_get_lines(bufnr, start_line - 1, end_line, false)

    -- Group regions by line and sort columns
    local regions_by_line = {}
    for _, region in ipairs(regions) do
        local line = region.start_line
        if not regions_by_line[line] then
            regions_by_line[line] = {}
        end
        table.insert(regions_by_line[line], region)
    end

    -- Process each line with proper interval handling
    for line_idx = start_line, end_line do
        local line_regions = regions_by_line[line_idx] or {}
        local original_line = lines[line_idx - start_line + 1]
        local max_col = #original_line

        -- Sort regions by start column
        table.sort(line_regions, function(a, b)
            return a.start_col < b.start_col
        end)

        -- Build intervals covering the entire line
        local intervals = {}
        local prev_end = 0

        -- Add spell regions and interspersed non-spell regions
        for _, reg in ipairs(line_regions) do
            local start = reg.start_col - 1 -- Convert to 0-based
            local end_col = reg.end_col - 1 -- Convert to 0-based (exclusive)

            -- Add non-spell region before this spell region
            if start > prev_end then
                table.insert(intervals, {
                    start = prev_end,
                    ["end"] = start,
                    type = "non-spell",
                    sentence = reg.sentence
                })
            end

            -- Add spell region
            table.insert(intervals, {
                start = start,
                ["end"] = end_col,
                type = "spell",
                sentence = reg.sentence
            })
            prev_end = end_col
        end

        -- Add final non-spell region if needed
        if prev_end < max_col then
            table.insert(intervals, {
                start = prev_end,
                ["end"] = max_col,
                type = "non-spell",
                sentence = line_regions[#line_regions] and line_regions[#line_regions].sentence or 1
            })
        end

        -- Group intervals by sentence
        local intervals_by_sentence = {}
        for _, interval in ipairs(intervals) do
            local sentence = interval.sentence
            if not intervals_by_sentence[sentence] then
                intervals_by_sentence[sentence] = {}
            end
            table.insert(intervals_by_sentence[sentence], interval)
        end

        -- Process each sentence
        local parts = {}
        for _, sentence_intervals in pairs(intervals_by_sentence) do
            local is_first_in_sentence = true
            for i, interval in ipairs(sentence_intervals) do
                local text = original_line:sub(interval.start + 1, interval["end"])
                local is_last_in_sentence = i == #sentence_intervals
                if i == 1 and string.match(text, "^%s*#+%s*$") and interval.type == "non-spell" then
                    table.insert(parts, text)
                else
                    if interval.type == "spell" then
                        text = process_text(text, is_first_in_sentence, is_last_in_sentence)
                    end
                    table.insert(parts, text)
                    is_first_in_sentence = false
                end
            end
        end

        -- Rebuild the line
        lines[line_idx - start_line + 1] = table.concat(parts)
    end

    vim.api.nvim_buf_set_lines(bufnr, start_line - 1, end_line, false, lines)
end

-- Normal mode mapping (gll): Convert current line to title case
vim.api.nvim_buf_set_keymap(0, 'n', 'gll', '', {
    noremap = true,
    silent = true,
    desc = "Convert current line to title case",
    callback = function()
        local start_line = vim.fn.line('.')
        local end_line = vim.fn.line('.')
        process_lines(start_line, end_line) -- Assuming process_lines handles title case conversion
    end,
})

-- Visual mode mapping (gl): Convert selected lines to title case
vim.api.nvim_buf_set_keymap(0, 'x', 'gl', '', {
    noremap = true,
    silent = true,
    desc = "Convert selected lines to title case",
    callback = function()
        local start_line = vim.fn.line('v')
        local end_line = vim.fn.line('.')
        for line = math.min(start_line, end_line), math.max(start_line, end_line) do
            process_lines(line, line)
        end
        vim.cmd("normal! \x1b")
    end,
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

---@param pos integer
local function get_concealed_line_length(pos)
    local bufnr = vim.api.nvim_get_current_buf()
    local line_num_1based = vim.fn.line('.')
    local line_num = line_num_1based - 1 -- Convert to 0-based

    -- Explicit filter configuration
    local filter = {
        syntax = false,         -- Disable syntax highlighting inspection
        treesitter = true,      -- Enable Tree-sitter nodes
        extmarks = false,       -- Disable extmarks
        semantic_tokens = false -- Disable LSP semantic tokens
    }

    local concealed_length = 0
    local in_conceal_region = false
    local col = 0

    while col < pos do
        -- Get Tree-sitter nodes at the current position
        local nodes = vim.inspect_pos(bufnr, line_num, col, filter)

        -- local nodes_str = vim.inspect(nodes)
        -- vim.api.nvim_echo({ { nodes_str } }, false, {})

        local is_concealed = false

        for _, node_info in ipairs(nodes.treesitter) do
            local capture_name = node_info.capture or ''
            if capture_name:match('conceal') then
                is_concealed = true
                if not in_conceal_region then
                    in_conceal_region = true
                    local metadata = node_info.metadata.conceal or ""
                    if metadata ~= "" then
                        concealed_length = concealed_length + 1
                    end
                end
                break
            end
        end

        if not is_concealed then
            concealed_length = concealed_length + 1
            in_conceal_region = false
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
        local offset = and_pos - get_concealed_line_length(and_pos)
        -- vim.api.nvim_echo({ { tostring(offset) } }, true, {})
        -- Calculate indent and create new line
        local indent = line:sub(1, and_pos - 1)
        indent = indent:gsub("[^ \t]", " ")
        indent = indent:sub(1, -(offset + 1))
        local new_line = indent .. '&'

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
