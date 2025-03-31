local fzf = require("fzf-lua")
local opt = vim.opt_local

opt.tabstop = 2
opt.shiftwidth = 2
opt.softtabstop = 2
opt.matchpairs = { "(:)", "[:]", "{:}" }
opt.commentstring = "<!-- %s -->"
opt.formatoptions = "qnjl"
opt.textwidth = 80

vim.api.nvim_buf_set_keymap(0, "n", "<C-j>", "[s1z=", { desc = "Crect Last Spelling" })

vim.keymap.set({ "n", "v" }, 'g>', [[:s/^/> /<CR>:nohlsearch<CR>]], {
    noremap = true,
    silent = true,
    desc = "Add '> ' prefix to selected lines"
})

vim.api.nvim_buf_create_user_command(0, "FixMath", function()
    -- vim.cmd("%s/\\\\(\\s\\+/$/ge")
    -- vim.cmd("%s/\\s\\+\\\\)/$/ge")
    vim.cmd("%s/\\\\(\\s*/$/ge")
    vim.cmd("%s/\\s*\\\\)/$/ge")
    vim.cmd("%s/\\\\\\[/$$/ge")
    vim.cmd("%s/\\\\\\]/$$/ge")
    vim.cmd([[%s/^\$\$\n\(\_.\{-}\)\n\$\$/\r$$\1$$\r/ge]])
    vim.cmd([[%s/\v(\s*)\$\$(\n)\s*(\S.*)\n\s*\$\$/\1\2\1$$\3$$\r\1/ge]])
    vim.cmd("nohlsearch") -- Clear search highlight
end, {})

local function GetHeading()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor_pos[1], cursor_pos[2] -- row (1-based), col (0-based)

    local pos_info = vim.inspect_pos(
        bufnr,
        row - 1,
        col,
        { treesitter = true, syntax = false, extmarks = false, semantic_tokens = false }
    )

    if not pos_info.treesitter then return false end

    local is_heading = false

    for _, node in ipairs(pos_info.treesitter) do
        if node.capture:match("^markup%.heading") then
            is_heading = true
            break
        end
        if node.capture:match("comment") then
            local heading = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
            if heading:match("^<!%-%-%s+#+") then
                is_heading = true
                break
            end
        end
    end

    if is_heading then
        local heading = vim.api.nvim_buf_get_lines(0, row - 1, row, false)[1]
        heading = heading:gsub("^<!%-%-%s+", ""):gsub("%s+%-%->$", ""):gsub("^#+%s+", "")
        return heading
    end
end

