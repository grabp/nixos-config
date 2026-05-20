return {
	{
		"akinsho/bufferline.nvim",
		opts = function()
			local categories = require("lib.categories")

			-- Make groups mutually exclusive by priority: if any higher-priority category
			-- matches the buffer, this group yields. Needed because bufferline iterates
			-- groups via pairs() (unordered), so order in items[] doesn't determine winner.
			local function make_group(cat)
				return {
					name = cat.name,
					highlight = { sp = cat.color },
					priority = cat.priority,
					icon = cat.icon,
					matcher = function(buf)
						for _, other in ipairs(categories) do
							if other.priority < cat.priority then
								for _, p in ipairs(other.patterns) do
									if buf.path:match(p) then
										return false
									end
								end
							end
						end
						for _, p in ipairs(cat.patterns) do
							if buf.path:match(p) then
								return true
							end
						end
						return false
					end,
				}
			end

			local has_pyproject = vim.fn.filereadable(vim.fn.getcwd() .. "/pyproject.toml") == 1

			local python_groups = {
				options = {
					toggle_hidden_on_enter = true,
				},
				items = vim.list_extend(
					{ require("bufferline.groups").builtin.pinned:with({ icon = "󰐃 " }) },
					vim.list_extend(
						vim.tbl_map(make_group, categories),
						{ require("bufferline.groups").builtin.ungrouped }
					)
				),
			}

			local default_groups = {
				options = {
					toggle_hidden_on_enter = true,
				},
				items = {
					require("bufferline.groups").builtin.pinned:with({ icon = "󰐃 " }),
					require("bufferline.groups").builtin.ungrouped,
				},
			}

			return {
				options = {
					groups = has_pyproject and python_groups or default_groups,
				},
			}
		end,
	},
}
