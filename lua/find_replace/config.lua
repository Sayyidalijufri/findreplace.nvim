local M = {}

local default_config = {
	window_width = 60,
	window_height = 10,
	window_position = "top", -- "top" or "bottom"
}

M.config = vim.deepcopy(default_config)

function M.setup(user_config)
	M.config = vim.tbl_deep_extend("force", default_config, user_config or {})
end

function M.get()
	return M.config
end

return M
