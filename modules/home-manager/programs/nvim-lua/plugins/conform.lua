return {
	{
		"stevearc/conform.nvim",
		opts = {
			default_format_opts = {
				timeout_ms = 3000,
			},
			formatters_by_ft = {
				lua = { "stylua" },
				python = { "ruff", "isort" },
				javascript = { "biome", "biome-organize-imports" },
				typescript = { "biome", "biome-organize-imports" },
				typescriptreact = { "biome", "biome-organize-imports" },
				json = { "biome" },
			},
		},
	},
}
