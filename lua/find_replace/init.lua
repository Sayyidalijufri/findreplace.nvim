local ui = require("find_replace.ui")

local M = {}

local function find_word(word)
	if word == "" then
		return
	end
	vim.fn.setreg("/", "\\V" .. vim.fn.escape(word, "/\\"))
	vim.fn.feedkeys("n", "n")
end

local function replace_single(find, replace)
	if find == "" or replace == "" then
		return
	end
	vim.fn.execute("silent! normal! cgn" .. replace)
end

local function replace_all(find, replace)
	if find == "" or replace == "" then
		return
	end
	vim.fn.execute("%s/\\V" .. vim.fn.escape(find, "/\\") .. "/" .. vim.fn.escape(replace, "/") .. "/g")
end

function M.open()
	local bufnr, win = ui.setup_ui()
	local find = ""
	local replace = ""

	local function set_keymap(key, func)
		vim.api.nvim_buf_set_keymap(bufnr, "n", key, "", { noremap = true, silent = true, callback = func })
	end

	set_keymap("<CR>", function()
		local cursor = vim.api.nvim_win_get_cursor(win)
		if cursor[1] == 1 then
			find = vim.fn.getline(1):sub(7)
			find_word(find)
		elseif cursor[1] == 2 then
			replace = vim.fn.getline(2):sub(10)
		end
	end)

	set_keymap("<Tab>", function()
		replace = vim.fn.getline(2):sub(10)
		replace_single(find, replace)
	end)

	set_keymap("<C-a>", function()
		replace = vim.fn.getline(2):sub(10)
		replace_all(find, replace)
	end)

	set_keymap("<Esc>", function()
		vim.api.nvim_win_close(win, true)
	end)
end

return M
