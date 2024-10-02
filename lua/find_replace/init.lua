local ui = require("find_replace.ui")
local config = require("find_replace.config")

local M = {}

local function escape_pattern(text)
	return text:gsub("([^%w])", "%%%1")
end

local function get_search_pattern(word, case_sensitive, whole_word)
	local pattern = case_sensitive and "\\C" or "\\c"
	pattern = pattern .. (whole_word and "\\<" .. escape_pattern(word) .. "\\>" or escape_pattern(word))
	return pattern
end

local function find_word(word, case_sensitive, whole_word)
	if word == "" then
		return
	end
	local pattern = get_search_pattern(word, case_sensitive, whole_word)
	vim.fn.setreg("/", pattern)
	vim.fn.feedkeys("n", "n")
end

local function replace_single(find, replace, case_sensitive, whole_word)
	if find == "" or replace == "" then
		return
	end
	local pattern = get_search_pattern(find, case_sensitive, whole_word)
	vim.cmd("silent! normal! cgn" .. replace)
end

local function replace_all(find, replace, case_sensitive, whole_word)
	if find == "" or replace == "" then
		return
	end
	local pattern = get_search_pattern(find, case_sensitive, whole_word)
	vim.cmd("%s/" .. pattern .. "/" .. vim.fn.escape(replace, "/") .. "/ge")
end

local function highlight_matches(bufnr, pattern)
	vim.fn.clearmatches()
	local matches = vim.fn.getmatches()
	table.insert(matches, { group = "Search", pattern = pattern, priority = 10 })
	vim.fn.setmatches(matches)
end

function M.open()
	local bufnr, win = ui.setup_ui()
	local find = ""
	local replace = ""
	local case_sensitive = false
	local whole_word = false

	local function update_search()
		find = vim.fn.getline(1):sub(7)
		local pattern = get_search_pattern(find, case_sensitive, whole_word)
		highlight_matches(vim.api.nvim_get_current_buf(), pattern)
		find_word(find, case_sensitive, whole_word)
	end

	local function set_keymap(key, func)
		vim.api.nvim_buf_set_keymap(bufnr, "n", key, "", { noremap = true, silent = true, callback = func })
	end

	set_keymap("<CR>", function()
		local cursor = vim.api.nvim_win_get_cursor(win)
		if cursor[1] == 1 then
			update_search()
		elseif cursor[1] == 2 then
			replace = vim.fn.getline(2):sub(10)
		end
	end)

	set_keymap("<Tab>", function()
		replace = vim.fn.getline(2):sub(10)
		replace_single(find, replace, case_sensitive, whole_word)
	end)

	set_keymap("<C-a>", function()
		replace = vim.fn.getline(2):sub(10)
		replace_all(find, replace, case_sensitive, whole_word)
	end)

	set_keymap("<C-c>", function()
		case_sensitive = not case_sensitive
		ui.update_options(bufnr, case_sensitive, whole_word)
		update_search()
	end)

	set_keymap("<C-w>", function()
		whole_word = not whole_word
		ui.update_options(bufnr, case_sensitive, whole_word)
		update_search()
	end)

	set_keymap("<C-z>", function()
		vim.cmd("undo")
	end)

	set_keymap("<C-r>", function()
		vim.cmd("redo")
	end)

	set_keymap("<Esc>", function()
		vim.fn.clearmatches()
		vim.api.nvim_win_close(win, true)
	end)
end

return M
