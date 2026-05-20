return {
	"b0o/incline.nvim",
	event = "BufReadPre",
	config = function()
		local categories = require("lib.categories")
		local TEXT_FG = "#1e1e2e" -- catppuccin mocha base, readable on all category colors

		local function get_category(path)
			for _, cat in ipairs(categories) do
				for _, p in ipairs(cat.patterns) do
					if path:find(p) then
						return cat
					end
				end
			end
		end

		require("incline").setup({
			render = function(props)
				local path = vim.api.nvim_buf_get_name(props.buf)
				local fname = vim.fn.fnamemodify(path, ":t")
				if fname == "" then
					fname = "[No Name]"
				end

				local cat = get_category(path)
				if cat then
					return {
						{ " " .. cat.icon .. cat.name .. " ", guifg = TEXT_FG, guibg = cat.color },
						{ " " .. fname .. " " },
					}
				end
				return { { " " .. fname .. " " } }
			end,
		})
	end,
}
