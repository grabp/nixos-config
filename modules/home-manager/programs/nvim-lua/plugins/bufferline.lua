return {
	{
		"akinsho/bufferline.nvim",
		opts = function()
			-- Check if this is a Python project by looking for pyproject.toml
			local has_pyproject = vim.fn.filereadable(vim.fn.getcwd() .. "/pyproject.toml") == 1

			-- Define Python-specific buffer groups
			local python_groups = {
				options = {
					toggle_hidden_on_enter = true,
				},
				items = {
					-- Pinned buffers at the very start
					require("bufferline.groups").builtin.pinned:with({ icon = "󰐃 " }),
					-- Tests - E2E group
					{
						name = "Tests: E2E",
						highlight = { underline = true, sp = "#fab387" }, -- peach color
						priority = 1,
						icon = " ",
						matcher = function(buf)
							return buf.path:match("/tests/e2e") or buf.path:match("/test/e2e") or buf.path:match("/e2e")
						end,
					},
					-- Tests - Integration group
					{
						name = "Tests: Integration",
						highlight = { underline = true, sp = "#f9e2af" }, -- yellow color
						priority = 2,
						icon = " ",
						matcher = function(buf)
							return buf.path:match("/tests/integration") or buf.path:match("/test/integration")
						end,
					},
					-- Tests - Unit group
					{
						name = "Tests: Unit",
						highlight = { underline = true, sp = "#89b4fa" }, -- blue color
						priority = 3,
						icon = " ",
						matcher = function(buf)
							return buf.path:match("/tests/unit")
								or buf.path:match("/test/unit")
								or buf.path:match("/__tests__")
						end,
					},
					-- API group
					{
						name = "API",
						highlight = { underline = true, sp = "#74c7ec" }, -- sapphire color
						priority = 4,
						icon = "󰘦 ",
						matcher = function(buf)
							return buf.path:match("/api")
						end,
					},
					-- Services group
					{
						name = "Services",
						highlight = { underline = true, sp = "#f5c2e7" }, -- pink color
						priority = 5,
						icon = "󰆧 ",
						matcher = function(buf)
							return buf.path:match("/services") or buf.path:match("/service")
						end,
					},
					-- Domain group
					{
						name = "Domain",
						highlight = { underline = true, sp = "#f38ba8" }, -- rosewater color
						priority = 6,
						icon = " ",
						matcher = function(buf)
							return buf.path:match("/domain")
						end,
					},
					-- Infrastructure group
					{
						name = "Infrastructure",
						highlight = { underline = true, sp = "#a6e3a1" }, -- green color
						priority = 7,
						icon = " ",
						matcher = function(buf)
							return buf.path:match("/infrastructure")
						end,
					},
					-- Ungrouped buffers (catch-all)
					require("bufferline.groups").builtin.ungrouped,
					-- Tests - Other (catch-all for any other test files)
					{
						name = "Tests: Other",
						highlight = { underline = true, sp = "#cba6f7" }, -- mauve color
						priority = 8,
						icon = " ",
						matcher = function(buf)
							return buf.path:match("/test")
								or buf.path:match("/tests")
								or buf.path:match("%.test%.")
								or buf.path:match("%.spec%.")
						end,
					},
				},
			}

			-- Default groups for non-Python projects (just pinned + ungrouped)
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