local function GetLink()
    local bufnr = vim.api.nvim_get_current_buf()
    local cursor_pos = vim.api.nvim_win_get_cursor(0)
    local row, col = cursor_pos[1], cursor_pos[2] -- row (1-based), col (0-based)

    local pos_info = vim.inspect_pos(
        bufnr,
        row - 1,
        col,
        { treesitter = true, syntax = false, extmarks = false, semantic_tokens = false }
    )

    if not pos_info.treesitter then return false end

    local is_strong = false

    for _, node in ipairs(pos_info.treesitter) do
        if node.capture == "markup.strong" then
            is_strong = true
            break
        end
    end

    if not is_strong then return false end

    -- Search backward for opening '**' (returns {lnum, col, 0})
    local open_pos = vim.fn.searchpos('\\*\\*', 'bcnW')
    if open_pos[1] == 0 then return false end -- No opening found

    -- Extract line and column from the position tuple
    local open_lnum, open_col = open_pos[1], open_pos[2]

    local close_pos = vim.fn.searchpos('\\*\\*', 'cnW')
    if close_pos[1] == 0 then return false end -- No closing found

    local close_lnum, close_col = close_pos[1], close_pos[2] + 1

    -- Check if the cursor is between the opening and closing '**'
    local cursor_pos_1based = { row, col + 1 } -- Convert to 1-based column
    local is_inside = (cursor_pos_1based[1] > open_lnum or (cursor_pos_1based[1] == open_lnum and cursor_pos_1based[2] > open_col + 1)) and
        (cursor_pos_1based[1] < close_lnum or (cursor_pos_1based[1] == close_lnum and cursor_pos_1based[2] < close_col - 1))

    if not is_inside then return false end

    -- Extract text between the opening and closing '**'
    local lines = vim.api.nvim_buf_get_lines(0, open_lnum - 1, close_lnum, false)
    if #lines == 0 then return false end

    -- Calculate start and end positions (1-based to Lua's 1-based strings)
    local start_char = open_col + 2 -- Skip the opening '**'

    local end_line_idx = #lines
    local end_char = close_col - 2 -- Stop before the closing '**'

    -- Adjust for single-line vs multi-line
    local parts = {}
    if open_lnum == close_lnum then
        -- Single line: extract substring directly
        parts[1] = lines[1]:sub(start_char, end_char)
    else
        -- Multi-line: handle first line, middle lines, and last line
        parts[1] = lines[1]:sub(start_char)
        for i = 2, end_line_idx - 1 do
            parts[#parts + 1] = lines[i]
        end
        parts[#parts + 1] = lines[end_line_idx]:sub(1, end_char)
    end

    local bold_text = table.concat(parts, ' ')
    return bold_text ~= '' and bold_text or false
end

local function GetPath()
    -- Get the current line and cursor position
    local line = vim.api.nvim_get_current_line()
    local col = vim.api.nvim_win_get_cursor(0)[2] + 1 -- Lua is 1-indexed

    -- Find all pairs of backticks in the line
    local backtick_pairs = {}
    for i = 1, #line do
        if line:sub(i, i) == '`' then
            table.insert(backtick_pairs, i)
        end
    end

    -- Check if the cursor is inside a pair of backticks
    for i = 1, #backtick_pairs - 1, 2 do
        local start = backtick_pairs[i]
        local finish = backtick_pairs[i + 1]
        if col > start and col < finish then
            -- Extract and return the text inside the backticks
            return line:sub(start + 1, finish - 1)
        end
    end

    -- If not inside backticks, return nil
    return false
end

vim.api.nvim_buf_set_keymap(0, 'n', 'grr', '', {
    desc = "Go to References",
    callback = function()
        local heading = GetHeading()
        if heading then
            fzf.grep({
                search = "**" .. heading .. "**",
                no_esc = false,
                rg_opts =
                "--column --line-number --no-heading --color=always --ignore-case --type=md --max-columns=4096 -e"
            })
        end
    end,
})

vim.api.nvim_buf_set_keymap(0, 'n', '<C-]>', '', {
    desc = "Jump to definition",
    callback = function()
        local link = GetLink()
        if link then
            fzf.grep({
                search = "^(<!-- )?#+\\s+"
                    .. link:gsub("([%$%(%))%.%+%*%?%[%]%^%|\\%-%{}])", "\\%1"):gsub("%s+", " "),
                no_esc = true,
                rg_opts =
                "--column --line-number --no-heading --color=always --ignore-case --type=md --max-columns=4096 -e"
            })
        end
    end,
})

vim.api.nvim_buf_set_keymap(0, 'n', 'gf', '', {
    desc = "Go to File",
    callback = function()
        local path = GetPath()
        if path then
            fzf.files({
                query = path,
            })
        else
            vim.api.nvim_feedkeys("gf", "n", false)
        end
    end,
})

vim.api.nvim_buf_set_keymap(0, 'n', '<2-LeftMouse>', '', {
    desc = "Go to",
    callback = function()
        local link = GetLink()
        if link then
            fzf.grep({
                search = "^(<!-- )?#+\\s+"
                    .. link:gsub("([%$%(%))%.%+%*%?%[%]%^%|\\%-%{}])", "\\%1"):gsub("%s+", " "),
                no_esc = true,
                rg_opts =
                "--column --line-number --no-heading --color=always --ignore-case --type=md --max-columns=4096 -e"
            })
            return true
        end
        local path = GetPath()
        if path then
            fzf.files({
                query = path,
            })
            return true
        end
        local heading = GetHeading()
        if heading then
            fzf.grep({
                search = "**" .. heading .. "**",
                no_esc = false,
                rg_opts =
                "--column --line-number --no-heading --color=always --ignore-case --type=md --max-columns=4096 -e"
            })
            return true
        end
        return false
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

-- Special handling for quote alias 'q'
-- local function find_quote_pair(around)
--     local line = vim.api.nvim_get_current_line()
--     local row, col = unpack(vim.api.nvim_win_get_cursor(0)) -- row (1-based), col (0-based)
--     local quotes = { '"', "'", '`' }
--
--     -- Find nearest opening quote before cursor
--     local start_quote, start_pos = nil, nil
--     for i = col, 0, -1 do
--         local c = line:sub(i + 1, i + 1)
--         if vim.tbl_contains(quotes, c) then
--             start_quote = c
--             start_pos = i
--             break
--         end
--     end
--     if not start_quote then return end
--
--     -- Find matching closing quote after cursor
--     local end_pos = nil
--     for i = start_pos + 1, #line do
--         if line:sub(i + 1, i + 1) == start_quote then
--             end_pos = i
--             break
--         end
--     end
--     if not end_pos then return end
--
--     -- Verify cursor is between quotes
--     if col < start_pos or col > end_pos then return end
--
--     -- Calculate positions based on 'around' flag
--     return {
--         start = around and start_pos or (start_pos + 1),
--         finish = around and end_pos or (end_pos - 1)
--     }
-- end
--
-- local function handle_quote(around, mode)
--     local pos = find_quote_pair(around)
--     if not pos then return end
--
--     local lnum = vim.fn.line('.') - 1 -- 0-based line number
--     local start_col = pos.start
--     local end_col = pos.finish + 1    -- API uses exclusive end
--
--     if mode == 'visual' then
--         vim.cmd('normal! \x1b')
--         vim.api.nvim_win_set_cursor(0, { vim.fn.line('.'), start_col })
--         vim.cmd('normal! v')
--         vim.api.nvim_win_set_cursor(0, { vim.fn.line('.'), pos.finish })
--     elseif mode == 'delete' then
--         vim.api.nvim_buf_set_text(0, lnum, start_col, lnum, end_col, {})
--     elseif mode == 'change' then
--         vim.api.nvim_buf_set_text(0, lnum, start_col, lnum, end_col, {})
--         vim.cmd('startinsert')
--     end
-- end

-- Quote mappings using anonymous functions
-- vim.api.nvim_buf_set_keymap(0, 'v', 'iq', '', {
--     noremap = true,
--     silent = true,
--     desc = "Inside quote text object",
--     callback = function()
--         handle_quote(false, "visual")
--     end,
-- })
--
-- vim.api.nvim_buf_set_keymap(0, 'v', 'aq', '', {
--     noremap = true,
--     silent = true,
--     desc = "Around quote text object",
--     callback = function()
--         handle_quote(true, "visual")
--     end,
-- })
--
-- vim.api.nvim_buf_set_keymap(0, 'n', 'diq', '', {
--     noremap = true,
--     silent = true,
--     desc = "Delete inside quote",
--     callback = function()
--         handle_quote(false, "delete")
--     end,
-- })
--
-- vim.api.nvim_buf_set_keymap(0, 'n', 'daq', '', {
--     noremap = true,
--     silent = true,
--     desc = "Delete around quote",
--     callback = function()
--         handle_quote(true, "delete")
--     end,
-- })
--
-- vim.api.nvim_buf_set_keymap(0, 'n', 'ciq', '', {
--     noremap = true,
--     silent = true,
--     desc = "Change inside quote",
--     callback = function()
--         handle_quote(false, "change")
--     end,
-- })
--
-- vim.api.nvim_buf_set_keymap(0, 'n', 'caq', '', {
--     noremap = true,
--     silent = true,
--     desc = "Change around quote",
--     callback = function()
--         handle_quote(true, "change")
--     end,
-- })

-- ---Calculate concealed length at position for a specific line
-- ---@param line_num_1based integer 1-based line number
-- ---@param pos integer 1-based column position
-- local function get_concealed_line_length(line_num_1based, pos)
--     local bufnr = vim.api.nvim_get_current_buf()
--     local line_num = line_num_1based - 1 -- Convert to 0-based
--     -- Get the character under the cursor
--     local line = vim.api.nvim_buf_get_lines(0, line_num, line_num + 1, false)[1]
--     local filter = { syntax = false, treesitter = true, extmarks = false, semantic_tokens = false }
--
--     local concealed_length = 0
--     local in_conceal = false
--     local col = 0
--     local metadata = ""
--
--     while col < pos do
--         local nodes = vim.inspect_pos(bufnr, line_num, col, filter)
--         local is_concealed = false
--         local char = line:sub(col + 1, col + 1)
--
--         for _, node_info in ipairs(nodes.treesitter) do
--             if (node_info.capture or ''):match('conceal') then
--                 is_concealed = true
--                 if not in_conceal or node_info.metadata.conceal ~= metadata or char == "\\" then
--                     metadata = node_info.metadata.conceal
--                     in_conceal = true
--                     concealed_length = concealed_length + (metadata ~= "" and 1 or 0)
--                 end
--                 break
--             end
--         end
--
--         if not is_concealed then
--             concealed_length = concealed_length + 1
--             metadata = ""
--             in_conceal = false
--         end
--         col = col + 1
--     end
--
--     return concealed_length
-- end


-- Inserts a new line with proper alignment characters when in math environment
-- vim.keymap.set('i', '<CR>', function()
--     if not in_align() then
--         return "<CR>"
--     end
--
--     local cursor = vim.api.nvim_win_get_cursor(0)
--     local row = cursor[1] - 1 -- Convert to 0-based index
--     local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
--     if cursor[2] ~= #line then
--         return "<CR>"
--     end
--
--     local and_pos = line:find('&')
--     if not and_pos then
--         return "<CR>"
--     end
--
--     -- Exit Insert mode first
--     local escape = vim.api.nvim_replace_termcodes('<Esc>', true, true, true)
--     vim.api.nvim_feedkeys(escape, 'n', true)
--
--     -- Schedule buffer modifications after exiting Insert mode
--     vim.schedule(function()
--         local offset = and_pos - get_concealed_line_length(cursor[1], and_pos)
--         -- vim.api.nvim_echo({ { tostring(offset) } }, true, {})
--         -- Calculate indent and create new line
--         local indent = line:sub(1, and_pos - 1)
--         indent = indent:gsub("[^ \t]", " ")
--         indent = indent:sub(1, -(offset + 1))
--         local new_line = indent .. '& \\\\'
--
--         -- Insert the new line below the current line
--         vim.api.nvim_buf_set_lines(0, row + 1, row + 1, true, { new_line })
--
--         -- Move cursor to the new line and position after '&'
--         vim.api.nvim_win_set_cursor(0, { row + 2, #indent })
--         vim.api.nvim_feedkeys('a', 'n', false) -- Enter Insert mode after '&'
--     end)
--
--     -- Return nothing to prevent default <CR> behavior
--     return ""
-- end, {
--     expr = true,
--     buffer = 0,
--     noremap = true,
--     silent = true,
--     desc = "Insert new aligned line in LaTeX environment"
-- })

-- local function get_align_node()
--     local node = vim.treesitter.get_node({ ignore_injections = false })
--     while node and node:type() ~= "math_environment" do node = node:parent() end
--     if not node then return end
--
--     -- Verify environment type
--     local begin = node:child(0)
--     local names = begin and begin:field("name")
--     if not (names and names[1] and ALIGN_ENVS[get_node_text(names[1], 0):gsub("{(%w+)%s*%*?}", "%1")]) then
--         return nil
--     end
--
--     return node
-- end
--
-- local function normalize_align_environment(s_row, e_row)
--     local lines = vim.api.nvim_buf_get_lines(0, s_row, e_row, false)
--
--     -- Normalization-only processing
--     local normalized_lines = {}
--     for i, line in ipairs(lines) do
--         local indent = line:match('^(%s*)') or ''
--         local content = line:sub(#indent + 1)
--
--         -- Collapse whitespace around ampersands and multiple spaces
--         local processed = content:gsub('%s*&%s*', ' & ') -- Ensure single spaces around &
--             :gsub('^%s+', '')                            -- Trim leading spaces
--             :gsub('%s+$', '')                            -- Trim trailing spaces
--             :gsub('%s+', ' ')                            -- Collapse multiple spaces into one
--
--         normalized_lines[i] = indent .. processed
--     end
--
--     vim.api.nvim_buf_set_lines(0, s_row, e_row, false, normalized_lines)
-- end
--
-- local function align_ampersands(s_row, e_row)
--     local lines = vim.api.nvim_buf_get_lines(0, s_row, e_row, false)
--
--     -- Find the maximum concealed length before the ampersand
--     local max_concealed_length = 0
--     for i, line in ipairs(lines) do
--         local buf_line = s_row + i
--         local and_pos = line:find('&')
--         if and_pos then
--             local cl = get_concealed_line_length(buf_line, and_pos)
--             max_concealed_length = math.max(max_concealed_length, cl)
--         end
--     end
--
--     -- Apply alignment by adding padding to the head of each line
--     local aligned_lines = {}
--     for i, line in ipairs(lines) do
--         local buf_line = s_row + i
--         local and_pos = line:find('&')
--         if and_pos then
--             local cl = get_concealed_line_length(buf_line, and_pos)
--             local padding = string.rep(' ', max_concealed_length - cl)
--             -- Insert padding before the ampersand
--             local aligned_line = padding .. line
--             aligned_lines[i] = aligned_line
--         else
--             -- If there's no ampersand, keep the line as is
--             aligned_lines[i] = line
--         end
--     end
--
--     vim.api.nvim_buf_set_lines(0, s_row, e_row, false, aligned_lines)
-- end

-- Keymap to trigger alignment
-- vim.keymap.set('n', '<leader>la', function()
--     -- Get node and range first before any modifications
--     local node = get_align_node()
--     if not node then return end
--     local s_row, _, e_row, _ = node:range()
--
--     -- Wrap alignment in schedule to ensure buffer updates are processed
--     local align = vim.schedule_wrap(function()
--         align_ampersands(s_row, e_row)
--     end)
--
--     -- First normalization using captured range
--     normalize_align_environment(s_row, e_row)
--
--     align()
-- end, {
--     buffer = 0,
--     desc = 'Align & symbols in LaTeX environment with conceal awareness'
-- })
