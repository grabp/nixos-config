return {
	{
		name = "Tests: E2E",
		icon = " ",
		priority = 1,
		color = "#d65d0e", -- gruvbox orange
		patterns = { "/tests/e2e", "/test/e2e", "/e2e" },
	},
	{
		name = "Tests: Integration",
		icon = " ",
		priority = 2,
		color = "#b57614", -- gruvbox yellow
		patterns = { "/tests/integration", "/test/integration" },
	},
	{
		name = "Tests: Unit",
		icon = " ",
		priority = 3,
		color = "#3d59a1", -- tokyonight dark blue
		patterns = { "/tests/unit", "/test/unit", "/__tests__" },
	},
	{
		name = "API",
		icon = "󰘦 ",
		priority = 4,
		color = "#0f6b82", -- dark sapphire/teal
		patterns = { "/api" },
	},
	{
		name = "Services",
		icon = "󰆧 ",
		priority = 5,
		color = "#8c2a72", -- dark pink/magenta
		patterns = { "/services", "/service" },
	},
	{
		name = "Domain",
		icon = " ",
		priority = 6,
		color = "#8c1a2e", -- dark crimson
		patterns = { "/domain" },
	},
	{
		name = "Infrastructure",
		icon = " ",
		priority = 7,
		color = "#2a6e30", -- dark forest green
		patterns = { "/infrastructure" },
	},
	{
		name = "Tests: Other",
		icon = " ",
		priority = 8,
		color = "#55379a", -- dark grape/mauve
		patterns = { "/test", "/tests", "%.test%.", "%.spec%." },
	},
}
