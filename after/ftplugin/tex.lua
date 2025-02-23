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

local math_delimiter_opening = { "\\(", "\\[" }
local math_delimiter_closing = { "\\)", "\\]" }

-- Visual mode
vim.api.nvim_buf_set_keymap(0, 'v', 'im', '', {
	noremap = true,
	silent = true,
	desc = "Inside math",
	callback = function() handle_latex(false, 'visual', math_delimiter_opening, math_delimiter_closing) end,
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
	"\\left(",     -- Parentheses
	"\\left[",     -- Square brackets
	"\\left{",     -- Curly braces (note: escaped with `\`)
	"\\left.",     -- Empty delimiter (no right delimiter)
	"\\left\\lbrack", -- Alternative square brackets
	"\\left\\lparen", -- Alternative parentheses
	"\\left\\langle", -- Angle brackets
	"\\left|",     -- Single vertical bar
	"\\left\\|",   -- Double vertical bars
	"\\left\\lfloor", -- Floor
	"\\left\\lceil", -- Ceiling
}

local right_delimiters = {
	"\\right)",     -- Parentheses
	"\\right]",     -- Square brackets
	"\\right}",     -- Curly braces (note: escaped with `\`)
	"\\right.",     -- Empty delimiter (no left delimiter)
	"\\right\\rbrack",     -- Alternative square brackets
	"\\right\\rparen", -- Alternative parentheses
	"\\right\\rangle", -- Angle brackets
	"\\right|",     -- Single vertical bar
	"\\right\\|",   -- Double vertical bars
	"\\right\\rfloor", -- Floor
	"\\right\\rceil", -- Ceiling
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
