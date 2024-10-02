local api = vim.api
local config = require("find_replace.config")

local M = {}

local function create_floating_window()
	local width = config.get().window_width
	local height = config.get().window_height
	local bufnr = api.nvim_create_buf(false, true)
	local win_width = api.nvim_get_option("columns")
	local win_height = api.nvim_get_option("lines")

	local opts = {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = config.get().window_position == "top" and 1 or (win_height - height - 2),
		col = win_width - width - 1,
		border = "rounded",
	}

	local win = api.nvim_open_win(bufnr, true, opts)
	return bufnr, win
end

function M.setup_ui()
	local bufnr, win = create_floating_window()
	api.nvim_buf_set_lines(bufnr, 0, -1, false, {
		"Find: ",
		"Replace: ",
		"",
		"Case: [ ] Whole: [ ]",
		"",
		"[Enter] Find Next    [Tab] Replace    [Ctrl+A] Replace All",
		"[Ctrl+C] Toggle Case    [Ctrl+W] Toggle Whole Word",
		"[Ctrl+Z] Undo    [Ctrl+R] Redo    [Esc] Close",
	})
	api.nvim_win_set_cursor(win, { 1, 6 })
	return bufnr, win
end

function M.update_options(bufnr, case_sensitive, whole_word)
	local case_char = case_sensitive and "X" or " "
	local whole_char = whole_word and "X" or " "
	api.nvim_buf_set_lines(bufnr, 3, 4, false, { "Case: [" .. case_char .. "] Whole: [" .. whole_char .. "]" })
end

return M
