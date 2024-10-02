local api = vim.api

local M = {}

local function create_floating_window()
	local width = 60
	local height = 10
	local bufnr = api.nvim_create_buf(false, true)
	local win_width = api.nvim_get_option("columns")
	local win_height = api.nvim_get_option("lines")

	local opts = {
		style = "minimal",
		relative = "editor",
		width = width,
		height = height,
		row = 1,
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
		"[Enter] Find Next    [Tab] Replace    [Ctrl+A] Replace All    [Esc] Close",
	})
	api.nvim_win_set_cursor(win, { 1, 6 })
	return bufnr, win
end

return M
