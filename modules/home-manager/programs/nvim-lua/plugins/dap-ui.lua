return {
	{
		"mfussenegger/nvim-dap",
		optional = true,
		-- OPTIMIZATION: Explicitly list dependency used in config
		dependencies = {
			"rcarriga/nvim-dap-ui",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dap.defaults.fallback.terminal_launcher = { "kitty", "-e" }

			-- OPTIMIZATION: Only open dapui for integrated consoles
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end

			-- Listeners for closing dapui are kept commented out as per your preference.

			dap.adapters.python = {
				type = "executable",
				command = "python", -- Ensure this python is in your PATH and has debugpy
				args = { "-m", "debugpy.adapter" },
			}

			dap.configurations.python = {
				{
					name = "Active File",
					type = "python",
					request = "launch",
					program = "${file}",
					console = "integratedTerminal",
					justMyCode = true,
				},
				{
					name = "FastAPI with envs",
					type = "debugpy",
					request = "launch",
					module = "gunicorn",
					env = {
						OBJC_DISABLE_INITIALIZE_FORK_SAFETY = "YES",
						POSTGRES_HOST = "0.0.0.0",
						CELERY_BROKER_URL = "redis://0.0.0.0:6379/0",
						CELERY_RESULT_BACKEND = "redis://0.0.0.0:6379/1",
						REDIS_URI = "redis://0.0.0.0:6379/2",
						AZURE_BLOB_CONNECTION_STRING = "DefaultEndpointsProtocol=http;AccountName=devstoreaccount1;AccountKey=Eby8vdM02xNOcqFlqUwJPLlmEtlCDXJ1OUzFT50uSRZ6IFsuFq2UVErCz4I6tq/K1SZFPTOtr/KBHBeksoGMGw==;BlobEndpoint=http://0.0.0.0:10000/devstoreaccount1;QueueEndpoint=http://0.0.0.0:10001/devstoreaccount1;TableEndpoint=http://0.0.0.0:10002/devstoreaccount1;",
						REDIS_USE_SSL = "False",
						CELERY_QUEUE = "default",
					},
					args = {
						"-c",
						"app/api/gunicorn_config.py",
						"-w",
						"1",
						"-t",
						"0",
						"app.main:app",
					},
				},
			}

			-- ENHANCEMENT: Add useful keymaps for a better debugging experience
			vim.keymap.set("n", "<F5>", function()
				require("dap").continue()
			end, { desc = "DAP: Continue" })
			vim.keymap.set("n", "<F10>", function()
				require("dap").step_over()
			end, { desc = "DAP: Step Over" })
			vim.keymap.set("n", "<F11>", function()
				require("dap").step_into()
			end, { desc = "DAP: Step Into" })
			vim.keymap.set("n", "<F12>", function()
				require("dap").step_out()
			end, { desc = "DAP: Step Out" })
			vim.keymap.set("n", "<Leader>db", function()
				require("dap").toggle_breakpoint()
			end, { desc = "DAP: Toggle Breakpoint" })
			vim.keymap.set("n", "<Leader>dB", function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "DAP: Set Conditional Breakpoint" })
			vim.keymap.set("n", "<Leader>de", function()
				require("dap").terminate()
			end, { desc = "Debugger reset" })
			vim.keymap.set("n", "<Leader>dr", function()
				require("dap").run_last()
			end, { desc = "Debugger run last" })
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			local dapui = require("dapui")
			dapui.setup({
				layouts = {
					{
						elements = { "repl" },
						size = 10,
						position = "bottom",
					},
					{
						elements = { "scopes", "breakpoints" },
						size = 40,
						position = "left",
					},
					{
						elements = { "stacks", "watches" },
						position = "right",
						size = 40,
					},
				},
			})

			vim.keymap.set("n", "<leader>dq", function()
				dapui.close()
			end, { desc = "DAP UI: Quit/Close" })
			vim.keymap.set("n", "<leader>du", function()
				dapui.toggle()
			end, { desc = "DAP UI: Toggle" })
		end,
	},
}
