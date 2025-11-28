return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"marilari88/neotest-vitest",
			"nvim-neotest/neotest-python",
			"nvim-neotest/neotest-python",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
		},
		keys = {
			{
				"<leader>td",
				function()
					require("neotest").run.run({ strategy = "dap" })
				end,
				desc = "Debug Nearest Test (neotest)",
			},
			{
				"<leader>tD",
				function()
					require("neotest").run.run({ vim.fn.expand("%"), strategy = "dap" })
				end,
				desc = "Debug File Tests (neotest)",
			},
		},
		opts = {
			adapters = {
				["neotest-vitest"] = {},
				["neotest-python"] = {
					dap = {
						justMyCode = false, -- Set to true to only debug your code, not dependencies
						type = "Active File",
					},
					runner = "pytest",
					pytest_discover_instances = true,
				},
			},
		},
	},
	{
		"mfussenegger/nvim-dap-python",
		ft = "python",
		dependencies = { "mfussenegger/nvim-dap" },
		keys = {
			{
				"<leader>dPt",
				function()
					require("dap-python").test_method()
				end,
				desc = "Debug Python Method",
				ft = "python",
			},
			{
				"<leader>dPc",
				function()
					require("dap-python").test_class()
				end,
				desc = "Debug Python Class",
				ft = "python",
			},
		},
		config = function()
			require("dap-python").setup("uv")
		end,
	},
	-- {
	--   "neovim/nvim-lspconfig",
	--   opts = {
	--     servers = {
	--       pyright = {
	--         capabilities = (function()
	--           local capabilities = vim.lsp.protocol.make_client_capabilities()
	--           capabilities.textDocument.publishDiagnostics.tagSupport.valueSet = { 2 }
	--           return capabilities
	--         end)(),
	--         settings = {
	--           python = {
	--             analysis = {
	--               disableOrganizeImports = true,
	--               diagnosticSeverityOverrides = {
	--                 reportUnusedVariable = "warning", -- or anything
	--               },
	--               typeCheckingMode = "basic",
	--             },
	--           },
	--         },
	--       },
	--       ruff = {
	--         cmd_env = { RUFF_TRACE = "messages" },
	--         init_options = {
	--           settings = {
	--             logLevel = "error",
	--           },
	--         },
	--         keys = {
	--           {
	--             "<leader>co",
	--             LazyVim.lsp.action["source.organizeImports"],
	--             desc = "Organize Imports",
	--           },
	--         },
	--       },
	--       ruff_lsp = {},
	--     },
	--     setup = {
	--       ["ruff"] = function()
	--         LazyVim.lsp.on_attach(function(client, _)
	--           --use ruff as a formatter and pyright as linter, type checker and hover provider
	--           client.server_capabilities.hoverProvider = false
	--           client.server_capabilities.diagnosticProvider = nil
	--         end, "ruff")
	--       end,
	--     },
	--   },
	-- },
}
